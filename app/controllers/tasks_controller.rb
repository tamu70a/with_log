class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    @task = current_user.tasks.new(title: "")
    @task.editing = true

    if @task.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path }
      end
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])

    # 1. 編集モードへの切り替え
    if params[:edit]
      respond_to do |format|
        format.turbo_stream
      end
      return
    end

    # 2. 完了チェックの切り替え
    if params.key?(:is_done)
  @task.update(is_done: params[:is_done] == "1")

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.replace(@task),
        turbo_stream.update("buddy_message_area",
                            partial: "homes/buddy_message",
                            locals: { message: current_user.buddy_message(fetch_ai: false) })
      ]
    end
  end
  return
    end

    # 3. タイトルの保存処理
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
