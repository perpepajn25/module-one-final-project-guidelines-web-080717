require_relative '../config/environment'
require 'pry'

CLI.welcome
user = CLI.get_user
CLI.greet_user(user)
search = CLI.get_book
book = CLI.find_or_create_book(search)
CLI.write_a_review(user,book)




"hasLISJDF,KSAJDFLKASJDLKFJASDF"
