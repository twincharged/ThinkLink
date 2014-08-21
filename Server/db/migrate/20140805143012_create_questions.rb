class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer  :chapter_id
      t.integer  :unit_id
      t.string   :content
      t.string   :a
      t.string   :b
      t.string   :c
      t.string   :d
      t.string   :answer

      t.timestamps
    end
  end
end
