class TasksController < ApplicationController
  before_action :authenticate_user!

# app/controllers/tasks_controller.rb
def create
  @task = current_user.tasks.new(title: "")  # 空タイトルでもOK
  @task.editing = true  # ← 追加直後は編集状態

  if @task.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end
end


  def update
  @task = current_user.tasks.find(params[:id])

  Rails.logger.debug "=== UPDATE PARAMS ==="
  Rails.logger.debug params.inspect

  # 編集
  if params[:edit]
    respond_to do |format|
      format.turbo_stream
    end
    return
  end

  # 完了チェック切り替え
  if params.key?(:is_done)
  @task.update(is_done: params[:is_done] == "1")

  respond_to do |format|
    format.turbo_stream
  end
  return
end



  # 保存処理
  if @task.update(task_params)
    respond_to do |format|
      format.turbo_stream
    end
  end
end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :is_done)
  end
end
