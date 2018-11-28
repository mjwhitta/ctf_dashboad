#!usr/bin/env ruby

require "sinatra/activerecord/rake"

require_relative "server"

task(default: :run)

task(:clean) do
    system("rm db/db.sqlite3 db/schema.rb")
end

task(:run) do
    system("rerun rackup")
end
