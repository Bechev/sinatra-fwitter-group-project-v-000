class TweetsController < ApplicationController

  get "/tweets" do
    if logged_in?
      @user = User.find_by(username: session[:username])
      erb :"/tweets/index"
    else
      redirect "/login"
    end
  end


  get '/tweets/new' do
    if logged_in?
      @user = User.find_by(params[:user])
      erb :"/tweets/new"
    else
      redirect :'/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :"/tweets/show"
    else
      redirect :'/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      if @tweet && @tweet.user.username == session[:username]
        erb :"/tweets/edit"
      else
        redirect '/tweets'
      end
    else
      redirect :'/login'
    end
  end

  post '/tweets' do
    if params[:content]==""
      redirect "/tweets/new"
    else
      @tweet = Tweet.create(content: params[:content])
      @tweet.user = User.find_by(username: session[:username])  
      @tweet.save
      redirect "tweets/#{@tweet.id}"
    end
  end

  patch '/tweets/:id' do
    if logged_in?
      if params[:content] == ""
        redirect to "/tweets/#{params[:id]}/edit"
      else
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet && @tweet.user.username == session[:username]
          if @tweet.update(content: params[:content])
            redirect to "/tweets/#{@tweet.id}"
          else
            redirect to "/tweets/#{@tweet.id}/edit"
          end
        else
          redirect to '/tweets'
        end
      end
    else
      redirect to '/login'
    end
  end

  delete '/tweets/:id/delete' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet && @tweet.user.username == session[:username]
        @tweet.delete
      end
      redirect to '/tweets'
    else
      redirect to '/login'
    end
  end

end
