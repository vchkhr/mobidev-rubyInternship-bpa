# frozen_string_literal: true

require_relative '../render'

# States report
class FixtureTypesReport
  include Render

  def call(env)
    @office = env['router.params'][:id]
    @office&.upcase!

    @types, @office_name = @@DB.report_fixture_types(@office)

    render_template 'views/reports/fixture_types.html.erb'
  end
end
