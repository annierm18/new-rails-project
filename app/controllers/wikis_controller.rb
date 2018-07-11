class WikisController < ApplicationController
before_action :authorize_user, except: [:index, :show, :new, :create]

  include Pundit
  after_action :verify_authorized, except: [:destroy]
  after_action :verify_policy_scoped, only: [:user_wikis]

  def user_wikis
    @wikis = policy_scope(Wiki)
  end

  def authorize_user
     wiki = Wiki.find(params[:id])
 # #11
     unless current_user == wiki.user || current_user.admin?
       flash[:alert] = "You must be an admin to do that."
       redirect_to [wiki.topic, wiki]
     end
   end

  def index
    @wikis = WikiPolicy::Scope.new(current_user, Wiki).resolve
    @wikis = Wiki.all
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
    @wiki = policy_scope(Wiki).find(params[:id])

  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]

    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
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
     @wiki = Wiki.find(params[:id])

     if @wiki.destroy
       flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
       redirect_to wikis_path
     else
       flash.now[:alert] = "There was an error deleting the wiki."
       render :show
     end
   end

end
