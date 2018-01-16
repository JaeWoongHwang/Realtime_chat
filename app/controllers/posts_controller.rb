class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def talk
    # 1. DB에 Talk를 저장하는 코드
    @talk = Talk.new(
      message: params[:msg]
    )
    @talk.save
    # 채널이름과 이벤트 이름 설정
    # JW-채널에서 JW-이벤트가 발생하면 다음과 같은 데이터를 날려라
    # 2. pusher server에 talk를 보낸다 (data.message 형태로 보내질 것)
    Pusher.trigger('JW-channel', 'JW-event', {
      message: params[:msg]
    })
    render nothing: true
  end

  def hello
    @talks = Talk.all.reverse
  end

  def add_comment
    @comment = Comment.new(
      content: params[:content],
      post_id: params[:id]
    )
    @comment.save
    # 이름이 같으면 밑의 코드 생략가능
    # render :add_comment
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
