module ApplicationHelper
  include Pagy::Frontend

  def new_direction(direction)
    direction&.include?("asc") ? "desc" : "asc"
  end

  def current_sort(params)
    params[:query].try(:[], :s)
  end

  def prev_page
    @pagy.prev || 1
  end

  def next_page
    @pagy.next || @pagy.last
  end

  def ldate(date, hash = {})
    date ? l(date, **hash) : nil
  end

  def to_tonnes(kgs)
    (kgs / 1000.0).round(2)
  end  
end
