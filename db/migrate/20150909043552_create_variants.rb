class CreateVariants < ActiveRecord::Migration
  def change
    drop_table :variants
    create_table :variants do |t|
      t.string  :device
      t.string  :size
      t.string  :language
      t.text  :description
      t.string  :md5

      t.timestamps null: false
    end
  end
end
