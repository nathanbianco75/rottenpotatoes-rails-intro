class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    use_session = false
    if not params[:sort].nil?
      @sort = params[:sort]
    elsif not session[:sort].nil?
      use_session = true;
      @sort = session[:sort]
    else
      @sort = nil
    end
    
    @all_ratings = Movie.get_ratings
    
    if not params[:ratings].nil?
      if params[:ratings].is_a?(Hash)
        @checked_ratings = params[:ratings].keys
      else
        @checked_ratings = params[:ratings]
      end
    elsif not session[:ratings].nil?
      use_session = true;
      @checked_ratings = session[:ratings]
    else
      @checked_ratings = @all_ratings
    end
    
    @movies = Movie.with_ratings(@checked_ratings, @sort)
    
    if @sort == :title
      @title_header = "hilite"
    elsif @sort == :release_date
      @release_date_header = "hilite"
    end
    
    session[:ratings] = @checked_ratings
    session[:sort] = @sort
    
    if use_session
      params[:ratings] = @checked_ratings
      params[:sort] = @sort
      flash.keep
      redirect_to movies_path(:sort => @sort, :ratings => @checked_ratings)
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
