class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, :all
    can :show, :all
    can :manage, User, id: user.id
    cannot :create, User
    can :manage, :all if ENV['admin'].split.include? user.email
  end
end
