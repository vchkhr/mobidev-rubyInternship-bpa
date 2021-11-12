# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

# Generates Fixture Types Report
module ReportFixtureTypes
  def report_fixture_types(office_id)
    fixtures = @con.exec('SELECT * FROM fixtures ORDER BY type, room_id;')

    rooms = []
    @con.exec('SELECT * FROM rooms').each do |room|
      rooms << { id: room['id'], office: room['office_id'] }
    end

    offices = []
    @con.exec('SELECT * FROM offices').each do |office|
      offices << { id: office['id'], name: office['name'], address: office['address'], lob: office['lob'], type: office['type'] }
    end

    report_fixture_types_body(fixtures, rooms, offices, office_id)
  end

  def report_fixture_types_body(fixtures, rooms, offices, search_office_id)
    fixtures_groups = {}

    fixtures.each do |fixture|
      office_id = rooms.find { |room| room[:id] == fixture['room_id'].to_s } [:office]
      next if !search_office_id.nil? && office_id != search_office_id

      type = fixture['type']
      fixtures_groups[type] = {} unless fixtures_groups.key?(type)

      fixtures_groups[type][office_id] = [] unless fixtures_groups[type].key?(office_id)
      fixtures_groups[type][office_id] << fixture
    end

    body = ''
    search_office_name = ''

    fixtures_groups.each do |group_name, fixtures_group|
      group_body = ''
      group_count = 0

      fixtures_group.each do |office_id, fixture|
        fixture_office = offices.find { |office| office[:id] == office_id }
        office_count = fixture.length

        fixture_str = '<tr>'
        fixture_str += if search_office_id.nil?
                         "<td><a href='/reports/offices/#{office_id}/fixture_types'>#{fixture_office[:name]}</a></td>"
                       else
                         "<td>#{fixture_office[:name]}</td>"
                       end
        fixture_str += "<td>#{fixture_office[:type]}</td>"
        fixture_str += "<td>#{fixture_office[:address]}</td>"
        fixture_str += "<td>#{fixture_office[:lob]}</td>"
        fixture_str += "<td>#{office_count}</td>"
        fixture_str += '</tr>'

        group_body += fixture_str
        group_count += office_count

        search_office_name = fixture_office[:name] unless search_office_id.nil?
      end

      body += "<tr style='border-bottom: 1px solid black'><th colspan='5'><div class='d-flex'><h2 class='mt-5 flex-fill'>#{group_name}</h2><h2 class='mt-5'>#{group_count}</h2></div></th></tr>"
      body += "<tr><td><strong>Office</strong></td><td><strong>Type</strong></td><td><strong>Address</strong></td><td><strong>LOB</strong></td><td><strong>Sub Total Count</strong></td></tr>#{group_body}"
    end

    body = "<table class='table'>#{body}</table>" unless body.empty?

    [body, search_office_name]
  end
end
