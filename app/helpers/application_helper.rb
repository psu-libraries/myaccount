# frozen_string_literal: true

module ApplicationHelper
  ACTIVE_LINK_CLASS = ' active'

  def nav_link_attributes(path)
    controller = path.split('/')[1]
    {
      class: "nav-link hover-change rounded-0 py-3#{ACTIVE_LINK_CLASS if active_controller?(controller)}",
      aria: {
        current: ('page' if active_controller?(controller))
      }
    }
  end

  def current_year
    Date.today.year
  end

  def ill_manage_link(library_key)
    t('myaccount.ill.manage_url', library: library_key)
  end

  private

    def active_controller?(name)
      name == controller_name
    end
end
