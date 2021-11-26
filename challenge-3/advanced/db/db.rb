# frozen_string_literal: true

require 'pg'
require_relative '../env.rb'
require_relative 'remove_tables'
require_relative 'add_tables'
require_relative '../parse/parse'

class Db
  include Env
  include RemoveTables
  include AddTables
  include Parse
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
