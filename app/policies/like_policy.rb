class LikePolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    record.fan == user || record.photo.owner == user
  end
end
