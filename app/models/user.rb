class User < ApplicationRecord
    has_many :wikis, through: :collaborators, dependent: :destroy
    has_many :collaborators
    delegate :wikis, to: :collaborators

    enum role: [:standard, :premium, :admin]



    after_initialize :set_default_role

    def collaborators
      Collaborator.where(user_id: id)
    end

    def public_wikis
        wikis.find(&:public?)
    end

    def set_default_role
      self.role ||= :standard
    end

  #  def downgrade_user_to_standard

  #    current_user.update_attributes!(role: 'standard')
  #  end

    #def current_user_downgrade_wikis

    #  wikis.update_attributes(:private, false)
    #  current_user.wikis.where(private: true).update_all(private: false)
  #  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :confirmable

  def admin?
    role == 'admin'
  end

  def standard?
    role == 'standard'
  end

  def premium?
    role == 'premium'
  end


  #before_save { self.email = email.downcase if email.present? }

  #validates :name, length: { minimum: 1, maximum: 100 }, presence: true

 #validates :password, presence: true, length: { minimum: 6 }
 #validates :password, length: { minimum: 6 }, allow_blank: true

#  validates :email,
#            presence: true,
  #          uniqueness: { case_sensitive: false },
  #          length: { minimum: 3, maximum: 254 }


#  has_secure_password
end
