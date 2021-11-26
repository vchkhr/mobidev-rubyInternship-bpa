require "pg"

dbname = ""
user = ""
password = ""

begin
    con = PG.connect(:dbname => dbname, :user => user, :password => password)

    con.exec("CREATE TYPE \"material_type\" AS ENUM (
        'brochure',
        'poster',
        'sticker',
        'print',
        'flag'
    );")

    con.exec("CREATE TYPE \"fixture_type\" AS ENUM (
        'standing_desk',
        'door',
        'window',
        'wall_poster',
        'brochure',
        'atm_wall',
        'flag'
    );")

    con.exec("CREATE TYPE \"room_zone\" AS ENUM (
        'staff',
        'lobby',
        'private',
        'exterrior',
        'safe'
    );")

    con.exec("CREATE TYPE \"office_city\" AS ENUM (
        'ny',
        'la'
    );")

    con.exec("CREATE TYPE \"office_state\" AS ENUM (
        'ny',
        'ca'
    );")

    con.exec("CREATE TYPE \"office_lob\" AS ENUM (
        'commercial',
        'charity'
    );")

    con.exec("CREATE TYPE \"office_type\" AS ENUM (
        'office',
        'atm'
    );")

    con.exec("CREATE TABLE \"materials\" (
        \"id\" SERIAL PRIMARY KEY NOT NULL,
        \"name\" varchar NOT NULL,
        \"fixture_id\" int NOT NULL,
        \"type\" material_type NOT NULL,
        \"cost\" int NOT NULL
    );")

    con.exec("CREATE TABLE \"fixtures\" (
        \"id\" SERIAL PRIMARY KEY NOT NULL,
        \"name\" varchar NOT NULL,
        \"room_id\" int NOT NULL,
        \"type\" fixture_type NOT NULL
    );")

    con.exec("CREATE TABLE \"rooms\" (
        \"id\" SERIAL PRIMARY KEY NOT NULL,
        \"name\" varchar NOT NULL,
        \"office_id\" int NOT NULL,
        \"area\" integer NOT NULL,
        \"max_people\" integer NOT NULL,
        \"zone\" room_zone NOT NULL
    );")

    con.exec("CREATE TABLE \"offices\" (
        \"id\" SERIAL PRIMARY KEY NOT NULL,
        \"name\" varchar NOT NULL,
        \"address\" text NOT NULL,
        \"city\" office_city NOT NULL,
        \"state\" office_state NOT NULL,
        \"phone\" varchar NOT NULL,
        \"lob\" office_lob NOT NULL,
        \"type\" office_type NOT NULL
    );")

    con.exec("ALTER TABLE \"materials\" ADD FOREIGN KEY (\"fixture_id\") REFERENCES \"fixtures\" (\"id\") ON DELETE CASCADE;")

    con.exec("ALTER TABLE \"fixtures\" ADD FOREIGN KEY (\"room_id\") REFERENCES \"rooms\" (\"id\") ON DELETE CASCADE;")

    con.exec("ALTER TABLE \"rooms\" ADD FOREIGN KEY (\"office_id\") REFERENCES \"offices\" (\"id\") ON DELETE CASCADE;")

rescue PG::Error => e
    puts e.message 

ensure
    con.close if con

end
