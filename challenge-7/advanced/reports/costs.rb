# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/AbcSize

# Generates Marketing Material Costs Report
module ReportCosts
  def report_costs
    materials = @con.exec('
      SELECT d.office_id, d.material_type, d.subtotal,
      offices.id AS office_id, offices.name AS office_name
      FROM (

        SELECT c.office_id, c.material_type,
        SUM (c.material_cost) AS subtotal
        FROM (

          SELECT b.material_type, b.material_cost, b.fixture_room_id, b.room_office_id,
          offices.id AS office_id
          FROM (

            SELECT a.material_type, a.material_cost, a.fixture_room_id,
            rooms.id AS room_id, rooms.office_id AS room_office_id
            FROM (

              SELECT materials.fixture_id AS material_fixture_id, materials.type AS material_type, materials.cost AS material_cost,
              fixtures.id AS fixture_id, fixtures.room_id AS fixture_room_id
              FROM materials
              INNER JOIN fixtures ON materials.fixture_id=fixtures.id)

            AS a
            INNER JOIN rooms ON a.fixture_room_id=rooms.id)

          AS b
          INNER JOIN offices ON b.room_office_id=offices.id)

        AS c
        GROUP by c.office_id, c.material_type)

      AS d
      INNER JOIN offices ON d.office_id=offices.id
      ORDER BY d.office_id, d.subtotal
    ;')
    offices = {}

    materials.each do |material|
      offices[material['office_id']] = { total: 0, name: material['office_name'], types: [] } unless offices.key?(material['office_id'])

      offices[material['office_id']][:types] << { name: material['material_type'], subtotal: material['subtotal'] }
      offices[material['office_id']][:total] += Integer(material['subtotal'])
    end

    offices
  end
end
