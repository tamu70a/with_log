class Settings::ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child, only: [ :edit, :update, :destroy ]

  def index
    @children = current_user.children
  end

  def new
    @child = current_user.children.build
  end

  def create
  @child = current_user.children.build(child_params)
if @child.save
    redirect_to child_growth_records_path(@child), notice: "お子さま情報を登録しました"
else
    flash.now[:alert] = @child.errors.full_messages.join("、")

    render :new, status: :unprocessable_entity
end
end


  def edit; end

  def update
    if @child.update(child_params)
      redirect_to settings_children_path, notice: "お子さま情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @child.destroy
    redirect_to settings_children_path, notice: "お子さま情報を削除しました", status: :see_other
  end

  private

  def set_child
    @child = current_user.children.find(params[:id])
  end

  def child_params
    params.require(:child).permit(:name, :birthday)
  end
end
