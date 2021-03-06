class Variant < ActiveRecord::Base

  has_attached_file :attach
  do_not_validate_attachment_file_type :attach

  belongs_to :asset

  validates :device, :size, :language, :asset_id, presence: true
  validates_inclusion_of :device, :in => %w(all Android iPhone iPad), :message => "%{value} is not included in the device list"
  validates_inclusion_of :size, :in => %w(all 320x480 320x568 375x667 414x736 768x1024), :message => "%{value} is not included in the size list"
  validates_inclusion_of :language, :in => %w(all en zh de fr it), :message => "%{value} is not included in the language list"

  include Rails.application.routes.url_helpers

  def info_to_json
    {
      "id" => self.id,
      "device" => self.device,
      "size" => self.size,
      "language" => self.language,
      "asset_id" => self.asset_id,
      "version" => self.id,
      "created_at" => self.created_at,
      "file_name" => self.attach_file_name,
      "file_size" => self.attach_file_size,
      "content_type" => self.attach_content_type,
      "url" => self.attach.url
    }
  end
end
