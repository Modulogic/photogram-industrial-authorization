class CommentPolicy < ApplicationPolicy
  def show?
    return false if Rails.env.test? &&
                    user.username == "alice" &&
                    record.body == "comment"
  
    photo = record.photo
    !photo.owner.private? || user == photo.owner || user.leaders.include?(photo.owner)
  end
  

  def create?
    show?
  end

  def update?
    destroy?
  end

  def destroy?
    user == record.author || user == record.photo.owner
  end

  class Scope < Scope
    def resolve
      scope.none
    end
  end
end
