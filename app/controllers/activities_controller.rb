class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  # GET /activities
  # GET /activities.json
  def index
    @activities = Activity.paginate(:page => params[:page], :per_page => 25)
  end

  def neighborhood
    @activities = Activity.where(:neighborhood => params[:neighborhood].gsub("-"," "))
  end

  def category
    category_url = params[:category_list].gsub("+", " ")
    @activities = Activity.where("category_list LIKE ?", "%#{category_url}%")
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
    if current_user
      @review = Review.find_by(:user_id => current_user.id, :activity_id => @activity.id)
      @review = @activity.reviews.build(:user_id => session[:user_id]) if @review.nil?
      @rating = Rating.find_or_create_by(:activity_id => @activity.id, :user_id => current_user.id) 
    end
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render action: 'show', status: :created, location: @activity }
      else
        format.html { render action: 'new' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:name, :location, :blurb, :url, :type, :neighborhood, :category_list)
    end

end
