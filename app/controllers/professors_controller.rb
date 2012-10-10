class ProfessorsController < ApplicationController

  def index
    @professors = Professor.find(:all,:conditions => ['name LIKE ?', "%#{params[:term]}%"],  :limit => 10, :order => 'name')
    respond_to do |format|
      format.json { render :json => @professors.map(&:name).compact.reject(&:blank?).to_json }
    end
  end
end
