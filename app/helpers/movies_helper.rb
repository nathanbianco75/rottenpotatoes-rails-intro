module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def set_hilite(field)
    sort = params[:sort]
    if sort.to_s == field
      return 'hilite'
    else
      return nil
    end
  end
  
end
