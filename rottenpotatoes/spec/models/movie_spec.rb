require 'spec_helper'
require 'rails_helper'

describe Movie do
    describe 'Search movies by director' do
        it 'should show all the movies by the same director' do
          movie1=FactoryGirl.create(:movie,:title =>'title1' ,:director => 'George Lucas')
          movie2=FactoryGirl.create(:movie,:title =>'title2' ,:director => 'George Lucas')
          movie3=FactoryGirl.create(:movie,:title =>'title3' ,:director => 'Steven Spielberg')
          movies=Movie.search_by_director('George Lucas')
          expect(movies).to contain_exactly(movie1,movie2)
        end
        
         it 'shouldnt return any other movies from diferent directors' do
          movie1=FactoryGirl.create(:movie,:title =>'title1' ,:director => 'George Lucas')
          movie2=FactoryGirl.create(:movie,:title =>'title2' ,:director => 'George Lucas')
          movie3=FactoryGirl.create(:movie,:title =>'title3' ,:director => 'Steven Spielberg')
          movies=Movie.search_by_director('George Lucas')
          expect(movies).not_to include(movie3)
        end
    end
end
