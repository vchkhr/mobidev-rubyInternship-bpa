# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

# Generates state reports
module ReportStates
  def report_states(state)
    offices = @con.exec('SELECT * FROM offices ORDER BY state;')

    report_states_body(state, offices)
  end

  def report_states_body(state_needed, offices)
    body = ''
    state = ''

    offices.each do |office|
      next if !state_needed.nil? && state_needed != office['state']

      if state != office['state']
        body += '</tbody></table>' if state != ''

        state = office['state']

        body += "<h2 class='mt-5'>"
        body += state_needed.nil? ? "<a href='/reports/states/#{state}'>#{state}</a>" : state.to_s
        body += "</h2><table class='table'><thead><tr><th>Office</th><th>Type</th><th>Address</th><th>LOB</th></tr></thead><tbody>"
      end

      office_str = '<tr>'
      office_str += "<td>#{office['name']}</td>"
      office_str += "<td>#{office['type']}</td>"
      office_str += "<td>#{office['address']}</td>"
      office_str += "<td>#{office['lob']}</td>"
      office_str += '</tr>'

      body += office_str
    end

    if body.empty?
      ''
    else
      body += '</tbody></table>'
    end
  end
end
