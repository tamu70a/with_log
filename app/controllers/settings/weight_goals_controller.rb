module Settings
  class WeightGoalsController < ApplicationController
    before_action :authenticate_user!
    # show, edit, update, destroy の時はIDで特定のデータを探す
    before_action :set_weight_goal, only: [ :show, :edit, :update, :destroy ]

    def new
      # has_many なので .build を使います
      @weight_goal = current_user.weight_goals.build
    end

    def show
    end

    def edit
    end

    def create
  @weight_goal = current_user.weight_goals.build(weight_goal_params)
  if @weight_goal.save
    # 成功時：作成したデータの詳細画面(show)へ飛ばす。sなしのパスに (@weight_goal) を渡す。
    redirect_to settings_weight_goal_path(@weight_goal), notice: "目標体重を設定しました"
  else
    render :new, status: :unprocessable_entity
  end
end

def update
  if @weight_goal.update(weight_goal_params)
    # 更新時も同様
    redirect_to settings_weight_goal_path(@weight_goal), notice: "更新しました"
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
      @weight_goal.destroy
      redirect_to settings_weight_goals_path, notice: "削除しました"
end

    private

    def set_weight_goal
      # ここが重要！params[:id] で探す
      @weight_goal = current_user.weight_goals.find(params[:id])
    end

    def weight_goal_params
      params.require(:weight_goal).permit(:target_weight, :target_date)
    end
  end
end
