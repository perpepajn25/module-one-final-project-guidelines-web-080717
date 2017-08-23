class CLI
  attr_accessor :title, :author

  def self.welcome
    puts "Welcome to BadReads!"
    sleep(1.5)
    puts "Did an author waste your precious time?"
    sleep (1.5)
    puts "Is a book over-hyped?"
    sleep(1.5)
    puts "Are you otherwise disgruntled over a piece of writing and want to share your outrage?"
    sleep(1.5)
    puts "If so, then you've come to the right place!"
    sleep(2)
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

  def self.prompt_confirm
    puts "Did you mean #{@title} by #{@author}? Yes or No:"
    response = gets.chomp.downcase
  end

  def self.user_response
    response = self.prompt_confirm
    if response == "yes"
      Book.find_or_create_by(title: @title, author: @author)
    elsif response == "no"
      puts "Please modify your search."
      puts "What book would you like to destroy?"
      new_search = gets.chomp
      self.confirm_book(new_search)
    else
      puts "Please enter 'Yes' or 'No'."
      self.user_response
    end

  end
  #get book
  #confirm book
    #return title and author
      #if yes, create book
      #if no, ask to modify search term
def self.confirm_book(user_input)
  api = Goodreads::Client.new(:api_key => 'ytzqy6IgxnxFr4ieq6TCw', :api_secret => 'WntJehcPvpnI6ynAqBmK8tQ391Nb7o00FsLQXEH5U')
  search = api.search_books(user_input)
  unless search.total_results == "0"
    # binding.pry
  book = search.results.work.first
  @title = book.best_book.title
  @author = book.best_book.author.name
  self.user_response
  else
    puts "Sorry, it looks like there were no results for that entry. Press any key to try another search."
    gets
    new_search = self.get_book
    self.confirm_book(new_search)
  end
end


  def self.prompt_for_review(user,book)
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

  def self.continue
    puts "Press any key to continue"
    gets
  end

  def self.write_a_review(user)
    search = self.get_book
    book = self.confirm_book(search)
    self.prompt_for_review(user,book)
    self.thank_you
    self.continue
    puts "Next..."
    self.options(user)
  end

  def self.user_stats(user)
      puts "Stats options:"
      puts "a =================== View all of you reviews"
      puts "b =========== View all of your reviewed books"
      input = gets.chomp

      case input
      when "a"
        user.reviews.each do |review|
            puts "Title: #{review.book.title}"
            puts "Author: #{review.book.author}"
            puts "Review: #{review.content}"
            puts "===================="
          end
      when "b"
        user.books.each do |book|
          puts "Title: #{book.title}"
          puts "Author: #{book.author}"
          puts "====================="
        end
      end
      self.continue
      self.options(user)
  end

  def self.options(user)

    puts "What would you like to do?"
    puts "Here are your options:"
    puts "a =========================== Write a scathing review"
    puts "b ========== Find the worst author that has ever been"
    puts "c ============ Find the worst book that has ever been"
    puts "d ================================== Check your stats"
    puts "e ============================================ Logout"
    input = gets.chomp

    case input
    when "a"
      self.write_a_review(user)
    when "b"
      puts "RETURN WORST AUTHOR"
    when "c"
      puts "RETURN WORST BOOK"
    when "d"
      self.user_stats(user)
    when "e"
      puts "Thanks for visiting BadReads! May an author never waste your time again..."
      puts "But if they do, we're always here"
    else
      puts "We didn't recognize your selection."
      self.options
    end
  end



end
