# frozen_string_literal: true

class RedisJobsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    job_status = $REDIS_CLIENT.get(params[:id]) || { result: :not_found }
    render json: job_status
  end

  def destroy
    status = $REDIS_CLIENT.del(params[:id]) || { result: :not_found }
    render json: status
  end
end
