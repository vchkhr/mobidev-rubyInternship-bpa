# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

require 'csv'

# Main parse module
module Parse
  def parse(file)
    return if @dbname.empty? && @user.empty? && @password.empty?
    
    @csv = CSV.parse(file, headers: true)

    parse_offices
    parse_rooms
    parse_fixtures
    parse_materials
  end

  def parse_offices
    @csv.each do |row|
      name = row['Office'].gsub('\'', '\\\'')
      address = row['Office address'].gsub('\'', '\\\'')
      city = row['Office city']
      state = row['Office State']
      phone = row['Office phone']
      lob = row['Office lob']
      type = row['Office type']

      @con.exec(
        "INSERT INTO offices(name, address, city, state, phone, lob, type)
        VALUES('#{name}', '#{address}', '#{city}', '#{state}', '#{phone}', '#{lob}', '#{type}')
        ON CONFLICT(name)
        DO NOTHING"
      )
    end
  end

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
