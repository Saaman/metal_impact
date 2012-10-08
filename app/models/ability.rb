class Ability
  include CanCan::Ability

  def initialize(user)
    
    alias_action :search, :smallblock, :to => :read
    
    user ||= User.new # guest user (not logged in)
    
    can :read, :all
    can :create, User
    cannot :read, Contributable, published: false
    cannot :read, User do |other_user| user.id != other_user.id end

    return if user.new_record?

    #########  signed-in users only  #########

    can [:destroy, :update], User, :id => user.id

    if user.role_cd >= User.roles[:staff]
      can :manage, Contributable
      cannot :manage, Contributable do |contributable|
        !contributable.published && contributable.updater_id != user.id
      end
      cannot :bypass_approval, :all

      if user.admin?
        can :manage, :all
        can :bypass_approval, :all
      end

      #common cannots for users >= staff
      cannot :destroy, User, :id => user.id
    end

    #common cannots for signed-in users
    cannot :create, User
  end
end
