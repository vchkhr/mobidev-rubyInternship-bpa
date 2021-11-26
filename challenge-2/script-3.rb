require "pg"

dbname = ""
user = ""
password = ""

begin
    con = PG.connect(:dbname => dbname, :user => user, :password => password)

    con.exec("DROP TABLE IF EXISTS \"materials\";")
    con.exec("DROP TABLE IF EXISTS \"fixtures\";")
    con.exec("DROP TABLE IF EXISTS \"rooms\";")
    con.exec("DROP TABLE IF EXISTS \"offices\";")

    con.exec("DROP TYPE IF EXISTS \"material_type\";")
    con.exec("DROP TYPE IF EXISTS \"fixture_type\";")
    con.exec("DROP TYPE IF EXISTS \"room_zone\";")
    con.exec("DROP TYPE IF EXISTS \"office_city\";")
    con.exec("DROP TYPE IF EXISTS \"office_state\";")
    con.exec("DROP TYPE IF EXISTS \"office_lob\";")
    con.exec("DROP TYPE IF EXISTS \"office_type\";")

rescue PG::Error => e
    puts e.message 

ensure
    con.close if con

end
