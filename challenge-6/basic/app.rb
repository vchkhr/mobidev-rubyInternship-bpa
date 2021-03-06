# frozen_string_literal: true

require_relative 'db/db'

dbname = ''
user = ''
password = ''

if dbname.empty? && user.empty? && password.empty?
  puts 'Enter `dbname`, `user` and `password` in the `app.rb` file.'
else
  DB = Db.new(dbname, user, password)
end
