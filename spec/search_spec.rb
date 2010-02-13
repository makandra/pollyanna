require File.dirname(__FILE__) + '/spec_helper'

describe Pollyanna::Search do

  describe 'scope_options' do
  
    it "should hand a :by option to conditions_for_find" do
      search = Pollyanna::Search.new("foo", "movies")
      search.should_receive(:conditions_for_find).with(:title)
      search.scope_options(:by => :title)
    end
    
    it "should return an options hash for a Rails scope" do
      search = Pollyanna::Search.new("foo", "movies")
      search.should_receive(:conditions_for_find).and_return("sql query")
      search.scope_options.should == { :conditions => "sql query" }
    end
    
  end
  
  describe 'conditions_for_find' do
  
    it "should return a LIKE query for the given query, looking in the search_text column by default and using the table name to disambiguate things" do
      search = Pollyanna::Search.new("word", "movies")
      search.send(:conditions_for_find).should == ['movies.search_text LIKE ?', "%word%"]
    end
    
    it "should look in another column if the #by argument is given" do
      search = Pollyanna::Search.new("word", "movies")
      search.send(:conditions_for_find, "words").should == ['movies.words LIKE ?', "%word%"]
    end
    
    it "should return a conjunction of LIKE queries for queries with multiple words" do
      search = Pollyanna::Search.new("foo bar", "movies")
      search.send(:conditions_for_find).should == ['movies.search_text LIKE ? AND movies.search_text LIKE ?', '%foo%', '%bar%']
    end
    
    it "should escape underscores in the query" do
      search = Pollyanna::Search.new("foo_bar", "movies")
      search.send(:conditions_for_find).should == ['movies.search_text LIKE ?', "%foo\\_bar%"]
    end
    
    it "should escape percent signs in the query" do
      search = Pollyanna::Search.new("foo%bar", "movies")
      search.send(:conditions_for_find).should == ['movies.search_text LIKE ?', "%foo\\%bar%"]
    end
  
  end

end
