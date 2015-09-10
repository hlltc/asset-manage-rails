class Variant < ActiveRecord::Base

  has_attached_file :attach
  validates_attachment :attach, content_type: { content_type: "image/jpeg" }

  validates :device, :size, :language, presence: true
  validates_inclusion_of :device, :in => %w(all Android iPhone iPad), :message => "%{value} is not included in the device list"
  validates_inclusion_of :size, :in => %w(all 320x480 320x568 375x667 414x736 768x1024), :message => "%{value} is not included in the size list"
  validates_inclusion_of :language, :in => %w(all en zh de fr it), :message => "%{value} is not included in the language list"

  include Rails.application.routes.url_helpers

  def info_to_json
    {
      "id" => read_attribute(:id),
      "device" => read_attribute(:device),
      "size" => read_attribute(:size),
      "language" => read_attribute(:language),
      "file_name" => read_attribute(:attach_file_name),
      "file_size" => read_attribute(:attach_file_size),
      "content_type" => read_attribute(:attach_content_type),
      "url" => self.attach.url
    }
  end
end
