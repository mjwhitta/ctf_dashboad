#!usr/bin/env ruby

require "sinatra/activerecord/rake"

require_relative "server"

task(default: :run)

task(:run) do
    system("rerun rackup")
end
