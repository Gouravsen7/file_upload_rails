# frozen_string_literal: true

class Hole < ApplicationRecord
  require 'csv'
  has_many :hole_details

  def self.import(file)
    begin
      opened_file = File.open(file)
      options = { headers: true }
      CSV.foreach(opened_file, **options) do |row|
        hole_data = Hole.create(
          hole_id: row['HoleId'],
          hole_name: row['HoleName'],
          start_point_x: row['StartPointX'],
          start_point_y: row['StartPointY'],
          start_point_z: row['StartPointZ'],
          end_point_x: row['EndPointX'],
          end_point_y: row['EndPointY'],
          end_point_z: row['EndPointZ']
        )
      end
    rescue StandardError => e
      puts "Error importing data: #{e.message}"
    ensure
      opened_file.close if opened_file
    end
  end
end

