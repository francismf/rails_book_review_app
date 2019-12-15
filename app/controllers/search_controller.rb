class SearchController < ApplicationController

	def search
		@books = params[:q].nil? ? [] : Book.search(params[:q])
	end
end
