
require "pg"

DB_NAME = "mess"
PG_PATH = "postgres://user:password@localhost:5432/db_name"

# CREATES CONNECTION WITH DEFAULT POSTGRES conn
conn = PG.connect("postgres://user:password@localhost:5432/db_name")

database_exists? = conn.exec(%{
  SELECT CAST(1 AS integer)
  FROM pg_database
  WHERE datname=$1
}, [DB_NAME]).to_hash.empty? ? false : true

 puts "Creating messages table in #{DB_NAME}..."
  conn.exec(%{
    CREATE TABLE messages (
      id          SERIAL PRIMARY KEY,
      username    TEXT NOT NULL,
      message     TEXT NOT NULL,
      created_at  TIMESTAMP WITH TIME ZONE NOT NULL,
      updated_at  TIMESTAMP WITH TIME ZONE NOT NULL
    );
  })
  puts "Process finished succesfully"

puts "Closing connection..."
conn.close