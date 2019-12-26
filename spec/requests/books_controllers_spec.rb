require 'rails_helper'

RSpec.describe "BooksControllers", type: :request do
  describe "GET /books_controllers" do
  	login_user
    it "works! (now write some real specs)" do
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
