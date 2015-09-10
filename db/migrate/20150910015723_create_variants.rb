class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string    :device
      t.string    :size
      t.string    :language

      t.references :asset, index: true
      t.timestamps null: false
    end
  end
end
