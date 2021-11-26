# frozen_string_literal: true

require 'pg'
require_relative 'env'
require_relative 'db/remove_tables'
require_relative 'db/add_tables'
require_relative 'parse'
require_relative 'reports/report'

# Database class
class App
  include Env
  include RemoveTables
  include AddTables
  include Parse
  include Report
  attr_accessor :con, :csv, :dbname, :user, :password

  def initialize
    read_env
    return if @dbname.empty? && @user.empty? && @password.empty?

    @con = PG.connect(dbname: @dbname, user: @user, password: @password)
  end

  def connect(file)
    return if @dbname.empty? && @user.empty? && @password.empty?

    remove_tables
    add_tables
    parse(file)
  end
end
