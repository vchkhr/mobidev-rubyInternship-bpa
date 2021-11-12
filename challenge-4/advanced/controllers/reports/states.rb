# frozen_string_literal: true

require_relative '../render'
require_relative '../../db/db'

DB = Db.new

# States report
class StatesReport
  include Render

  def call(env)
    @state = env['router.params'][:id]
    @state&.upcase!

    @offices = DB.report_states(@state)

    render_template 'views/reports/states.html.erb'
  end
end
