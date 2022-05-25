module NavHelper
  def nav_link_class(root_path)
    if request.path.start_with?(*root_path)
      active_class
    else
      non_active_class
    end
  end

  private

  def non_active_class
    "text-white hover:bg-indigo-500 hover:bg-opacity-75 px-3 py-2 rounded-md text-sm font-medium"
  end

  def active_class
    "bg-indigo-700 text-white px-3 py-2 rounded-md text-sm font-medium"
  end
end