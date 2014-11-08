module ApplicationHelper
  # This is gross and temporary
  def first_sentence(input)
    if input
      "#{input.split(/\.\s/).first}.".sub(/\.\.$/, '.')
    end
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end
end
