class ApiAccessTokenPolicy < ApplicationPolicy

  def destroy?
    owner?(user, record)
  end

  private

  def owner?(user, token)
    user.id == token.user_id
  end

end