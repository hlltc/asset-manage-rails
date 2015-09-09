class Variant < ActiveRecord::Base

  has_attached_file :attach

  validates :device, :size, :language, :attach, presence: true
  validates_inclusion_of :device, :in => %w(all Android iPhone iPad), :message => "%{value} is not included in the device list"
  validates_inclusion_of :size, :in => %w(all 320x480 320x568 375x667 414x736 768x1024), :message => "%{value} is not included in the size list"
  validates_inclusion_of :language, :in => %w(all en zh de fr it), :message => "%{value} is not included in the language list"

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "id" => read_attribute(:id),
      "device" => read_attribute(:device),
      "size" => read_attribute(:size),
      "language" => read_attribute(:language),
      "name" => read_attribute(:attach_file_name),
      "file_size" => read_attribute(:attach_file_size),
      #{}"url" => attach.url(:original),
      #{}"delete_url" => attach_path(self),
      "delete_type" => "DELETE"
    }
  end
end
