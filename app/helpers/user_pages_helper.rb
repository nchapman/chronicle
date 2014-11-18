module UserPagesHelper
  def action_button(user_page, attribute, opts = {})
    opts = {
      label: '',
      active_label: '',
      class: '',
      icon: ''
    }.merge(opts)

    active = !!user_page.send(attribute)
    css_classes = [ opts[:class] ]
    css_classes << 'active' if active

    a_opts = {
      href: '',
      class: css_classes.join(' '),
      'data-id' => user_page.id,
      'data-label' => opts[:label],
      'data-active-label' => opts[:active_label]
    }

    content_tag :a, a_opts do
      concat(icon(opts[:icon]))
      concat(' ')
      concat(content_tag(:span, class: 'label') do
        active ? opts[:active_label] : opts[:label]
      end)
    end
  end
end
