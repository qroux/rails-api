class Api::V1::MissionsController < Api::V1::BaseController
  def index
    @missions = Mission.all
  end

  private

  def render_error
    render json: { errors: @missions.errors.full_messages },
      status: :unprocessable_entity
  end
end
