class Asset < ActiveRecord::Base
  has_many :variants, dependent: :destroy

  validates :title, presence: true


  def info_to_json
    {
      "id" => read_attribute(:id),
      "title" => read_attribute(:title),
      "description" => read_attribute(:description)
    }
  end
end
