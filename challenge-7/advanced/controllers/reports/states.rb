# frozen_string_literal: true

require_relative '../render'

# States Report
class StatesReport
  include Render

  def call(env)
    @state_needed = env['router.params'][:id]
    @state_needed&.upcase!

    @states = @@App.report_states(@state_needed)

    render_template 'views/reports/states.html.erb'
  end
end
