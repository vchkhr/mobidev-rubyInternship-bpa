# frozen_string_literal: true

require_relative 'states'
require_relative 'fixtures'
require_relative 'costs'
require_relative 'instructions'

# Generates reports
module Report
  include ReportStates
  include ReportFixtureTypes
  include ReportCosts
  include InstructionsGen
end
