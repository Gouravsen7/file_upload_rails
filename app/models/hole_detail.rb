# frozen_string_literal: true

class HoleDetail < ApplicationRecord
  belongs_to :hole

  def generate_headers
    csv_headers.map do |key|
      {
        header_title: key,
        start_point_z: hole.start_point_z,
        end_point_z: hole.end_point_z 
      }
    end
  end
  
  def generate_response_data
    csv_data&.map { |record| record&.slice('csv_data') } || []
  end

  def self.import(file)
    hole_id = File.basename(file.original_filename, File.extname(file))
    hole_detail = HoleDetail.find_or_create_by(hole_id: hole_id) 
    rows = []
    CSV.foreach(file, headers: true) do |row|
      rows << row.to_h
    end
    hole_detail.update(csv_data: rows)
    hole_detail
  end

  def csv_headers
    csv_data&.first&.keys&.drop(1)
  end
end
