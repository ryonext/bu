# coding: utf-8
# TODO: 適正なcontrollerに再配置する
module Attendees
  extend ActiveSupport::Concern

  included do
    before_filter :login_required, only: [:attend]
    before_filter :_find_event, only: [:attend, :delete]
    before_filter :_find_group, only: [:attend]
    before_filter :_member_only, only: [:attend]
  end

  def cancel
    @event = Event.find(params[:id])
    only_event_manager(@event)
    @event.cancel
    redirect_to @event, notice: 'Event was successfully canceled.'
  end

  def be_active
    @event = Event.find(params[:id])
    only_event_manager(@event)
    @event.be_active
    redirect_to @event, notice: 'Event is active.'
  end

  def delete
    if @event.users.destroy(@user)
      redirect_to :back
    else
      redirect_to :back, :notice => 'error: Not deleted.'
    end
  end

  def attend
    if @user.atnd(@event)
      notice = 'atnd already is exist.'
    else
      @user.attend(@event)
    end

    redirect_to session[:redirect_path_after_event_show] || :back, notice: notice
  end

  def absent
    event = Event.find(params[:id])
    only_group_member(event.group)
    atnd = @user.be_absent(event)
    redirect_to :back
  end

  def maybe
    event = Event.find(params[:id])
    only_group_member(event.group)
    atnd = @user.be_maybe(event)
    redirect_to :back
  end

  private
  def _find_event
    @event = Event.find(params[:id])
  end

  def _find_group
    @group = Group.find(@event.group_id)
  end

  def _member_only #TODO
    if @group.public? and !@group.member?(@user)
      @group.users << @user
    end

    only_group_member(@group)
  end
end
