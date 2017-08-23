require_relative '../config/environment'
require 'pry'

CLI.welcome
user = CLI.get_user
title = CLI.get_book
CLI.find_or_create_book(title)
binding.pry

"hasfhsfsdf"
