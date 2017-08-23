require_relative '../config/environment'
require 'pry'

system "clear"
CLI.welcome
user = CLI.get_user
sleep(1)
CLI.greet_user(user)
CLI.options(user)
