require File.dirname(__FILE__) + '/spec_helper'

describe Pollyanna::Searchable do

  before(:each) do
    @starship_troopers = Movie.create!(:title => "Starship Troopers", :year => 1997, :director => "Paul Verhoeven")
    @fifth_element = Movie.create!(:title => "The Fifth Element", :year => 1997, :director => "Luc Besson")
    @matrix = Movie.create!(:title => "The Matrix", :year => 1999, :director => "Wachowski brothers")
  end

  it 'should index its search_text upon save' do
    @starship_troopers.should_receive("search_text=")
    @starship_troopers.save
  end
  
  it "use the search_text column to find matches" do
    Movie.search("1997").all.should == [@starship_troopers, @fifth_element]
  end
  
  it "should find single words" do
    Movie.search("The").all.should == [@fifth_element, @matrix]
  end
  
  it "should find multiple words using AND" do
    Movie.search("Matrix the").all.should == [@matrix]
  end
  
  it "should find records by another column than search_text" do
    Movie.search("Paul").should be_empty
    Movie.search("Paul", :by => :director).should == [@starship_troopers]
  end

end
