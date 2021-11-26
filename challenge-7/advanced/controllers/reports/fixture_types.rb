# frozen_string_literal: true

require_relative '../render'

# Fixture Types Report
class FixtureTypesReport
  include Render

  def call(env)
    @office = env['router.params'][:id]
    @office&.upcase!

    @types, @office_name = @@App.report_fixture_types(@office)

    render_template 'views/reports/fixture_types.html.erb'
  end
end
