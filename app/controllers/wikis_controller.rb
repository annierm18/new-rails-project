class WikisController < ApplicationController
before_action :authorize_user, except: [:index, :show, :new, :create]


  include Pundit
  after_action :verify_authorized, except: [:destroy]
  after_action :verify_policy_scoped, only: [:user_wikis]

  def user_wikis
    @wikis = policy_scope(Wiki)
    authorize @wiki
  end

  def authorize_user
     authorize @wiki
     unless current_user == wiki.user || current_user.admin?
       flash[:alert] = "You must be an admin to do that."
       redirect_to [wiki.topic, wiki]
     end
   end

  def index
    @wikis = WikiPolicy::Scope.new(current_user, Wiki).resolve
    @wikis = Wiki.all
    @wikis = policy_scope(Wiki)
    authorize @wikis
  end

  def show
    @wiki = policy_scope(Wiki).find(params[:id])
    @user = authorize User.find(params[:id])
      wiki = Wiki.find_by(attribute: "value")
      if wiki.present?
        authorize wiki
      else
        skip_authorization
      end
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    authorize @wiki
  end

  def update
       @wiki = Wiki.find(params[:id])
       @wiki.title = params[:wiki][:title]
       @wiki.body = params[:wiki][:body]

       authorize @wiki
       if @wiki.update(wiki_params)
         redirect_to @wiki
       else
         render :edit
       end

       if @wiki.save
         flash[:notice] = "Wiki was updated."
         redirect_to @wiki
       else
         flash.now[:alert] = "There was an error saving the wiki. Please try again."
         render :edit
       end
     end

     def destroy
     authorize @wiki

     if @wiki.destroy
       flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
       redirect_to wikis_path
     else
       flash.now[:alert] = "There was an error deleting the wiki."
       render :show
     end
   end

  def publish
    @wiki = Wiki.find(params[:id])
    authorize @wiki, :update?
    @wiki.publish!
    redirect_to @wiki
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.find(params[:id])
      authorize @wiki
    end

    # Never trust parameters from the scary internet, only allow the white list through.

end
