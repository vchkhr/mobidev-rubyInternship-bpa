# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

module ParseFixtures
  def parse_fixtures
    @csv.each do |row|
      name = row['Fixture'].gsub('\'', '\\\'')
      type = row['Fixture Type']

      office_name = row['Office'].gsub('\'', '\\\'')
      office_id = @con.exec("SELECT (id) from offices WHERE name='#{office_name}'").getvalue(0, 0)

      room_name = row['Room'].gsub('\'', '\\\'')
      room_id = @con.exec("SELECT (id) from rooms WHERE name='#{room_name}' AND office_id='#{office_id}'")
                    .getvalue(0, 0)
      is_unique = @con.exec("SELECT COUNT(*) from fixtures WHERE room_id=#{room_id} AND name='#{name}'")
                      .getvalue(0, 0)

      next unless Integer(is_unique).zero?

      @con.exec("INSERT INTO fixtures(name, room_id, type) VALUES('#{name}', '#{room_id}', '#{type}')")
    end
  end
end
