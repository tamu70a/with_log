class TasksController < ApplicationController
  before_action :authenticate_user!
  def create
    @task = current_user.tasks.build
    @task.editing = true

    if @task.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path }
      end
    else
      head :unprocessable_entity
    end
  end

  def update
  @task = current_user.tasks.find(params[:id])

  # 編集モード
  if params[:edit] == "true"
    respond_to { |format| format.turbo_stream }
    return
  end

  # チェックボックス
  if params.key?(:is_done)
    @task.update(is_done: params[:is_done] == "1")

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "task_#{@task.id}",
          partial: "tasks/task",
          locals: { task: @task }
        )
      end
    end
    return
  end

  # タイトル取得（安全版）
  title = params.dig(:task, :title)

  # 空タイトルなら削除
  if title.blank?
    @task.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("task_#{@task.id}")
      end
    end
    return
  end

  if @task.update(task_params)
    respond_to { |format| format.turbo_stream }
  else
    render turbo_stream: turbo_stream.replace(
      "task_#{@task.id}",
      partial: "tasks/edit",
      locals: { task: @task }
    ), status: :unprocessable_entity
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
