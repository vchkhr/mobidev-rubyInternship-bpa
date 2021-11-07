require_relative 'render'
require_relative '../db/db.rb'

DB = Db.new

class Delete
  include Render

  def call(_env)
    DB.remove_tables

    render_template 'views/delete.html.erb'
  end
end
