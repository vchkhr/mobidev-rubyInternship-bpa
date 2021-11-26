require_relative 'render'

class Index
  include Render

  def call(_env)
    render_template 'views/index.html.erb'
  end
end
