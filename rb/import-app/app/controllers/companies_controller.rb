class CompaniesController < ApplicationController
  def index
    all_info = Company.all_info
    render json: all_info
  end
end
