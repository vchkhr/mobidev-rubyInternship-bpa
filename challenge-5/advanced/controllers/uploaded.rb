# frozen_string_literal: true

require_relative 'render'

# Success CSV upload
class Uploaded
  include Render

  def call(_env)
    render_template 'views/uploaded.html.erb'
  end
end
