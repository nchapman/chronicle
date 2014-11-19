module ApplicationHelper
  # This is gross and temporary
  def first_sentence(input, length = 200)
    if input
      truncate("#{input.split(/\.\s/).first}.".sub(/\.\.$/, '.'), length: length)
    end
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
