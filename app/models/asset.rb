class Asset < ActiveRecord::Base
  has_many :variants, dependent: :destroy

  validates :title, presence: true


  def info_to_json
    {
      "id" => self.id,
      "title" => self.title,
      "description" => self.description
    }
  end
end
