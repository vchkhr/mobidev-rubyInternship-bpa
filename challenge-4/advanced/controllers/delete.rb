# frozen_string_literal: true

require_relative 'render'
require_relative '../db/db'

DB = Db.new

# Delete tables and data in database
class Delete
  include Render

  def call(_env)
    DB.remove_tables

    render_template 'views/delete.html.erb'
  end
end
