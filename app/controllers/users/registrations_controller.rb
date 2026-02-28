# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    resource.skip_confirmation!

    resource.save
    yield resource if block_given?

    if resource.persisted?
      sign_up(resource_name, resource)
      redirect_to root_path, notice: "登録が完了しました"
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
  protected

  def after_update_path_for(resource)
    # プロフィール編集画面（今の画面）に戻る
    edit_user_registration_path
  end
end
