module GoodReads

  class Adapter
    attr_reader :user_book_input

    def initialize(user_book_input)
      @user_book_input = user_book_input
    end

    def create_book
      #makes request to API
      api = Goodreads::Client.new(:api_key => 'ytzqy6IgxnxFr4ieq6TCw', :api_secret => 'WntJehcPvpnI6ynAqBmK8tQ391Nb7o00FsLQXEH5U')
      search = api.search_books(self.user_book_input)

      #retrieves data
      book = search.results.work.first
      good_reads_rating = book.average_rating
      title = book.best_book.title
      author = book.best_book.author.name

      Book.new(title, author, good_reads_rating)
    end
  end
end
