class Wiki < ApplicationRecord
  belongs_to :user, optional: true
  before_validation :set_default_value

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true


private

  def set_default_value
      self.private = false
  end


#  scope :public, ->{ where(:private => false) }

  def public?
    private == true ? false : true
  end
end
