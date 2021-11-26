# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

# Generates Fixture Types Count Report
module Instructions
  def instructions
    materials = @con.exec('SELECT * FROM materials ORDER BY type;')

    fixtures = []
    @con.exec('SELECT * FROM fixtures').each do |fixture|
      fixtures << { id: fixture['id'], name: fixture['name'], room: fixture['room_id'], type: fixture['type'] }
    end

    rooms = []
    @con.exec('SELECT * FROM rooms').each do |room|
      rooms << { id: room['id'], name: room['name'], office: room['office_id'], area: room['area'], max_people: room['max_people'], zone: room['zone'] }
    end

    offices = []
    @con.exec('SELECT * FROM offices').each do |office|
      offices << { id: office['id'], name: office['name'], state: office['state'], address: office['address'], type: office['type'], phone: office['phone'] }
    end

    offices.each do |office|
      body, area, max_people = instructions_body(materials, fixtures, rooms, office)

      report = @template.gsub('{TITLE}',    office[:name])
                        .gsub('{SUBTITLE}', "#{office[:state]}, #{office[:address]}, #{office[:phone]}, #{office[:type]}<br />#{area}<br />#{max_people}")
                        .gsub('{BODY}',     body)

      File.open("html/instructions/#{office[:id]}.html", 'w') { |file| file.write(report) }
    end
  end

  def instructions_body(materials, fixtures, rooms, office)
    groups = {}
    area = 0
    max_people = 0

    rooms.each do |room|
      next unless room[:office] == office[:id]

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

    [body, area, max_people]
  end
end
