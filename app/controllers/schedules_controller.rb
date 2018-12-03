class SchedulesController < ApplicationController
  permits :user_id, :title, :note, :start_time, :end_time

  def index(now_date: nil)
    @now_date = now_date.present? ? Date.parse(now_date) : Date.today

    # スケジュール
    @schedule_hash = generate_schedule_hash(@now_date)

    # 祝日
    @holiday_hash = generate_holiday_hash(@now_date)

    # オフ日
    @off_days = OffDay.mine(current_user)
                      .where(target_day: @now_date.beginning_of_month..@now_date.since(12.month).end_of_month)
                      .pluck(:target_day)
  end

  def show(id)
    @schedule = Schedule.where(id: id, user_id: current_user.id).first
  end

  def new(date)
    @schedule = Schedule.new(start_time: date.to_time, end_time: date.to_time)
    @now_date = Date.parse(date)
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
    schedule = Schedule.find_by(id: id, user_id: current_user.id)

    redirect_to schedules_path, alert: 'スケジュールが存在しません。' and return if schedule.blank?

    schedule.destroy ? '' : flash[:alert] = "スケジュールが削除出来ませんでした。"

    redirect_to(schedules_path(now_date: schedule.start_time.strftime("%Y-%m-01")))
  end

  def set_off_day(target_day)
    OffDay.find_or_create_by!(target_day: target_day, user_id: current_user.id)

    redirect_to schedules_path(now_date: target_day)
  end

  def cancel_off_day(target_day)
    OffDay.mine(current_user).find_by(target_day: target_day).destroy

    redirect_to schedules_path(now_date: target_day)
  end

  # # オートページャー
  # def pager(target_month: nil, page: 1)
  #   now_date = target_month.present? ? Date.parse("#{target_month}-01") : Date.today
  #   now_date = Date.parse(now_date.since(page.to_i.month).strftime("%Y-%m-01"))

  #   # スケジュール
  #   schedule_hash = generate_schedule_hash(now_date)

  #   # 祝日
  #   holiday_hash = generate_holiday_hash(now_date)

  #   # オフ日
  #   off_days = OffDay.mine(current_user).where(target_day: now_date.beginning_of_month..now_date.end_of_month).pluck(:target_day)

  #   render partial: '/schedules/calendar', locals: { now_date: now_date, holiday_hash: holiday_hash, schedule_hash: schedule_hash, off_days: off_days, current_page: (page.to_i + 1) }
  # end

  private

  # スケジュールハッシュ生成
  def generate_schedule_hash(now_date)
    schedule_hash = Hash.new{ |hash, key| hash[key] = Array.new }
    schedules = Schedule.mine(current_user)
                        .where(start_time: (now_date.beginning_of_month.beginning_of_day..now_date.since(12.month).end_of_month.end_of_day))
                        .order("schedules.start_time ASC")

    schedules.each do |s|
      schedule_hash[s.start_time.strftime("%Y_%m_%d")].push(s)
    end

    return schedule_hash
  end

  # 祝日ハッシュ生成
  def generate_holiday_hash(now_date)
    holiday_hash = Hash.new

    HolidayJp.between(now_date.beginning_of_month, now_date.since(12.month).end_of_month).each do |h|
      holiday_hash[h.date] = h.name
    end

    return holiday_hash
  end
end
