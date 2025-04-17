class FollowRequestPolicy < ApplicationPolicy
  def show?
    user == record.recipient || user == record.sender
  end

  def create?
    true
  end

  def destroy?
    user == record.sender || user == record.recipient
  end

  def update?
    destroy?
  end
end
