# frozen_string_literal: true

require_relative 'render'

# Frontpage
class Index
  include Render

  def call(_env)
    render_template @@DB.con.nil? ? 'views/db-error.html.erb' : 'views/index.html.erb'
  end
end
