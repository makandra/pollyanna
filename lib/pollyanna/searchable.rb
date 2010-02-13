module Pollyanna
  module Searchable

    def self.included(klass)
      klass.class_eval do
        before_save :set_search_text
        # Use Proc.new so the number of arguments does not matter
        named_scope :search, Proc.new { |query, options| Search.new(query, table_name).scope_options(options) }
      end
    end
    
    def set_search_text
      self.search_text = search_text if respond_to?(:"search_text=")
    end

  end
end
