# app/controllers/settings/buddy_settings_controller.rb
class Settings::BuddySettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(buddy_params)
      # 成功したら表示画面(show)へ。通知メッセージは「WithLog+」らしく。
      redirect_to settings_buddy_setting_path, notice: "バディの設定を保存しました。これからもよろしくね！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def buddy_params
    # 育児モードのON/OFFを許可
    params.require(:user).permit(:childcare_mode)
  end
end
