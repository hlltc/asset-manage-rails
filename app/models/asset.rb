class Asset < ActiveRecord::Base
  has_many :variants, dependent: :destroy

  validates :title, presence: true


  def info_to_json
    {
      "id" => :id,
      "title" => :title,
      "description" => :description
    }
  end
end
