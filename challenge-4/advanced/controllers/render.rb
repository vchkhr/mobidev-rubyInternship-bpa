# frozen_string_literal: true

# Help module for generating proper Rack responses
module Render
  def render_template(str)
    template = File.read(str)
    body = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [body.result(binding)]]
  end
end
