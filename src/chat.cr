require "./chat/*"
require "kemal"
require "pg"

conn = PG.connect "postgres://chat:1488@localhost:5432/chat"

module Chat
  # TODO Put your code here
end
