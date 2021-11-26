require_relative 'render'

class Uploaded
  include Render

  def call(_env)
    render_template 'views/uploaded.html.erb'
  end
end
