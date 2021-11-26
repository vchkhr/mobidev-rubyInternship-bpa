# frozen_string_literal: true

require 'pg'
require_relative '../env'
require_relative 'remove_tables'
require_relative 'add_tables'
require_relative '../parse/parse'
require_relative '../reports/states'

# Database class
class Db
  include Env
  include RemoveTables
  include AddTables
  include Parse
  include ReportStates
  attr_accessor :con, :csv, :dbname, :user, :password

  def initialize
    read_env
    @con = PG.connect(dbname: @dbname, user: @user, password: @password)
  end

  def connect(file)
    remove_tables
    add_tables
    parse(file)
  end
end
