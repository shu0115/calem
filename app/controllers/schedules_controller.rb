# coding: utf-8
class SchedulesController < ApplicationController
  #-------#
  # index #
  #-------#
  def index( now_date )
    @now_date = now_date.present? ? Date.parse( now_date ) : Date.today

    # スケジュールハッシュ生成
    @schedule_hash = Hash.new{ |hash, key| hash[key] = Array.new }
    @schedules = Schedule.where( user_id: session[:user_id] ).where( start_time: (@now_date.beginning_of_month.beginning_of_day..@now_date.end_of_month.end_of_day) ).order( "start_time ASC" ).all

    @schedules.each{ |s|
      @schedule_hash[s.start_time.strftime("%Y_%m_%d")].push(s)
    }

    # 祝日ハッシュ生成
    @holiday_hash = Hash.new
    HolidayJp.between(@now_date.beginning_of_month, @now_date.end_of_month).each{ |h|
      @holiday_hash[h.date] = h.name
    }

    ## 次月分
    @next_date = @now_date.next_month

    # スケジュールハッシュ生成
    @next_schedule_hash = Hash.new{ |hash, key| hash[key] = Array.new }
    schedules = Schedule.where( user_id: session[:user_id] ).where( start_time: (@next_date.beginning_of_month.beginning_of_day..@next_date.end_of_month.end_of_day) ).order( "start_time ASC" ).all

    schedules.each{ |s|
      @next_schedule_hash[s.start_time.strftime("%Y_%m_%d")].push(s)
    }

    # 祝日ハッシュ生成
    @next_holiday_hash = Hash.new
    HolidayJp.between(@next_date.beginning_of_month, @next_date.end_of_month).each{ |h|
      @next_holiday_hash[h.date] = h.name
    }
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
  def new( date )
    @schedule = Schedule.new( start_time: date, end_time: date )
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
      redirect_to( schedules_path( now_date: @schedule.start_time.strftime("%Y-%m-01") ) )
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
      redirect_to( schedules_path( now_date: @schedule.start_time.strftime("%Y-%m-01") ) )
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
