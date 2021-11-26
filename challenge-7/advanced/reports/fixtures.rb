# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

# Generates Fixture Types Report
module ReportFixtureTypes
  def report_fixture_types(office_id)
    search_office_name = ''

    if office_id
      search_office_name = @con.exec_params('SELECT name FROM offices WHERE offices.id=$1;', [office_id])

      return [[], nil] if search_office_name.to_a.empty?

      search_office_name = search_office_name[0]['name']

      fixtures = @con.exec_params('
        SELECT b.fixture_type, b.office_id, b.count,
        offices.id, offices.name AS office_name, offices.type AS office_type, offices.address AS office_address, offices.lob AS office_lob
        FROM

        (SELECT a.fixture_type, a.office_id, COUNT(*) AS count
        FROM

        (SELECT
        fixtures.type AS fixture_type, fixtures.room_id AS fixture_room_id,
        rooms.id AS room_id, rooms.office_id AS room_office_id,
        offices.id AS office_id
        FROM fixtures
        INNER JOIN rooms ON fixtures.room_id=rooms.id
        INNER JOIN offices ON rooms.office_id=offices.id
        ORDER BY fixtures.type, offices.id)

        AS a
        GROUP by a.fixture_type, a.office_id
        HAVING a.office_id=$1)

        AS b
        INNER JOIN offices ON b.office_id=offices.id
        ;', [office_id])
    else
      fixtures = @con.exec('
        SELECT b.fixture_type, b.office_id, b.count,
        offices.id, offices.name AS office_name, offices.type AS office_type, offices.address AS office_address, offices.lob AS office_lob
        FROM

        (SELECT a.fixture_type, a.office_id, COUNT(*) AS count
        FROM

        (SELECT
        fixtures.type AS fixture_type, fixtures.room_id AS fixture_room_id,
        rooms.id AS room_id, rooms.office_id AS room_office_id,
        offices.id AS office_id
        FROM fixtures
        INNER JOIN rooms ON fixtures.room_id=rooms.id
        INNER JOIN offices ON rooms.office_id=offices.id
        ORDER BY fixtures.type, offices.id)

        AS a
        GROUP by a.fixture_type, a.office_id)

        AS b
        INNER JOIN offices ON b.office_id=offices.id
        ;')

      search_office_name = nil
    end

    types = []
    types_grouped = {}

    fixtures.each do |fixture|
      types << { fixture_type: fixture['fixture_type'], count: fixture['count'], office_id: fixture['office_id'], office_name: fixture['office_name'], office_type: fixture['office_type'], office_address: fixture['office_address'], office_lob: fixture['office_lob'] }
    end

    types.each do |type|
      types_grouped[type[:fixture_type]] = { count: 0, offices: [] } unless types_grouped.key?(type[:fixture_type])

      types_grouped[type[:fixture_type]][:count] += Integer(type[:count])
      types_grouped[type[:fixture_type]][:offices] << type
    end

    [types_grouped, search_office_name]
  end
end
