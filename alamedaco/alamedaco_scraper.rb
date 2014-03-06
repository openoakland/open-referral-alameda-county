require 'pupa'
require 'nokogiri'

class String
  def blank?
    self !~ /[^[:space:]]/
  end
end

module ExtractionHelpers
  def extract_id(node)
    node['href'].split('=')[1]
  end
end

class Category
  include Pupa::Model
  include Pupa::Concerns::Timestamps
  include ExtractionHelpers

  @all = []

  attr_accessor :sw_id, :name

  dump :sw_id, :name

  def set_properties(node)
    @sw_id = extract_id node
    @name = node.content
  end

  def fingerprint
    to_h.slice(:sw_id)
  end

  def to_s
    name
  end

class << self
  def all
    @all
  end

  def add(category)
    @all << category
  end
end

private

  def extract_description(id)
    page = category_description id
    remove_desc_html page
  end

  def remove_desc_html(page)
    page.search('//td/text()[preceding-sibling::br]')[0].content.strip
  end
end

class Organization
  include Pupa::Model

  @all = {}

  attr_accessor :name
  attr_reader :locations

  dump :name, :locations

  def set_properties(node)
    @name = extract_name(node)
  end

  def valid?
    valid_name?
  end

  def valid_name?
    !@name.blank?
  end

  def seen?
    Organization.find_by_name(@name)
  end

  def add_location(location)
    @locations ||= []
    @locations << location
  end

  def fingerprint
    to_h.slice(:name)
  end

  def to_s
    name
  end

class << self
  def all
    @all.values
  end

  def find_by_name(name)
    @all[name]
  end

  def add(organization)
    @all[organization.name] = organization
  end
end

private
  def extract_name(node)
    node.content.split("|").first.strip
  end
end

class Location
  include Pupa::Model
  include ExtractionHelpers

  @all =  {}

  foreign_key :address_id, :organization_id
  foreign_object :address, :organization

  attr_accessor :sw_id, :name, :address_id, :organization_id, :organization,
    :short_desc, :description, :detailed_info, :overview
  attr_reader :address, :organization

  dump :sw_id, :name, :address_id, :address, :organization_id, :organization, 
    :short_desc, :description

  def set_properties(node)
    @name = extract_name(node)
    @short_desc = extract_description(:short, @overview)
    @description = extract_description(:long, @detailed_info)
  end

  def set_foreign_keys(address, organization)
    @address_id = address._id
    @organization_id = Organization.find_by_name(organization.name)._id
  end

  def seen?
    Location.find_by_id(@sw_id)
  end
  
  def valid?
    !(@name.blank? || @short_desc.blank? || @description.blank? || @short_desc.length > 200)
  end

  def fingerprint
    to_h.slice(:sw_id)
  end

  def address_factory
    Address.new.extract(@detailed_info)
  end

class << self
  def all
    @all.values
  end

  def add(location)
    @all[location.sw_id] = location
  end

  def find_by_id(sw_id)
    @all[sw_id]
  end
end

private
  def extract_name(node)
    possible_names = node.content.split("|")
    index = possible_names.size - 1
    return possible_names[index].strip unless possible_names[index].blank?
    return possible_names[index - 1].strip unless possible_names[index - 1].blank?
    return possible_names[index - 2].strip unless possible_names[index - 2].blank?
  end

  def extract_description(type, page)
    page.search('[text()*="Description"] ~ *')[type == :short ? 2 : 1].content.strip
  end
end


class Address
  include Pupa::Model

  attr_accessor :street, :city, :state, :zip
  dump :street, :city, :state, :zip

  def extract(detailed_info)
    begin 
      address = find_address(detailed_info)
      set_properties(address)
      @valid = true
    rescue
      # add logging logic
      @valid = false
    end
    self
  end

  def valid?
    @valid
  end
  
  def set_properties(address)
    addr = hashify(address)
    @street = addr[:street].strip
    @city = addr[:city]
    @state = addr[:state]
    @zip = addr[:zip]
  end


  def to_s
    <<-ADDRESS
    #{street}
    #{city}, #{state} #{zip}
    ADDRESS
  end

private
  def find_address(detailed_info)
    detailed_info.search('span[@class="bold"][text()*="Address"]')[0].parent.parent.next_sibling.content.strip
  end

  def hashify(address)
    /\A(?<street>.*)\s*(?<city>.*), (?<state>\w{2}) (?<zip>\d{5})/.match(address)
  end
end

class AlamedacoProcessor < Pupa::Processor
  def scrape_categories
    categories_page.each do |node|
      category  = Category.new
      category.set_properties(node)
      Category.add(category)
      dispatch category
    end
  end

  def scrape_organizations
    Category.all.each do |cat|
      locations(cat).each do |node|
        organization = Organization.new 
        organization.set_properties(node)
        # need to deal with this better because some title start with |
        if organization.valid? && !organization.seen?
          Organization.add(organization)
          dispatch organization 
        end

        location = Location.new
        location.sw_id = location.extract_id(node)
        location.detailed_info = detailed_info(location)
        address = location.address_factory

        if organization.valid? && !location.seen? && address.valid?
          location.overview = overview(location)
          location.set_properties(node)
          organization = Organization.find_by_name(organization.name)
          organization.add_location(location)
          location.set_foreign_keys(address, organization)
          if location.valid?
            Location.add(location)
            dispatch address
            dispatch location
          end
        end
      end
    end
  end

  def categories_page
    get("http://www.alamedaco.info/resource/searchbykey.cfm?sw=A&x=0&y=0").
      css('a[href^="tax_listall.cfm?sw="]')
  end

  def overview(location)
    get "http://www.alamedaco.info/resource/agency.cfm?pid=#{location.sw_id}&page=1"
  end

  def detailed_info(location)
    get "http://www.alamedaco.info/resource/agencydetail.cfm?pid=#{location.sw_id}&page=2"
  end

  def locations(category)
    get("http://www.alamedaco.info/resource/tax_listall.cfm?sw=#{category.sw_id}").
      css('a[href^="agency.cfm?pid="]')
  end
end
AlamedacoProcessor.add_scraping_task(:categories)
AlamedacoProcessor.add_scraping_task(:organizations)
runner = Pupa::Runner.new(AlamedacoProcessor, expires_in: 60 * 60 * 24 * 30)
runner.run(ARGV)
