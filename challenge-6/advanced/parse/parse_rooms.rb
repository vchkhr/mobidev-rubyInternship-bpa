# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

# Push rooms to the database
module ParseRooms
  def parse_rooms
    @csv.each do |row|
      name = row['Room'].gsub('\'', '\\\'')
      area = row['Room area']
      max_people = row['Room max people']
      zone = row['Zone']

      office_name = row['Office'].gsub('\'', '\\\'')
      office_id = @con.exec("SELECT (id) from offices WHERE name='#{office_name}'").getvalue(0, 0)
      is_unique = @con.exec("SELECT COUNT(*) from rooms
                            WHERE office_id=#{office_id} AND name='#{name}' AND zone='#{zone}'")
                      .getvalue(0, 0)

      next unless Integer(is_unique).zero?

      @con.exec("INSERT INTO rooms(name, office_id, area, max_people, zone)
                VALUES('#{name}', '#{office_id}', '#{area}', '#{max_people}', '#{zone}')")
    end
  end
end
