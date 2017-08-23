class CLI

  def self.welcome
    puts "Welcome to Bad_Reads!"
    puts "This is the place where you smear books."
  end

  def self.get_user
    puts "Please enter a username."
    username = gets.chomp
    User.find_or_create_by(username: username)
  end

  def self.greet_user
    puts "Welcome, #{user}!"
  end

  def self.choose_book(user_book_input)
    #probably remove input to this method, get from CLI chomps!
    puts "What book would you like to warn people about?"
    ##perhaps we could randomize the output here from an array of a few different phrasings of the question (e.g."What book would you like to smear today?", "You look ready to destroy a book. What title would you like to smear?", etc.)
    user_book_input = gets.chomp
        #makes request to API
    api = Goodreads::Client.new(:api_key => 'ytzqy6IgxnxFr4ieq6TCw', :api_secret => 'WntJehcPvpnI6ynAqBmK8tQ391Nb7o00FsLQXEH5U')

    search = api.search_books(user_book_input)

        #retrieves data
    book = search.results.work.first
    good_reads_rating = book.average_rating
    title = book.best_book.title
    author = book.best_book.author.name

    Book.find_or_create_by(title: title, author: author, good_reads_rating: good_reads_rating)
  end



end
