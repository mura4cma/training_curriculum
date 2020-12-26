class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6) # ..（範囲オブジェクト）=> 最大値を含む範囲オブジェクトを作る

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      days = { :month => (@todays_date + x).month, :date => (@todays_date + x).day, :plans => today_plans, :wday => wdays[(@todays_date + x).wday]}
      #今日が日曜日であればDate.today.wdayの値は0、今日が月曜日であればDate.today.wdayの値は1です。このように、日曜を0とし、そこから土曜まで6までの数字を戻り値とします。
      #配列から値を取り出す場合も1番目は配列[0]、2番目は配列[1]のように書く
      @week_days.push(days)
    end

  end
end
