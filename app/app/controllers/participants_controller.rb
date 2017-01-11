class ParticipantsController < BaseController
  before_action :authenticate, only: :trinities

  def index
    if params[:type]
      render json: Participant.where(type: params[:type]).page(params[:page])
    else
      render json: Participant.all.page(params[:page])
    end
  end

  # APP  endpoints
  def trinities
    render json: @current_user.trinities, include: 'overcomer,angel,archangel'
  end
end
