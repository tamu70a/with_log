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

  private

  def task_params
    params.require(:task).permit(:title)
  end
end
