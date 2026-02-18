# クラス名が Settings::GrowthSettings::DisplaysController になる点に注目！
class Settings::GrowthSettings::DisplaysController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to settings_growth_setting_display_path, notice: "更新しました"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:is_growth_record_enabled)
  end
end
