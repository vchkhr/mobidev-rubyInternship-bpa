# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength

# Generates States Report
module ReportStates
  def report_states(state_needed)
    offices = if state_needed.nil?
                @con.exec('SELECT * FROM offices ORDER BY state;')
              else
                @con.exec_params('SELECT * FROM offices WHERE state=$1', [state_needed])
              end

    offices_result = {}

    offices.each do |office|
      offices_result[office['state']] = [] unless offices_result.key?(office['state'])

      offices_result[office['state']] << { name: office['name'], type: office['type'], address: office['address'], lob: office['lob'] }
    end

    offices_result
  end
end
