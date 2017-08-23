class CLI

  def self.welcome
    puts "Welcome to BadReads!"
    puts "Did an author waste your precious time?"
    puts "Is a book over-hyped?"
    puts "Are you otherwise disgruntled over a piece of writing and want to share your outrage?"
    puts "If so, then you've come to the right place!"
  end

  def self.get_user
    puts "Please enter a username."
    username = gets.chomp
    User.find_or_create_by(username: username)
  end

  def self.greet_user(user)
    puts "Welcome, #{user.username}!"
  end

  def self.get_book
    puts "What book would you like to warn people about?"
    ##perhaps we could randomize the output here from an array of a few different phrasings of the question (e.g."What book would you like to smear today?", "You look ready to destroy a book. What title would you like to smear?", etc.)
    gets.chomp
  end

  #def self.is_this_the_book_that_you_mean?
  #end

  def self.find_or_create_book(user_input)
    #makes request to API
    api = Goodreads::Client.new(:api_key => 'ytzqy6IgxnxFr4ieq6TCw', :api_secret => 'WntJehcPvpnI6ynAqBmK8tQ391Nb7o00FsLQXEH5U')

    search = api.search_books(user_input)

        #retrieves data
    book = search.results.work.first
    title = book.best_book.title
    author = book.best_book.author.name

    Book.find_or_create_by(title: title, author: author)
  end

  def self.write_a_review(user)

    search = self.get_book
    book = self.find_or_create_book(search)

    puts "Write a review: go ahead... let us know how you really feel."
    content = gets.chomp
    puts "Please rate this book on a scale of 0-5."
    rating = gets.chomp
    user.reviews.create(book: book, content: content, user_rating: rating)
  end

  def self.options(user)
    
    puts "What would you like to do?"
    puts "Here are your options:"
    puts "a =========================== Write a scathing review"
    puts "b ========== Find the worst author that has ever been"
    puts "c ============ Find the worst book that has ever been"
    input = gets.chomp

    case input
    when "a"
      self.write_a_review(user, book)
    when "b"
      puts "RETURN WORST AUTHOR"
    when "c"
      puts "RETURN WORST BOOK"
    else
      puts "We didn't recognize your selection."
      self.options
    end
  end

end
