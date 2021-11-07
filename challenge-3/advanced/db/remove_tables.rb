# frozen_string_literal: true

module RemoveTables
  def remove_tables
    %w[materials fixtures rooms offices].each do |table|
      @con.exec("DROP TABLE IF EXISTS \"#{table}\";")
    end

    %w[material_type fixture_type room_zone office_city office_state office_lob
       office_type].each do |type|
      @con.exec("DROP TYPE IF EXISTS \"#{type}\";")
    end
  end
end
