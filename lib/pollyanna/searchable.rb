module Pollyanna
  module Searchable

    def self.included(klass)
      klass.class_eval do
        before_save :set_search_text
        named_scope :search, lambda { |*args| query, options = args; Search.new(query, table_name).scope_options(options) }
      end
    end
    
    def set_search_text
      self.search_text = search_text if respond_to?(:"search_text=")
    end

  end
end
