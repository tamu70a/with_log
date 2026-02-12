class MemosController < ApplicationController
  
  before_action :authenticate_user!
  
    def index
      @memos = current_user.memos.order(memo_date: :desc)
      @memo = current_user.memos.new
    end
  
    def create
      @memo = current_user.memos.new(memo_params)
      if @memo.save
        redirect_to memos_path, notice: "メモを作成しました。"
      else
        @memos = current_user.memos.order(memo_date: :desc)
        render :index
      end
    end
  
    def edit
      @memo = current_user.memos.find(params[:id])
    end
  
    def update
      @memo = current_user.memos.find(params[:id])
      if @memo.update(memo_params)
        redirect_to memos_path, notice: "メモを更新しました。"
      else
        render :edit
      end
    end
  
    def destroy
      @memo = current_user.memos.find(params[:id])
      @memo.destroy
      redirect_to memos_path, notice: "メモを削除しました。"
    end
  
    private
  
    def memo_params
      params.require(:memo).permit(:content, :memo_date)
    end
end