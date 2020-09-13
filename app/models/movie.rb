class Movie < ActiveRecord::Base
    
    def self.get_ratings
        return ['G', 'PG', 'PG-13', 'R']
    end
    
    def self.with_ratings(ratings, sort)
       return Movie.where("rating IN (?)", ratings).order(sort) 
    end
    
end
