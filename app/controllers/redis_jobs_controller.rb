# frozen_string_literal: true

class RedisJobsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    job_status = Redis.new.get(params[:id]) || {}
    render json: job_status
  end

  def destroy
    status = Redis.new.del(params[:id]) || {}
    render json: status
  end
end
