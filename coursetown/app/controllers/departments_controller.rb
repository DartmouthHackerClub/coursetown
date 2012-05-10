class DepartmentsController < ApplicationController

  def index
    @departments = Department.find(:all,:conditions => ['name LIKE ?', "%#{params[:term]}%"],  :limit => 10, :order => 'name')
    respond_to do |format|
      format.json { render :json => @departments.map(&:abbr).compact.reject(&:blank?).to_json }
    end
  end
end
