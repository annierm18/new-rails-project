class WikisController < ApplicationController



  include Pundit
  after_action :verify_authorized, except: [:destroy, :show]
  after_action :verify_policy_scoped, only: [:user_wikis]

  def user_wikis
    @wikis = policy_scope(Wiki)
    authorize @wiki
  end


  def index
    @wikis = Wiki.public.order("created_at desc").where(current_user.following_ids)
    @wikis = WikiPolicy::Scope.new(current_user, Wiki).resolve
    @wikis = Wiki.all
    @wikis = policy_scope(Wiki)
    authorize @wikis
  end

  def show
    @wiki = policy_scope(Wiki).find(params[:id])
    @user = current_user
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
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def update
       @wiki = Wiki.find(params[:id])
      # @wiki.title = params[:wiki][:title]
      # @wiki.body = params[:wiki][:body]

       authorize @wiki
       if @wiki.update(wiki_params)
         redirect_to @wiki
      # else
      #   render :edit
      # end

    elsif @wiki.save
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

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.find(params[:id])
      authorize @wiki
    end

    # Never trust parameters from the scary internet, only allow the white list through.

end
