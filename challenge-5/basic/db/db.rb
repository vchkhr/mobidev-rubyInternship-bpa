# frozen_string_literal: true

require 'pg'
require_relative 'remove_tables'
require_relative 'add_tables'
require './parse/parse'
require './reports/reports'

# Database class
class Db
  include RemoveTables
  include AddTables
  include Parse
  include Reports

  attr_accessor :con, :csv

  def initialize(dbname, user, password)
    @con = PG.connect(dbname: dbname, user: user, password: password)

    remove_tables
    add_tables
    parse

    reports
  end
end
