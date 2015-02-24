# This class is the base for all other policies.
#
# Every controller which has certain restrictions (e.g. only trip users can see the details of a trip) should contain
# "after_action :verify_authorized" at the beginning to make sure that you call the "authorize" method of
# Pundit in each action (so we can be sure that a user is authorized for that specific action).
#
# For the full Pundit documentation have a look at: https://github.com/elabs/pundit
#
class ApplicationPolicy
  attr_reader :user, :record

  # @param [User] user the current_user injected by Pundit
  # @param [ActiveRecord] record the record to check on which the action should be executed
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end

