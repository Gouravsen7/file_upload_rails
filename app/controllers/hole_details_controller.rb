# frozen_string_literal: true

class HoleDetailsController < ApplicationController
  require 'csv'
  before_action :set_uploaded_file, only: :create
  PAGE_SIZE = 1

   def create
    begin
      hole_id = File.basename(@file, File.extname(@file))
      csv_data = CSV.read(@uploaded_file)
      keys = csv_data.first
      values = csv_data[1..]
      parsed_data = values.map { |row| Hash[keys.zip(row)] }

      # hole_details = create_hole_detail(hole_id, parsed_data)
      hole_details = find_or_create_hole_detail(hole_id, parsed_data)
      hsh = generate_headers(keys)

      response_data = extract_response_data(hole_details)

      render json: { data: { bar_key: hsh, records: response_data['csv_data'] } }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def index
    hole_details = HoleDetail.page(params[:page].to_i || 1).per(PAGE_SIZE)
    keys = hole_details.first.try(:csv_data).try(:first).try(:keys) || []
    headers = generate_headers(keys)
    response_data = generate_response_data(hole_details)

    pagination_info = {
      current_page: hole_details.current_page,
      total_pages: hole_details.total_pages,
      total_records: hole_details.total_count
    }

    render json: {
      data: {
        bar_key: headers,
        records: response_data.dig(0, 'csv_data'),
        metadata: pagination_info
      }
    }, status: :ok
  end

  private

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

  def generate_headers(keys)
    keys[1..].each_with_index.map { |key, index| ["header#{index + 1}", key] }.to_h
  end

  def generate_response_data(hole_details)
    hole_details&.map { |record| record&.slice('csv_data') } || []
  end
end
