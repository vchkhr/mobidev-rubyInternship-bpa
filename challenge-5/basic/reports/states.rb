# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength

# Generates states report
module ReportStates
  def report_states
    offices = @con.exec('SELECT * FROM offices ORDER BY state;')

    body = ''
    body += report_states_body(offices)

    report = @template.gsub('{TITLE}', 'States Report').gsub('{BODY}', body)

    File.open('html/states.html', 'w') { |file| file.write(report) }
  end

  def report_states_body(offices)
    body = ''
    state = ''

    offices.each do |office|
      if state != office['state']
        body += '</tbody></table>' if state != ''

        state = office['state']

        body += "<h2 class='mt-5'>#{state}</h2><table class='table'><thead><tr><th>Office</th><th>Type</th><th>Address</th><th>LOB</th></tr></thead><tbody>"
      end

      office_str = '<tr>'
      office_str += "<td>#{office['name']}</td>"
      office_str += "<td>#{office['type']}</td>"
      office_str += "<td>#{office['address']}</td>"
      office_str += "<td>#{office['lob']}</td>"
      office_str += '</tr>'

      body += office_str
    end

    body += '</tbody></table>'
  end
end
