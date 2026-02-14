module Settings
  class BodyRecordsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_body_record, only: [ :show, :edit, :update, :destroy ]

    def index
      @body_records = current_user.body_records.order(measured_on: :desc)
    end

    def show
    end

    def edit
    end

    def update
      if @body_record.update(body_record_params)
        redirect_to settings_body_records_path, notice: "更新しました"
      else
        render :edit
      end
    end

    def destroy
      @body_record.destroy
      redirect_to settings_body_records_path, notice: "削除しました"
    end

    private

    def set_body_record
      @body_record = current_user.body_records.find(params[:id])
    end

    def body_record_params
      params.require(:body_record).permit(:measured_on, :weight, :body_fat)
    end
  end
end
