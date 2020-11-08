class TweetsController < ApplicationController

    get '/tweets' do 
        if !is_logged_in?(session)
            redirect '/login'
        end
        erb :'/tweets/index'
    end

    get '/tweets/new' do
        if !is_logged_in?(session)
            redirect '/login'
        end
        erb :'/tweets/new'
    end

    get '/tweets/:id' do
        if is_logged_in?(session)
            @tweet = Tweet.find(params[:id])
            erb :'/tweets/show'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        if is_logged_in?(session)
            @tweet = Tweet.find(params[:id])
            erb :'/tweets/edit'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        if !params[:content].empty?
            @user = User.find(session[:user_id])
            @tweet = Tweet.create(content: params[:content], user_id: session[:user_id]) 
            redirect "/users/#{@user.slug}"
        else
            redirect "/tweets/new"
        end
    end

    patch '/tweets/:id' do
        
        if !params[:content].empty?
            @tweet = Tweet.find(params[:id])
            @tweet.update(content: params[:content]) 
            redirect "/tweets/#{@tweet.id}"
        else
            redirect "/tweets/#{@tweet.id}/edit"
        end
    
    end

    delete '/tweets/:id' do
        if is_logged_in?(session)
        @tweet = Tweet.find(params[:id])
        end
        if @tweet.user_id == session[:user_id]
            @tweet.delete
        end
        redirect '/tweets'
    end

    helpers do
        def is_logged_in?(session)
          !!session[:user_id]
        end
    
        def current_user
          User.find(session[:user_id])
        end
    end

end
