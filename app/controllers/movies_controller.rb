class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
  end

  def index
    #all code sits here for the homework
    @movies = Movie.all #by default return all the movies
    
    @redirect = 0 
    
    #checked corresponds to the check boxes
    if(@checked != nil)
      @movies = @movies.find_all{ |m| @checked.has_key?(m.rating) and  @checked[m.rating]==true}      
    end
    
    #allow sort by title
    if(params[:sort].to_s == 'title')
    session[:sort] = params[:sort]
    @movies = @movies.sort_by{|m| m.title }
   elsif(session.has_key?(:sort) ) #session manage
    params[:sort] = session[:sort]
    @redirect = 1
   end
    
    #link ratings in movies with the ckeck boxes
    if(params[:ratings] != nil)
      session[:ratings] = params[:ratings]
      @movies = @movies.find_all{ |m| params[:ratings].has_key?(m.rating) }
    elsif(session.has_key?(:ratings) ) #session manage
      params[:ratings] = session[:ratings]
      @redirect =1
    end
    
    
    if(@redirect ==1)
    redirect_to movies_path(:sort=>params[:sort], :ratings =>params[:ratings] )
    end

    #connect movie ratings and checkboxes
    @checked = {}
    @all_ratings =  ['G','PG','PG-13','R']

    @all_ratings.each { |rating|
      if params[:ratings] == nil
        @checked[rating] = false
      else
        @checked[rating] = params[:ratings].has_key?(rating)
      end
    }
    
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
