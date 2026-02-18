class GrowthRecordsController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_child

  def index
    @month_age = params[:month_age] ? params[:month_age].to_i : @child.current_month_age
    @growth_record = @child.growth_records.find_or_initialize_by(month_age: @month_age)
  end

  # 保存処理を追加
  def create
    # 同じ月齢のデータがあれば上書き、なければ新規作成
    @growth_record = @child.growth_records.find_or_initialize_by(month_age: growth_record_params[:month_age])

    if @growth_record.update(growth_record_params)
      # 保存したら、その月齢のタブを開いた状態でリダイレクト
      redirect_to child_growth_records_path(@child, month_age: @growth_record.month_age), notice: "保存しました"
    else
      @month_age = growth_record_params[:month_age].to_i
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  # ストロングパラメータ（安全にデータを受け取るため）
  def growth_record_params
    params.require(:growth_record).permit(:body_height, :body_weight, :content, :month_age)
  end
end
