class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.integer  :user_id
      t.integer  :book_id
      t.string   :book_title
      t.datetime :due_date

      t.timestamps
    end
  end
end