class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string   :title
      t.integer  :assembly_id

      t.timestamps
    end
  end
end
