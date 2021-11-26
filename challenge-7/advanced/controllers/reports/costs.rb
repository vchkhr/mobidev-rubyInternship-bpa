# frozen_string_literal: true

require_relative '../render'

# Costs Report
class CostsReport
  include Render

  def call(_env)
    @costs = @@App.report_costs

    render_template 'views/reports/costs.html.erb'
  end
end
