module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
    end
  end

  def create_book(params)
  	debugger
  	@book = Book.new
  	@book.title = params["title"]
  	@book.description = params["description"]
  	@book.author = params["author"]
  	@book.user_id = params["user_id"]
  	@book.book_img = params["book_img"]
  end
end
