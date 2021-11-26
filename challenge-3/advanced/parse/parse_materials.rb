# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

module ParseMaterials
  def parse_materials
    @csv.each do |row|
      name = row['Marketing material'].gsub('\'', '\\\'')
      type = row['Marketing material type']
      cost = row['Marketing material cost']

      office_name = row['Office'].gsub('\'', '\\\'')
      office_id = @con.exec("SELECT (id) from offices WHERE name='#{office_name}'").getvalue(0, 0)

      room_name = row['Room'].gsub('\'', '\\\'')
      room_id = @con.exec("SELECT (id) from rooms WHERE name='#{room_name}' AND office_id='#{office_id}'")
                    .getvalue(0, 0)

      fixture_name = row['Fixture'].gsub('\'', '\\\'')
      fixture_id = @con.exec("SELECT (id) from fixtures WHERE name='#{fixture_name}' AND room_id='#{room_id}'")
                       .getvalue(0, 0)

      is_unique = @con.exec("SELECT COUNT(*) from materials WHERE fixture_id=#{fixture_id} AND name='#{name}'")
                      .getvalue(0, 0)

      next unless Integer(is_unique).zero?

      @con.exec(
        "INSERT INTO materials(name, fixture_id, type, cost) VALUES('#{name}', '#{fixture_id}', '#{type}', '#{cost}')"
      )
    end
  end
end
