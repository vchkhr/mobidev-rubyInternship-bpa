# frozen_string_literal: true

# rubocop:disable Metrics/VariableName
# rubocop:disable Metrics/ClassVars

require_relative '../app'

# Help module for generating proper Rack responses
module Render
  @@App = App.new

  def render_template(str)
    template = File.read(str)
    body = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [body.result(binding)]]
  end
end
