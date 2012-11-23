# coding: utf-8
class SchedulesController < ApplicationController
  #-------#
  # index #
  #-------#
  def index
    @schedules = Schedule.where( user_id: session[:user_id] ).all
  end

  #------#
  # show #
  #------#
  def show( id )
    @schedule = Schedule.where( id: id, user_id: session[:user_id] ).first
  end

  #-----#
  # new #
  #-----#
  def new
    @schedule = Schedule.new
  end

  #------#
  # edit #
  #------#
  def edit( id )
    @schedule = Schedule.where( id: id, user_id: session[:user_id] ).first
  end

  #--------#
  # create #
  #--------#
  def create( schedule )
    @schedule = Schedule.new( schedule )
    @schedule.user_id = session[:user_id]

    if @schedule.save
      redirect_to( schedules_path, notice: "Schedule was successfully created." )
    else
      render action: "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update( id, schedule )
    @schedule = Schedule.where( id: id, user_id: session[:user_id] ).first

    if @schedule.update_attributes( schedule )
      redirect_to( schedule_path( @schedule ), notice: "Schedule was successfully updated." )
    else
      render action: "edit"
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy( id )
    schedule = Schedule.where( id: id, user_id: session[:user_id] ).first
    schedule.destroy ? flash[:notice] = "Schedule was successfully deleted." : flash[:alert] = "Schedule was failed deleted."

    redirect_to schedules_path
  end
end
