class SearchController < ApplicationController

  def search
    @books = params[:q].nil? ? [] : Book.search(params[:q])
    respond_to do |format|
      format.html
      format.json  { render :json => @books }
    end
  end
end
