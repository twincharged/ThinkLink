class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string   :title
      t.text     :content
      t.integer  :teacher_id
      t.integer  :book_id
      t.boolean  :exam,                default: false

      t.timestamps
    end
  end
end