class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from User::NotAdministrator, :with => -> { redirect_to '/' }
  rescue_from User::UnAuthorized, :with => -> { redirect_to '/users/new' }
  rescue_from Group::NotGroupOwner, :with => -> { render :text => 'not group owner' }
  rescue_from Group::NotGroupManager, :with => -> { render :text => 'not group manager' }
  rescue_from Group::NotGroupMember, :with => -> { render :text => 'not group member' }
  rescue_from Event::NotEventManager, :with => -> { render :text => 'not event manager' }

  include Authentication

  private

  before_filter { @subtitle = ': beta' }

  before_filter {
    if controller_name != 'users' and controller_name != 'events' and controller_name != 'sessions'
      session.delete(:redirect_path_after_event_show)
    end
  }

  def only_group_owner(group = nil)
    login_required
    group ||= Group.find(params[:id])
    group.owner?(current_user) or raise(Group::NotGroupOwner)
  end

  def only_group_manager(group = nil)
    login_required
    group ||= Group.find(params[:id])
    group.manager?(current_user) or raise(Group::NotGroupManager)
  end

  def only_group_member(group = nil)
    login_required
    group ||= Group.find(params[:id])
    group.member?(current_user) or raise(Group::NotGroupMember)
  end

  def only_event_manager(event)
    login_required
    event.manager?(current_user) or raise(Event::NotEventManager)
  end
end
