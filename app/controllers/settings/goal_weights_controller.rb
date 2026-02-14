module Settings
  class GoalWeightsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_goal_weight, only: [ :show, :edit, :update, :destroy ]

    def show
    end

    def new
      @goal_weight = current_user.build_goal_weight
    end

    def create
      @goal_weight = current_user.build_goal_weight(goal_weight_params)
      if @goal_weight.save
        redirect_to settings_goal_weight_path, notice: "目標体重を設定しました"
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @goal_weight.update(goal_weight_params)
        redirect_to settings_goal_weight_path, notice: "更新しました"
      else
        render :edit
      end
    end

    def destroy
      @goal_weight.destroy
      redirect_to settings_goal_weight_path, notice: "削除しました"
    end

    private

    def set_goal_weight
      @goal_weight = current_user.goal_weight
    end

    def goal_weight_params
      params.require(:goal_weight).permit(:weight)
    end
  end
end
