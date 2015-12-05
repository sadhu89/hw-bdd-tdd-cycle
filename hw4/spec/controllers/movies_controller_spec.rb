require 'spec_helper'
require 'rails_helper'

describe MoviesController do
    describe '#create' do
        movie_params={"title"=>"Alien"}
        
        it 'should call the model method that create a Movie' do
            expect(Movie).to receive(:create!).with(movie_params).and_return(Movie.new(movie_params))
            post :create, {:movie => movie_params}
        end
        
        it 'should redirect to homepage'do
            post :create, {:movie => movie_params}
            expect(response).to redirect_to(movies_path)
        end

        it 'should display the message was successfully created.'do
            post :create, {:movie => movie_params}
            expect(flash[:notice]).to eq("#{movie_params["title"]} was successfully created.")
        end
        
    end
    
    describe '#update' do
        movie_params={"title"=>"Alien"}
        it 'should call the model method that update a Movie' do
            movie=FactoryGirl.create(:movie,:title =>'title1' ,:director => 'George Lucas')
            Movie.stub(:find).and_return(movie)
            expect(movie).to receive(:update_attributes!).with(movie_params).and_return(movie.update_attributes!(movie_params))
            put :update, {:id=>1,:movie => movie_params}
        end
        
        it 'should redirect to homepage'do
            movie=FactoryGirl.create(:movie,:title =>'title1' ,:director => 'George Lucas')
            Movie.stub(:find).and_return(movie)
            put :update, {:id=>movie.id,:movie => movie_params}
            expect(response).to redirect_to(movie_path(movie))
        end

        it 'should display the message was successfully created.'do
            movie=FactoryGirl.create(:movie,:title =>'title1' ,:director => 'George Lucas')
            post :update, {:id=>movie.id,:movie => movie_params}
            expect(flash[:notice]).to eq("#{movie_params["title"]} was successfully updated.")
        end
        
    end
    
    describe '#destroy' do
        it 'should call the model method that destroy a Movie' do
            movie=FactoryGirl.create(:movie,:title =>'title1' ,:director => 'George Lucas')
            expect_any_instance_of(Movie).to receive(:destroy)
            delete :destroy, {:id=>1}
        end
        
        it 'should redirect to homepage'do
            movie=FactoryGirl.create(:movie,:title =>'title1' ,:director => 'George Lucas')
            Movie.stub(:find).and_return(movie)
            delete :destroy, {:id=>movie.id}
            expect(response).to redirect_to(movies_path)
        end

        it 'should display the message deleted.'do
            movie=FactoryGirl.create(:movie,:title =>'title1' ,:director => 'George Lucas')
            delete :destroy, {:id=>movie.id}
            expect(flash[:notice]).to eq("Movie '#{movie.title}' deleted.")
        end
        
    end
    
    describe 'Search movies by director' do
        context 'with director' do
            it 'should call the model method that performs search by director' do
                #Movie.should_receive(:search_by_director).with('George Lucas')
                expect(Movie).to receive(:search_by_director).with('George Lucas')
                get :similar, {:director => 'George Lucas'}
            end
            
            it 'should select the similar template for rendering' do
                Movie.stub(:search_by_director)
                get :similar, {:director => 'George Lucas'}
                expect(response).to render_template('similar')
            end
            
            it 'should make the movies with the same director available to that template' do
                fake_results=[double('Movie'), double('Movie')]
                Movie.stub(:search_by_director).and_return(fake_results)
                get :similar, {:director => 'George Lucas'}
                expect(assigns(:movies)).to eq(fake_results)
            end
        end
        context 'without director' do
            it 'should redirect to homepage'do
                get :similar, {:director => ''}
                expect(response).to redirect_to(movies_path)
            end

            it 'should display the message has no director info'do
                name='Alien'
                get :similar, {:director => '', :title=>name}
                expect(flash[:notice]).to eq("'#{name}' has no director info")
            end
            
        end
    end
end

