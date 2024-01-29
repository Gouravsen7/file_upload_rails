# frozen_string_literal: true

require 'csv' 
class HoleDetailsController < ApplicationController
  before_action :set_uploaded_file, only: :create
  before_action :authenticate_request
  PAGE_SIZE = 1

  def index
    begin
      hole_details = HoleDetail.page(params[:page].to_i || 1).per(PAGE_SIZE)
      keys = hole_details&.first&.try(:csv_data).try(:first).try(:keys) || []

      if hole_details.present?
        hole_id = Hole.find_by(hole_id: hole_details[0].hole_id)
        headers = generate_headers(keys, hole_id)
        response_data = generate_response_data(hole_details)
        render_response(headers, response_data, hole_details)
      else
        render_empty_response
      end
    rescue => e
      nil
    end
  end

  def create
    begin
      hole_id = File.basename(@file, File.extname(@file))
      csv_data = CSV.read(@uploaded_file)

      keys = csv_data.first
      values = csv_data[1..]
      parsed_data = values.map { |row| Hash[keys.zip(row)] }

      hole_details = find_or_create_hole_detail(hole_id, parsed_data)
      hsh = create_headers(keys)

      response_data = extract_response_data(hole_details)
      # render json: HoleDetailSerializer.new(response_data).serialized_json, status: :ok

      render json: { data: { header_data: hsh, records: response_data['csv_data'] } }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def render_empty_response
    render json: { data: {} }, status: :ok
  end

  def render_response(headers, response_data, hole_details)
    render json: {
      data: {
        file_name: "#{hole_details.first.hole_id}.csv",
        header_data: headers,
        records: response_data.dig(0, 'csv_data'),
        metadata: {
          current_page: hole_details.current_page,
          total_pages: hole_details.total_pages
        }
      }
    }, status: :ok
  end

  def find_or_create_hole_detail(hole_id, parsed_data)
    existing_hole_detail = HoleDetail.find_by(hole_id: hole_id)

    if existing_hole_detail
      existing_hole_detail.update(csv_data: parsed_data)
      existing_hole_detail
    else
      create_hole_detail(hole_id, parsed_data)
    end
  end

  def set_uploaded_file
    @uploaded_file = params[:file]
    @file = @uploaded_file.original_filename
  end

  def create_hole_detail(hole_id, parsed_data)
    HoleDetail.create(hole_id: hole_id, csv_data: parsed_data)
  end

  def extract_response_data(hole_details)
    hole_details&.attributes&.slice('hole_id', 'csv_data') || {}
  end

  def create_headers(keys)
    keys[1..].map { |key| { "header_title" => key } }
  end

  def generate_headers(keys, hole_id)
    keys[1..].map { |key| { "header_title" => key, "start_point_z" => hole_id.start_point_z, "end_point_z" => hole_id.end_point_z } }
  end

  def generate_response_data(hole_details)
    hole_details&.map { |record| record&.slice('csv_data') } || []
  end
end
