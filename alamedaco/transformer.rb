# This is an awful way to do this and there must be a faster way.
# I should follow up with James from OpenNorth/pupa-ruby to see if this
# can be fit into the pupa framework removing the dependency from mongoid
# and make the code better integrated/faster. 
# Thoughts:
# 1. Get the structure being built here to be done during the scraping process.
# 1a. Can you even nest json documents or is it just acting as an ORM and auto
#     fetching?

require 'mongoid'

Mongoid.load!('mongoid.yml', :development)

class Location
  include Mongoid::Document
end

class Organization
  include Mongoid::Document
end

class Address
  include Mongoid::Document
end

orgs = {}
addrs = {}

Location.all.each do |loc|
  org = Organization.find(loc[:organization_id])
  addr = Address.find(loc[:address_id])
  if orgs[org].nil?
    orgs[org] = [loc]
  else
    orgs[org] << loc
  end
  addrs[loc] = addr
end

json_file = File.open('alamedaco.json', 'w+')
orgs.each do |org, locs|
  org_hash = {}
  org_hash['name'] = org[:name]
  locs.each do |loc|
    loc_hash = {}
    loc_hash['name'] = loc[:name]
    loc_hash['description'] = loc[:description]
    loc_hash['short_desc'] = loc[:short_desc]
    addr = addrs[loc]
    loc_hash['address'] = {
      'street' => addr[:street],
      'city'   => addr[:city],
      'state'  => addr[:state],
      'zip'    => addr[:zip]
    }
    org_hash['locs'] ||= []
    org_hash['locs'] << loc_hash
  end
  json_file.puts(org_hash.to_json)
end
