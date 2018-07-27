class Wiki < ApplicationRecord
  belongs_to :user, optional: true


  scope :public, ->{ where(:private => false) }

  def public?
    private == true ? false : true
  end
end
