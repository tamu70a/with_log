class BodyRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 一覧表示用（すべてのデータ）
    @body_records = current_user.body_records.order(measured_on: :asc)
    # グラフ用（0より大きい正しいデータだけを抽出）
    @valid_records_for_chart = @body_records.where("weight > ?", 0)

    @body_record = current_user.body_records.new
    @current_goal = current_user.current_goal
    @latest_weight = current_user.body_records.where("weight > ?", 0).order(measured_on: :desc).first
  end

  def create
    @body_record = current_user.body_records.new(body_record_params)
    @body_record.measured_on ||= Date.today

    if @body_record.save
      redirect_to body_records_path, notice: "記録しました"
    else
      # エラーで index に戻る時の処理
      @body_records = current_user.body_records.order(measured_on: :asc)
      # グラフ用：保存に失敗した0のデータはDBにないので、DBの正しいデータだけを渡す
      @valid_records_for_chart = current_user.body_records.where("weight > ?", 0).order(measured_on: :asc)

      @current_goal = current_user.current_goal
      # ここも0を除外して取得
      @latest_weight = current_user.body_records.where("weight > ?", 0).order(measured_on: :desc).first

      render :index, status: :unprocessable_entity
    end
  end

  private

  def body_record_params
    params.require(:body_record).permit(:weight, :body_fat, :measured_on)
  end
end
