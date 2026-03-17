class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memo, only: [ :edit, :update, :destroy, :show ]

  def index
    @memos = current_user.memos.order(memo_date: :desc)

    # 検索
    if params[:q].present?
      @memos = @memos.where("content LIKE ?", "%#{params[:q]}%")
    end

    @memo = current_user.memos.new(memo_date: Date.current)
  end

  def new
    @memo = current_user.memos.new(memo_date: Date.current)
  end

  def create
  @memo = current_user.memos.new(memo_params)
  @memo.content = @memo.content.to_s.strip

  if @memo.save
    redirect_to memos_path
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit
  end

  def update
    if @memo.update(memo_params)
      redirect_to memos_path, notice: "メモを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

   def show
  end

  def destroy
    @memo.destroy
    redirect_to memos_path, notice: "メモを削除しました。"
  end

  private

  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:content, :memo_date)
  end
end
