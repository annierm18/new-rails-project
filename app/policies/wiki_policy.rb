

class WikiPolicy < ApplicationPolicy
  class Scope < Scope
  attr_reader :user, :scope

  def initialize(user, scope)
    @user = user
    @scope = scope
  end

  def standard_list?
    user.standard?
  end

  def resolve
      if user.standard?
        scope.all
      else
        scope.where(published: true)
      end
    end
  end

  def update?
    user.standard? or not wiki.published?
  end


  def destroy?
   user.role == 'standard' || wiki.user == user
 end
end
