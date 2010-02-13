class Movie < ActiveRecord::Base
  include Pollyanna::Searchable
  
  def search_text
    "#{title} #{year}"
  end
  
  def <=>(other)
    title.downcase <=> other.downcase
  end

end
