class UserPolicy < ApplicationPolicy

  def show?
    true
  end

  def update?
    user == record
  end
end