# Encoding: utf-8
Encoding.default_internal = Encoding::UTF_8

require "bundler/setup"

require_relative "server"

run Sinatra::Application
