# frozen_string_literal: true

require_relative 'db/db'

dbname = "bpa"
user = "postgres"
password = "pass"

DB = Db.new(dbname, user, password)
