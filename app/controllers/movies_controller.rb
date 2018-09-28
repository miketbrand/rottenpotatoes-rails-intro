class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def get_ratings
    return ['G','PG','PG-13','R']
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    if(params[:sort] == 'title' || params[:sort] == 'date')
      session[:sort_choice] = params[:sort]
    end
    
    @selected_ratings = params[:ratings]
    if(!(@selected_ratings.nil?))
      session[:ratings_keys] = @selected_ratings.keys
    elsif(!(session.exists?))
      session[:ratings_keys] = Movie.all_ratings
    end
    
    @all_ratings = Movie.all_ratings    # decides what boxes will exist
    @ratings_keys = session[:ratings_keys]   # decides what boxes will be pre-checked
    
    case session[:sort_choice]
    when 'title'
      @movies = Movie.where(:rating => session[:ratings_keys]).order('title')
      @titleClicked = true
      @dateClicked = false
    when 'date'
      @movies = Movie.where(:rating => session[:ratings_keys]).order('release_date')
      @titleClicked = false
      @dateClicked = true
    else
      @movies = Movie.where(:rating => session[:ratings_keys]).order(:title => :asc)
      @titleClicked = false
      @dateClicked = false
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
