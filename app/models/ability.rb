class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :search, :smallblock, :to => :read
    alias_action :prepare, :approve, :refuse, :to => :update
    alias_action :clear, :to => :destroy
    alias_action :upvote, :downvote, :to => :vote

    user ||= User.new # guest user (not logged in)

    can :read, :all
    cannot :show_image, :home
    cannot :markdown_preview, :utils
    cannot :manage, [Import::SourceFile, Import::Entry, Contribution]
    cannot :manage, :dashboard
    can :create, User
    cannot :read, Contributable, published: false
    cannot :read, User do |other_user| user.id != other_user.id end

    return if user.new_record?

    #########  signed-in users only  #########

    can [:destroy, :update], User, :id => user.id
    can :show_image, :home
    can :markdown_preview, :utils
    can :vote, :all

    if user.role_cd >= User.roles[:staff]
      can :create, Contributable
      can [:read, :update], Contributable do |contributable|
        contributable.published || contributable.owner == user
      end
      cannot :bypass_contribution, :all

      if user.admin?
        can :manage, :all
        can :bypass_contribution, :all
        can :manage, :dashboard
      end

      #common cannots for users >= staff
      cannot :destroy, User, :id => user.id
    end

    #common cannots for signed-in users
    cannot :create, User
  end
end
