class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      # Turbo用（あとで書く）
    else
      # バリデーションエラー用
    end
  end

  def update
  @task = current_user.tasks.find(params[:id])

  # 編集
  if params[:edit]
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

  private

  def task_params
    params.require(:task).permit(:title)
  end
end
