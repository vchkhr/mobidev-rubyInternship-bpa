# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

# Generates Installation Instructions
module InstructionsGen
  def report_instructions(office_needed)
    return report_instructions_office(office_needed) unless office_needed.nil?

    offices = @con.exec('SELECT * FROM offices ORDER BY state;')

    offices_result = {}

    offices.each do |office|
      offices_result[office['state']] = [] unless offices_result.key?(office['state'])

      offices_result[office['state']] << { id: office['id'], name: office['name'], type: office['type'], address: office['address'], lob: office['lob'] }
    end

    [offices_result, { id: nil, data: nil }]
  end

  def report_instructions_office(office_needed)
    office = con.exec_params('SELECT * FROM offices WHERE offices.id=$1', [office_needed])
    return [[], { id: office_needed, data: nil }] if office.to_a.empty?

    office = office[0]
    office_data = { name: office['name'], state: office['state'], address: office['address'], phone: office['phone'], type: office['type'], area: 0, max_people: 0 }

    materials = con.exec_params('
      SELECT c.material_name, c.material_type, c.fixture_name, c.fixture_type, c.room_name, c.room_zone, c.office_id, c.room_area, c.room_max_people

      FROM(
        SELECT b.material_name, b.material_type, b.fixture_name, b.fixture_type, b.room_name, b.room_zone, b.room_office_id, b.room_area, b.room_max_people,
        offices.id AS office_id

        FROM (
          SELECT a.material_name, a.material_type, a.fixture_name, a.fixture_type, a.fixture_room_id,
          rooms.id, rooms.name AS room_name, rooms.zone AS room_zone, rooms.office_id AS room_office_id, rooms.area AS room_area, rooms.max_people AS room_max_people

          FROM (
            SELECT materials.name AS material_name, materials.type AS material_type, materials.fixture_id AS material_fixture_id,
            fixtures.id AS fixture_id, fixtures.name AS fixture_name, fixtures.type AS fixture_type, fixtures.room_id AS fixture_room_id
            FROM materials
            INNER JOIN fixtures ON materials.fixture_id=fixtures.id)

          AS a
          INNER JOIN rooms ON a.fixture_room_id=rooms.id)

        AS b
        INNER JOIN offices ON offices.id=b.room_office_id)

      AS c
      WHERE c.office_id=$1
    ;', [office_needed])

    instructions = {}

    materials.each do |material|
      instructions[material['room_zone']] = {} unless instructions.key?(material['room_zone'])

      unless instructions[material['room_zone']].key?(material['room_name'])
        instructions[material['room_zone']][material['room_name']] = []
        
        office_data[:area] += Integer(material['room_area'])
        office_data[:max_people] += Integer(material['room_max_people'])
      end

      instructions[material['room_zone']][material['room_name']] << { material_name: material['material_name'], material_type: material['material_type'], fixture_name: material['fixture_name'], fixture_type: material['fixture_type'] }
    end

    [instructions, { id: office_needed, data: office_data }]
  end
end
