class CLI
  attr_accessor :title, :author, :book_search, :rating

  def self.welcome
    puts "Welcome to " + Paint["Bad", :red, :bold] + "Reads! Courtesy of the " +  Paint["Good", :blue, :bold] + "Reads API"
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
    puts Paint["Please enter a username.", :bold]
    username = gets.chomp
    system "clear"

    User.find_or_create_by(username: username)
  end

  def self.greet_user(user)
    puts "Welcome, #{user.username}!"
  end

  def self.get_book
    puts Paint["What book would you like to warn people about?", :bold]
   @book_search = gets.chomp
  end

  def self.prompt_confirm
    puts Paint["Did you mean #{@title} by #{@author}? Yes or No:", :bold]
    response = gets.chomp.downcase
  end

  def self.user_response
    response = self.prompt_confirm
    if response == "yes"
      Book.find_or_create_by(title: @title, author: @author)
    elsif response == "no"
      system "clear"
      puts "Please modify your search. You last searched '#{@book_search}'"
      puts Paint["What book would you like to destroy?", :bold]
      @book_search = gets.chomp
      system "clear"
      self.confirm_book(@book_search)
    else
      puts Paint["Please enter 'Yes' or 'No'.", :bold]
      self.user_response
    end
  end

def self.confirm_book(user_input)
  api = Goodreads::Client.new(:api_key => 'ytzqy6IgxnxFr4ieq6TCw', :api_secret => 'WntJehcPvpnI6ynAqBmK8tQ391Nb7o00FsLQXEH5U')
  search = api.search_books(user_input)
  unless search.total_results == "0"
  book = search.results.work.first
  @title = book.best_book.title
  @author = book.best_book.author.name
  self.user_response
  else
    system 'clear'
    puts "Sorry, it looks like there were no results for '#{@book_search}'."
    puts Paint["Press any key to try another search.", :bold]
    gets
    new_search = self.get_book
    self.confirm_book(new_search)
  end
end


  def self.prompt_for_review(user,book)
    puts Paint["Write a review: go ahead... let us know how you really feel.", :bold]
    content = gets.chomp
    system "clear"
    puts Paint["Please rate this book on a scale of 0-5.", :bold]
    @rating = gets.chomp.to_i
    system "clear"
    user.reviews.create(book: book, content: content, user_rating: @rating)
  end

  def self.author_response(user)
    bad_review_array = ["You have your entire life to be a jerk. Why not take today off?","Some day you’ll go far—and I really hope you stay there.","Do yourself a favor and ignore anyone who tells you to be yourself.","I wish we were better strangers.","Roses are red, violets are blue, I have 5 fingers, the 3rd one's for you.","Some cause happiness wherever they go... You, on the other hand, whenever you go."]

    good_review_array = ["Wait... really? You liked it?", "This means a lot. I wrote this during a tough time, and thoughts like this get me through the day.", "No, it's actually not good.", "New phone, whodis?"]

    puts "#{user.reviews.last.book.author} is reading your review."
    sleep(0.5)
    puts "..."
    sleep(0.5)
    puts "..."
    sleep(0.5)

    if @rating >= 4
      puts "#{user.reviews.last.book.author}: '#{good_review_array.sample}'"
    else
      puts "#{user.reviews.last.book.author}: '#{bad_review_array.sample}'"
    end

  end


  def self.thank_you
    puts "Thank you for your feedback."
  end

  def self.continue
    puts Paint["Press any key to continue", :bold]
    gets
    system "clear"
  end

  def self.write_a_review(user)
    search = self.get_book
    system "clear"
    book = self.confirm_book(search)
    self.prompt_for_review(user,book)
    self.thank_you
    self.author_response(user)
    self.continue
    puts "Next..."
    self.options(user)
  end

  def self.find_worst_author
    author_array = Book.all.collect do |book|
      book.author
    end
    author_array.each_with_object({}) do |author,hash|
      hash[author] = author_array.count(author)
    end.sort.last[0]
  end
  #
  # def self.find_worst_book
  # end

  def self.user_stats(user)
      puts "Stats options:"
      puts "a =================== View all of you reviews"
      puts "b =========== View all of your reviewed books"
      puts "c =============== Return to main options menu"
      input = gets.chomp
      system "clear"

      case input
      when "a"
        user.reviews.sort_by { |review| review.book.author }.each do |review|
            puts "Title:  #{review.book.title}"
            puts "Author: #{review.book.author}"
            puts "Review: #{review.content}"
            puts "Rating: #{review.user_rating}"
            puts "===================="
          end
          self.continue
          self.user_stats(user)
      when "b"
        user.books.uniq.sort_by { |book| book.author }.each do |book|
          puts "Title:  #{book.title}"
          puts "Author: #{book.author}"
          puts "====================="
        end
        self.continue
        self.user_stats(user)
      when "c"
        self.options(user)
      else
        puts "We didn't recognize your selection. Please enter the letter corresponding to your selection."
        self.user_stats(user)
      end
  end

  def self.options(user)

    puts Paint["What would you like to do?", :bold]
    puts "Here are your options:"
    puts "a =========================== Write a scathing review"
    puts "b ========== Find the worst author that has ever been"
    # puts "c ============ Find the worst book that has ever been"
    puts "c ================================== Check your stats"
    puts "d ============================================ Logout"

    input = gets.chomp
    system "clear"

    case input
    when "a"
      self.write_a_review(user)
    when "b"
      puts "The worst author according to BadReads is #{self.find_worst_author}."
      puts Paint["Sorry #{self.find_worst_author.split.first} :(", :green, :bold]
      sleep(1.5)
      self.continue
      self.options(user)
    # when "c"
    #   puts "RETURN WORST BOOK"
    when "c"
      self.user_stats(user)
    when "d"
      puts Paint["Thanks for visiting BadReads! May an author never waste your time again...", :bold]
      sleep(1)
      puts Paint["But if they do, come back soon!", :bold]
    else
      puts Paint["We didn't recognize your selection. Please enter the letter corresponding to your selection.", :bold]
      self.options(user)
    end
  end

end
