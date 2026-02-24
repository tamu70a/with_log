class Settings::GrowthSettingsController < ApplicationController
  before_action :authenticate_user! # ログインしていない人は見れないようにする

  # 表示設定画面
  def show
    @user = current_user
  end

  # スイッチを切り替えた時の保存処理
  def update
    @user = current_user
    if @user.update(user_params)
      # 保存に成功したら、メッセージと一緒に設定画面に戻る
      redirect_to settings_growth_setting_path, notice: "表示設定を更新しました"
    else
      # 失敗した場合は画面を再表示
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:is_growth_record_enabled)
  end
end
