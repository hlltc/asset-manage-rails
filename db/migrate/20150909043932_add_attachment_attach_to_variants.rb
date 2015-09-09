class AddAttachmentAttachToVariants < ActiveRecord::Migration
  def self.up
    change_table :variants do |t|
      t.attachment :attach
    end
  end

  def self.down
    remove_attachment :variants, :attach
  end
end
