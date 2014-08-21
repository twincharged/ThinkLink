class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string   :title
      t.text     :content
      t.integer  :unit_id
      t.integer  :teacher_id
      t.boolean  :quiz,                           default: false

      t.timestamps
    end
  end
end