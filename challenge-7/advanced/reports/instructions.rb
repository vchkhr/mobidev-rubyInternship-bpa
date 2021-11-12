# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

# Generates Installation Instructions
module InstructionsGen
  def report_instructions(office_needed)
    if office_needed.nil?
      offices = @con.exec('SELECT * FROM offices ORDER BY state;')

      report_instructions_list_offices_body(offices)
    else
      materials = @con.exec('SELECT * FROM materials ORDER BY type;')

      fixtures = []
      @con.exec('SELECT * FROM fixtures').each do |fixture|
        fixtures << { id: fixture['id'], name: fixture['name'], room: fixture['room_id'], type: fixture['type'] }
      end

      rooms = []
      @con.exec('SELECT * FROM rooms').each do |room|
        rooms << { id: room['id'], name: room['name'], office: room['office_id'], area: room['area'], max_people: room['max_people'], zone: room['zone'] }
      end

      office = @con.exec("SELECT * FROM offices WHERE id = #{office_needed}")

      if office.num_tuples.zero?
        ['', office_needed]
      else
        office = office[0]

        instructions_body(materials, fixtures, rooms, office)
      end
    end
  end

  def report_instructions_list_offices_body(offices)
    body = ''
    state = ''

    offices.each do |office|
      if state != office['state']
        state = office['state']

        body += "<tr style='border-bottom: 1px solid black'><th colspan='4'><h2 class='mt-5'>#{state}</a></h2></th></tr><tr><td><strong>Office</strong></td><td><strong>Type</strong></td><td><strong>Address</strong></td><td><strong>LOB</strong></td></tr>"
      end

      office_str = '<tr>'
      office_str += "<td><a href='/instructions/offices/#{office['id']}'>#{office['name']}</a></td>"
      office_str += "<td>#{office['type']}</td>"
      office_str += "<td>#{office['address']}</td>"
      office_str += "<td>#{office['lob']}</td>"
      office_str += '</tr>'

      body += office_str
    end

    body = "<h6 class='mt-5'>Select the office to continue:</h6><table class='table'>#{body}</table>" unless body.empty?

    [body, '']
  end

  def instructions_body(materials, fixtures, rooms, office)
    groups = {}
    area = 0
    max_people = 0

    rooms.each do |room|
      next unless room[:office] == office['id']

      room[:materials] = {}
      groups[room[:zone]] = {} unless groups.key?(room[:zone])
      groups[room[:zone]][room[:id]] = room

      area += Integer(room[:area])
      max_people += Integer(room[:max_people])
    end

    materials.each do |material|
      fixture = fixtures.find { |fixture_search| fixture_search[:id] == material['fixture_id'] }

      groups.each do |_zone, group|
        group.each do |room_id, room|
          material['fixture_name'] = fixture[:name]
          material['fixture_type'] = fixture[:type]
          room[:materials][material['id']] = material if room_id == fixture[:room]
        end
      end
    end

    body = "<table class='table'>"

    groups.each do |zone, group|
      group_str = "<tr><th colspan='4'><h2 class='mt-5'>#{zone}</h2></th></tr>"

      group.each do |_room_id, room|
        group_str += "<tr><th colspan='4'><h5>#{room[:name]}</h5></th></tr><tr><th>Material</th><th>Material Type</th><th>Fixture</th><th>Fixture Type</th></tr>"

        room[:materials].each do |_material_id, material|
          group_str += '<tr>'
          group_str += "<td>#{material['name']}</td>"
          group_str += "<td>#{material['type']}</td>"
          group_str += "<td>#{material['fixture_name']}</td>"
          group_str += "<td>#{material['fixture_type']}</td>"
          group_str += '</tr>'
        end
      end

      body += group_str
    end

    body += '</table>'

    office['area'] = area
    office['max_people'] = max_people

    [body, office]
  end
end
