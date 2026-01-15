# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    # ★ここが超重要
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
end
