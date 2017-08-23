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
    user_book_input = gets.chomp
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

  def self.write_a_review(user,book)
    puts "Write a review: go ahead... let us know how you really feel."
    content = gets.chomp
    puts "Please rate this book on a scale of 0-5."
    rating = gets.chomp
    user.reviews.create(book: book, content: content, user_rating: rating)
  end

  def self.author_response
    array = ["You have your entire life to be a jerk. Why not take today off?","Some day you’ll go far—and I really hope you stay there.","Do yourself a favor and ignore anyone who tells you to be yourself.","I wish we were better strangers.","Roses are red, violets are blue, I have 5 fingers, the 3rd one's for you.","Some cause happiness wherever they go... You, on the other hand, whenever you go."]
    array.sample
  end

  def self.thank_you
    puts "Thank you for your feedback. Now here is a word from the author."
    puts "#{self.author_response}"
  end

  def self.write_a_review(user)
    search = self.get_book
    book = self.find_or_create_book(search)
    self.write_a_review(user,book)
    self.thank_you
  end

end
