# app/controllers/home_notes_controller.rb
class HomeNotesController < ApplicationController
  before_action :authenticate_user!

  def update
    home_note = current_user.home_note
    home_note.update!(home_note_params)
    render json: { status: "ok" }
  end

  private

  def home_note_params
    params.require(:home_note).permit(:content)
  end
end
