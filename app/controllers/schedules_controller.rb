class SchedulesController < ApplicationController
  permits :user_id, :title, :note, :start_time, :end_time

  def index(now_date)
    @now_date = now_date.present? ? Date.parse(now_date) : Date.today

    # スケジュールハッシュ生成
    @schedule_hash = Hash.new{ |hash, key| hash[key] = Array.new }
    @schedules = Schedule.where(user_id: current_user.id).where(start_time: (@now_date.beginning_of_month.beginning_of_day..@now_date.end_of_month.end_of_day)).order("start_time ASC")
    @schedules.each{ |s|
      @schedule_hash[s.start_time.strftime("%Y_%m_%d")].push(s)
    }

    # 祝日ハッシュ生成
    @holiday_hash = Hash.new
    HolidayJp.between(@now_date.beginning_of_month, @now_date.end_of_month).each{ |h|
      @holiday_hash[h.date] = h.name
    }

    # ## 次月分
    # @next_date = @now_date.next_month

    # # スケジュールハッシュ生成
    # @next_schedule_hash = Hash.new{ |hash, key| hash[key] = Array.new }
    # schedules = Schedule.where(user_id: current_user.id).where( start_time: (@next_date.beginning_of_month.beginning_of_day..@next_date.end_of_month.end_of_day)).order("start_time ASC")

    # schedules.each do |s|
    #   @next_schedule_hash[s.start_time.strftime("%Y_%m_%d")].push(s)
    # end

    # # 祝日ハッシュ生成
    # @next_holiday_hash = Hash.new
    # HolidayJp.between(@next_date.beginning_of_month, @next_date.end_of_month).each do |h|
    #   @next_holiday_hash[h.date] = h.name
    # end
  end

  def show(id)
    @schedule = Schedule.where(id: id, user_id: current_user.id).first
  end

  def new(date)
    @schedule = Schedule.new(start_time: date, end_time: date)
  end

  def edit(id)
    @schedule = Schedule.where(id: id, user_id: current_user.id).first
  end

  def create(schedule)
    @schedule = Schedule.new(schedule)
    @schedule.user_id = current_user.id

    if @schedule.save
      redirect_to(schedules_path(now_date: @schedule.start_time.strftime("%Y-%m-01")))
    else
      render action: "new"
    end
  end

  def update(id, schedule)
    @schedule = Schedule.where(id: id, user_id: current_user.id).first

    if @schedule.update(schedule)
      redirect_to(schedules_path(now_date: @schedule.start_time.strftime("%Y-%m-01")))
    else
      render action: "edit"
    end
  end

  def destroy(id)
    schedule = Schedule.where(id: id, user_id: current_user.id).first
    schedule.destroy ? flash[:notice] = "Schedule was successfully deleted." : flash[:alert] = "Schedule was failed deleted."

    redirect_to(schedules_path(now_date: schedule.start_time.strftime("%Y-%m-01")))
  end

  # オートページャー
  def pager(target_month, page)
    now_date = target_month.present? ? Date.parse("#{target_month}-01") : Date.today
    now_date = Date.parse(now_date.since(page.to_i.month).strftime("%Y-%m-01"))

    # スケジュールハッシュ生成
    schedule_hash = Hash.new{ |hash, key| hash[key] = Array.new }
    schedules = Schedule.where(user_id: current_user.id).where(start_time: (now_date.beginning_of_month.beginning_of_day..now_date.end_of_month.end_of_day)).order("schedules.start_time ASC")
    schedules.each{ |s|
      schedule_hash[s.start_time.strftime("%Y_%m_%d")].push(s)
    }

    # 祝日ハッシュ生成
    holiday_hash = Hash.new
    HolidayJp.between(now_date.beginning_of_month, now_date.end_of_month).each{ |h|
      holiday_hash[h.date] = h.name
    }

    render partial: '/schedules/calendar', locals: { now_date: now_date, holiday_hash: holiday_hash, schedule_hash: schedule_hash, current_page: (page.to_i + 1) }
  end
end
