# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

# Push offices to the database
module ParseOffices
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
end
