require_relative '../config/environment'
require 'pry'

CLI.welcome
user = CLI.get_user
CLI.greet_user(user)
sleep(1)
CLI.options(user)
