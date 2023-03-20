class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.all
  end

  def show
    @post.increment(:views)
  end

  def edit
    post_draft = PostDraft.find_by(id: params[:id])

    return unless post_draft

    @post.title = post_draft.title
    @post.body = post_draft.body
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end

  def autosave
    post_draft = PostDraft.find_or_initialize_by(id: params[:id])
    post_draft.assign_attributes(post_params)
    post_draft.save

    flash.now[:notice] = "Draft saved successfully"

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("flash", partial: "layouts/flash")
      end
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :views, :body)
  end
end
