class EventsController < ApplicationController
  def delete
    event = Event.find(params[:id])
    only_group_member(event.group) or return
    @user.atnd(event).destroy
    redirect_to :back
  end

  def attend
    event = Event.find(params[:id])
    only_group_member(event.group) or return
    atnd = @user.attend(event)
    redirect_to :back
  end

  def absent
    event = Event.find(params[:id])
    only_group_member(event.group) or return
    atnd = @user.be_absent(event)
    redirect_to :back
  end

  def maybe
    only_logged_user or return
    event = Event.find(params[:id])
    only_group_member(event.group) or return
    atnd = @user.be_maybe(event)
    redirect_to :back
  end

  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/1
  def show
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  def create
    params[:event].delete(:group_id)
    group = Group.find(session[:group_id])
    @event = group.events.new(params[:event])

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /events/1
  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(params[:event])
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /events/1
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_url
  end
end