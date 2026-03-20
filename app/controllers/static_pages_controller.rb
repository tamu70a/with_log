class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :top ], raise: false

  def top
    if user_signed_in?
      redirect_to homes_index_path
    end
  end
end
