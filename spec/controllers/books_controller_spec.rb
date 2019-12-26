require "rails_helper"
require "spec_helper"
require_relative "../support/devise"

RSpec.describe BooksController, type: :controller do
  describe "GET #index" do
    # login_user

    context "Index page visible irrespective of login" do
      it "lists all books" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "Check for newly added book" do
        @category = Category.create(name: "Thriller")
        @book = Book.create( :title =>  "Evil Dead" , :description => "sample book for rspec" , :author => "francis" , :user_id => 2 , :category => @category , :book_img => File.open("#{Rails.root}/che.jpg") )
        get :index , { :format => :json }
        expect(response.body.include?(@book.title)).to be_truthy
        expect(response.body.include?(@book.description)).to be_truthy
        expect(response.body.include?(@book.author)).to be_truthy
        expect(response).to have_http_status(:success)
      end
    end
  end
  describe "GET #show" do
    context "Display the details of a book" do
      it "When a valid book id passed" do
        @category = Category.create(name: "Horror")
        @book = Book.create( :title =>  "SAW" , :description => "belongs to category horror" , :author => "James" , :user_id => 2 , :category => @category , :book_img => File.open("#{Rails.root}/che.jpg") )
        get :show , params: {id: @book.id , :format => :json}
        expect(response).to have_http_status(:success)
        expect(response.body.include?(@book.title)).to be_truthy
        expect(response.body.include?(@book.description)).to be_truthy
        expect(response.body.include?(@category.id.to_s)).to be_truthy
      end
      it "When a invalid book id passed" do
        get :show , params: {id: 10 , :format => :json}
        expect(response.body.include?("")).to be_truthy
      end
    end
  end

  describe "POST #create" do
    context "Books not created" do
      it "When category passed as nil" do
        @book = Book.create( :title =>  "Book without Category" , :description => "belongs to no category" , :author => "James" , :user_id => 2 , :book_img => File.open("#{Rails.root}/che.jpg") )
        expect(@book.errors.details[:category][0][:error].present?).to be_truthy
        expect(@book.errors.messages[:category].include?("must exist")).to be_truthy
      end

      it "When user passed as nil" do
        @book = Book.create( :title =>  "Book without Category" , :description => "belongs to no category" , :author => "James" , :book_img => File.open("#{Rails.root}/che.jpg") )
        expect(@book.errors.details[:user][0][:error].present?).to be_truthy
        expect(@book.errors.messages[:user].include?("must exist")).to be_truthy
      end

    end
  end

  describe "PUT #update" do
    context "Books are updated" do
      it "Update book title and description" do
        @category = Category.create(name: "old_category")
        @book = Book.create( :title =>  "Book need to be updated" , :description => "belongs to old category" , :author => "James" , :user_id => 2 , :category => @category , :book_img => File.open("#{Rails.root}/che.jpg") )
        get :edit, params: {:id => @book.id }
        put :update , params: {title: "Book title updated" , :category => @category }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE #destroy" do
    context "Books are destroyed" do
      it "When valid book id passed as param" do
        delete :destroy , params: {:id => @book.id.to_i }
        delete :destroy, :id => @book.id
      end
    end
  end

end
