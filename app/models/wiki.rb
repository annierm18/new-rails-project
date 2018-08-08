class Wiki < ApplicationRecord
  belongs_to :user, optional: true
  before_save :set_default_value
  has_many :users, through: :collaborators
  delegate :users, to: :collaborators
  has_many :collaborators

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true


  #scope :public, ->{ where(:private => false) }

  def collaborators
    Collaborator.where(wiki_id: id)
  end


    def public?
      private == true ? false : true
    end



private

  def set_default_value
      self.private ||= false
  end



end
