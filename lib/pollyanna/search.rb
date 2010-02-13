module Pollyanna
  class Search

    def initialize(query, table_name)
      @words = (query || "").strip.downcase.split(/[\ \,\;]+/)
      @table_name = table_name
    end
    
    def scope_options(options = {})
      by = options && options.delete(:by)
      { :conditions => conditions_for_find(by) }
    end
    
  #  def select(objects, &content_method)
  #    content_method ||= &:search_text
  #    objects.select do |object|
  #      content = content_method.call(object).andand.downcase || ""
  #      @words.all? { |word| content.include? word }
  #    end
  #  end

    private
    
    def conditions_for_find(by = nil)
      unless @words.empty?
        by ||= :search_text
        patterns = @words.collect { |word| "%#{word}%" }
        likes = ["#{@table_name}.#{by} LIKE ?"] * patterns.count
        [likes.join(" AND "), *patterns]
      end
    end
    
  end
end
