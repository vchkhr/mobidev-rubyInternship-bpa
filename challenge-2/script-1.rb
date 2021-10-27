require "pg"

begin
    puts "Enter database name:"
    dbname = gets.chomp()

    puts "Enter username:"
    user = gets.chomp()

    puts "Enter password:"
    password = gets.chomp()
    
    con = PG.connect(:dbname => dbname, :user => user, :password => password)

    con.exec("CREATE TABLE test_table(id integer)")
    puts "Table 'test_table' created. Check it and press Enter"
    gets

    con.exec("DROP TABLE IF EXISTS test_table")
    puts "Table 'test_table' deleted"

rescue PG::Error => e
    puts e.message 

ensure
    con.close if con

end
