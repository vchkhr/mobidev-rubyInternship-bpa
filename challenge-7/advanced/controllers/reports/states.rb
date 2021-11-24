# frozen_string_literal: true

require_relative '../render'

# States Report
class StatesReport
  include Render

  def call(env)
    @state = env['router.params'][:id]
    @state&.upcase!

    @offices = @@App.report_states(@state)

    render_template 'views/reports/states.html.erb'
  end
end
