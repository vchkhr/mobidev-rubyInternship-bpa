# frozen_string_literal: true

require_relative 'states'
require_relative 'fixtures'
require_relative 'costs'

# Generates reports
module Report
  include ReportStates
  include ReportFixtureTypes
  include ReportCosts
end
