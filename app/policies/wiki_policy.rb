

class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def admin_list?
    user.admin?
  end

  def update?
    user.admin? or not record.published?
  end

  def destroy?
   user.role == 'admin' || wiki.user == user
 end
end
