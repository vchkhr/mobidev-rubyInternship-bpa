# frozen_string_literal: true

require_relative 'db/db'

dbname = ""
user = ""
password = ""

DB = Db.new(dbname, user, password)
