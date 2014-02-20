require 'pupa'
require 'nokogiri'

class Category
  include Pupa::Model

  attr_accessor :id, :name, :description

  dump :id, :name, :description

  def fingerprint
    to_h.slice(:id)
  end

  def to_s
    name + " - " + description
  end
end

class AlamedacoProcessor < Pupa::Processor
  def scrape_categories
    categories_page.each do |node|
      category  = Category.new
      category.id = extract_id node
      category.name = extract_name node
      category.description = extract_description node
      dispatch category
    end
  end

  def categories_page
    get('http://www.alamedaco.info/resource/searchbykey.cfm?sw=A&x=0&y=0').
      css('a.bold')
  end

  def extract_description(node)
    id = extract_id node
    page = description_page id
    remove_desc_html page
  end

  def description_page(id)
    get "http://www.alamedaco.info/resource/popDescrip.cfm?id=#{id}"
  end

  def extract_id(node)
    node['href'].split('=')[1].to_i
  end

  def extract_name(node)
    node.content
  end

  def remove_desc_html(page)
    page.search('//td/text()[preceding-sibling::br]')[0].content.strip
  end
end

AlamedacoProcessor.add_scraping_task(:categories)
runner = Pupa::Runner.new(AlamedacoProcessor)
runner.run(ARGV)
