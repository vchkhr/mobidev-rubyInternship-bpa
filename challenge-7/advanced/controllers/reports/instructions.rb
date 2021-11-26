# frozen_string_literal: true

require_relative '../render'

# Fixture Types Report
class Instructions
  include Render

  def call(env)
    @office = env['router.params'][:id]
    @office&.upcase!

    @instructions, @office = @@App.report_instructions(@office)

    render_template 'views/reports/instructions.html.erb'
  end
end
