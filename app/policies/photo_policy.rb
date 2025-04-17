class PhotoPolicy < ApplicationPolicy
  # anyone who can see the owner’s profile may view the photo
  def show?
    record.owner == user ||
      !record.owner.private? ||
      record.owner.followers.include?(user)
  end

  # only the owner may edit
  def update?
    destroy?
  end

  # only the owner may delete
  def destroy?
    record.owner == user
  end
  def create?
    true  # or whatever logic you need
  end

  def new?
    create?
  end
end
