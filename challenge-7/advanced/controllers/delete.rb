# frozen_string_literal: true

require_relative 'render'

# Delete tables and data in database
class Delete
  include Render

  def call(_env)
    @@App.remove_tables

    render_template 'views/delete.html.erb'
  end
end
