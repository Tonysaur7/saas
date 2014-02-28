class MoviesController < ApplicationController

	def index
		@movies = Movie.all
	end

	def show
		id = params[:id]
		@movie = Movie.find(id)
	end

	def create
		@movie = Movie.create!(movie_params)
		flash[:notice] = "'#{@movie.title}' created."
		redirect_to movies_path
	end

	def destroy
		id = params[:id]
		@movie = Movie.find(id)
		@movie.destroy
		flash[:notice] = "'#{@movie.title}' deleted."
		redirect_to movies_path
	end

	private
	def movie_params
		params.require(:movie).permit(:title, :rating, :description, :release_date)
	end
end
