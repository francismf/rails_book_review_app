class BooksController < ApplicationController
  include BooksHelper
  before_action :find_book, only: [:show,:edit,:update, :destroy]
  before_action :authenticate_user! , only: [:new , :edit]
  before_action :add_books_to_cache , only: [:index]
  # cache_store

  def index(books = nil)
    @books = get_cache_objects("all_books")
    if @books.nil?
      add_books_to_cache
    end
    # if params[:category].blank?
    #   @books = Book.all.order("created_at DESC")
    # else
    #   @category_id = Category.find_by(name: params[:category]).id
    #   @books = Book.where(:category_id => @category_id).order("created_at DESC")
    # end
    respond_to do |format|
      format.html
      format.json  { render :json => @books }
    end
  end

  def show
    respond_to do |format|
      if @book
        format.html
        format.json  { render :json => @book }
      end
      else
        format.html
        format.json  {render :json => "book not found" }
      end
    end

    def new
      #@book = Book.new
      @book = current_user.books.build
      @categories = Category.all.map{|c| [c.name , c.id ]}
      respond_to do |format|
        format.html
        format.json  { render :json => @book }
      end
    end

    def create
      @book = current_user.books.build(book_params)
      @book.category_id = params[:category_id]
      if @book.save
        redirect_to root_path
      else
        render 'new'
      end
    end

    def edit
      @categories = Category.all.map{|c| [c.name , c.id ]}
      respond_to do |format|
        format.html
        format.json  { render :json => @book }
      end
    end


    def update
      @book.category_id = params[:category_id]
      if @book.update(book_params)
        redirect_to book_path(@book)
      else
        render 'edit'
      end
    end


    def destroy
      @book.destroy
      redirect_to root_path
    end


    private

    def add_books_to_cache
      if params[:category].blank?
        @books = Book.all.order("created_at DESC")
      else
        @category_id = Category.find_by(name: params[:category]).id
        @books = Book.where(:category_id => @category_id).order("created_at DESC")
      end
      set_cache_objects("all_books",@books)
    end

    def book_params
      params.require(:book).permit(:title,:description,:author,:category_id,:book_img)
    end

    def find_book
      all_books = get_cache_objects("all_books")
      @book = all_books.find(params[:id])
      if @book.nil?
        debugger
        @book = Book.find(params[:id])
      end
    end

  end


  #abc@yopmail.com
  #second@yopmail.com #test1234
