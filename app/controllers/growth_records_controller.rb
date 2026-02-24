class GrowthRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child

  def index
    @month_age = params[:month_age] ? params[:month_age].to_i : @child.current_month_age
    # その月齢のデータを取得なければ新しく作る（保存はしない）
    @growth_record = @child.growth_records.find_or_initialize_by(month_age: @month_age)
  end

  def create
    month_age_to_save = growth_record_params[:month_age].to_i
    # 1. まずその月齢のデータがあるか探す（なければ作る）
    @growth_record = @child.growth_records.find_or_initialize_by(month_age: growth_record_params[:month_age])

    # 2. 【重要】見つかったデータ（または新規）に対して、フォームの値を「代入」する
    @growth_record.assign_attributes(growth_record_params)

    # 3. 保存する（これで新規ならINSERT、既存ならUPDATEが走る）
    if @growth_record.save
      redirect_to child_growth_records_path(@child, month_age: @growth_record.month_age),
                  notice: "成長記録を保存しました",
                  status: :see_other
    else
      @month_age = growth_record_params[:month_age].to_i
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @record = @child.growth_records.find(params[:id])
    if @record.update(growth_record_params)
      redirect_to child_growth_records_path(@child, month_age: @record.month_age),
                  notice: "更新しました",
                  status: :see_other
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def growth_record_params
    params.require(:growth_record).permit(:body_height, :body_weight, :content, :month_age)
  end
end
