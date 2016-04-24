module ApplicationHelper
  def default_page_size
    Kaminari.config.default_per_page
  end

  def paginate(objects, options = {})
    options.reverse_merge!(theme: 'twitter-bootstrap-3')
    super(objects, options)
  end
end
