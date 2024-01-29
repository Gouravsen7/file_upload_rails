# frozen_string_literal: true

class HolesController < ApplicationController
  def create
    hole_data = Hole.import(params[:file])
    render json: Hole.ids
  end
end
