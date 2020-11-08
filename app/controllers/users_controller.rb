class UsersController < ApplicationController

    get '/signup' do
        if is_logged_in?(session)
            redirect '/tweets'
        end
        erb :'/users/signup' 
    end

    get '/login' do
        if is_logged_in?(session)
            redirect '/tweets'
        else
            erb :'/users/login'
        end
    end

    get '/logout' do
        # binding.pry
        session.clear
        redirect '/login'
    end

    get '/users/:slug' do
        if is_logged_in?(session)
            @user = User.find(session[:user_id])
            # binding.pry
            erb :'/users/show'
        else
            redirect '/login'
        end
    end

    post '/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password]) 
            session[:user_id] = @user.id
            redirect "/tweets"
        else
            redirect "/login"
        end
    end

    post '/signup' do
        @user = User.new(email: params[:email], username: params[:username], password: params[:password])
        if @user.save && !@user.username.empty? && !@user.email.empty?
            session[:user_id] = @user.id
            redirect "/tweets"
        else
            redirect "/signup"
        end
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
