class RemoveRatingColumnFromBooksTable < ActiveRecord::Migration[5.0]
  def change
    remove_column(:books, :good_reads_rating)
  end
end
