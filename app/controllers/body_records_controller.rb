class BodyRecordsController < ApplicationController
  before_action :authenticate_user!

def index
  @body_records = current_user.body_records.order(measured_on: :asc)
  @body_record = current_user.body_records.new
end

def create
  @body_record = current_user.body_records.new(body_record_params)
  @body_record.measured_on ||= Date.today

  if @body_record.save
    redirect_to body_records_path, notice: "登録しました"
  else
    @body_records = current_user.body_records.order(measured_on: :asc)
    render :index, status: :unprocessable_entity
  end
end

private

def body_record_params
  params.require(:body_record).permit(:weight, :body_fat, :measured_on)
end
end
