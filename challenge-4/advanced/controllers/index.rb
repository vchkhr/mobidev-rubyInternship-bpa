# frozen_string_literal: true

require_relative 'render'

# Frontpage
class Index
  include Render

  def call(_env)
    render_template 'views/index.html.erb'
  end
end
