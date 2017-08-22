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

  def self.find_or_create_book(user_book_input)
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
