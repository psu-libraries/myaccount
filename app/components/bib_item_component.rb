# frozen_string_literal: true

class BibItemComponent < ActionView::Component::Base
  CATALOG_URL = 'https://catalog.libraries.psu.edu/catalog/'

  def initialize(bibitem:)
    @title = bibitem.title
    @catkey = bibitem.catkey
    @type = bibitem.item_type_human
    @author = bibitem.author
    @call_number = bibitem.call_number
  end

  def processed_title
    return @title if @author.blank?

    "#{@title} / #{@author}"
  end

  def catalog_url
    CATALOG_URL + @catkey
  end

  private

    attr_reader :title, :catkey, :type, :author, :call_number
end
