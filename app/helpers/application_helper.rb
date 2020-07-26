# frozen_string_literal: true

module ApplicationHelper
  def nav_link_attributes(path)
    {
      class: "nav-link #{('active' if active_controller?(path))}",
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
