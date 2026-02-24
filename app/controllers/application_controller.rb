class ApplicationController < ActionController::Base
  # デバイスのコントローラーが動くときだけ、この許可設定を実行するという命令
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録のときに nickname を許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :nickname ])

    # 情報更新のときに nickname と childcare_mode を許可する
    devise_parameter_sanitizer.permit(:account_update, keys: [ :nickname, :childcare_mode ])
  end
end
