# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

# Generates States Report
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
        state = office['state']

        body += "<tr style='border-bottom: 1px solid black'><th colspan='4'><h2 class='mt-5'>"
        body += state_needed.nil? ? "<a href='/reports/states/#{state}'>#{state}</a>" : state.to_s
        body += '</h2></th></tr><tr><td><strong>Office</strong></td><td><strong>Type</strong></td><td><strong>Address</strong></td><td><strong>LOB</strong></td></tr>'
      end

      office_str = '<tr>'
      office_str += "<td>#{office['name']}</td>"
      office_str += "<td>#{office['type']}</td>"
      office_str += "<td>#{office['address']}</td>"
      office_str += "<td>#{office['lob']}</td>"
      office_str += '</tr>'

      body += office_str
    end

    body = "<table class='table'>#{body}</table>" unless body.empty?

    body
  end
end
