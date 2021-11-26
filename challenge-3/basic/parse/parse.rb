# frozen_string_literal: true

require 'csv'
require_relative 'parse_offices'
require_relative 'parse_rooms'
require_relative 'parse_fixtures'
require_relative 'parse_materials'

module Parse
  include ParseOffices
  include ParseRooms
  include ParseFixtures
  include ParseMaterials

  def parse
    @csv = CSV.read('./data.csv', headers: true)

    parse_offices
    parse_rooms
    parse_fixtures
    parse_materials
  end
end
