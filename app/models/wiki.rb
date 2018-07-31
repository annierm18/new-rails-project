class Wiki < ApplicationRecord
  belongs_to :user, optional: true
  before_commit :set_default_value

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true


  def set_default_value
      attribute :private, default: false
  end


#  scope :public, ->{ where(:private => false) }

  def public?
    private == true ? false : true
  end
end
