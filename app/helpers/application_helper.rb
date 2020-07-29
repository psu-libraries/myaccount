# frozen_string_literal: true

module ApplicationHelper
  ACTIVE_LINK_CLASS = 'active-nav-link'

  def nav_link_attributes(path)
    {
      class: "nav-link hover-change rounded-0 py-3 #{(ACTIVE_LINK_CLASS if active_controller?(path))}",
      aria: {
        current: ('page' if active_controller?(path))
      }
    }
  end

  def derive_path(path_string)
    send "#{path_string}_path"
  end

  def current_year
    Date.today.year
  end

  private

    def active_controller?(name)
      name == controller_name
    end
end
