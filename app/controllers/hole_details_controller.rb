# frozen_string_literal: true

require 'csv' 
class HoleDetailsController < ApplicationController
  PAGE_SIZE = 1

  before_action :set_uploaded_file, only: %i[create]
  before_action :set_hole, :set_hole_detail, only: %i[index]
  before_action :authenticate_request

  def index
    if @hole_detail.present?
      render_response(meta_data: page_meta(@hole_detail))
    else
      render_empty_response
    end
  end

  def create
    @hole_detail = HoleDetail.import(@uploaded_file)
    if @hole_detail.errors.present?
      render json: { error: @hole_detail.errors.full_messages }
    else
      render_create_response
    end
  end

  private

  def set_hole_detail
    @hole_detail = @holes
  end

  def set_hole
    @holes = HoleDetail.page(params[:page].to_i || 1).per(PAGE_SIZE) 
  end

  def render_create_response
    response = {
      data: {
        file_name: "#{@hole_detail.hole_id}.csv",
        header_data: @hole_detail.generate_headers,
        records: @hole_detail.csv_data
      },
    }
    render json: response, status: :ok
  end

  def render_response(meta_data: nil)
    response = {
      data: {
        file_name: "#{@hole_detail[0].hole_id}.csv",
        header_data: @hole_detail[0].generate_headers,
        records: @hole_detail[0].csv_data
      },
    }.merge(meta_data: meta_data).compact 
    render json: response, status: :ok
  end

  def set_uploaded_file
    if params[:file].present?
      @uploaded_file = params[:file]
      @file = @uploaded_file.original_filename
    else
      render json: { message: "Please upload the file" }
    end
  end
end
