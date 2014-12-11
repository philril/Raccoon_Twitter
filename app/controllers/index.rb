get '/' do
  erb :login, layout :false
  #erb :index
end

get '/profile/:user_name' do
  @user = User.find(params[:user_name])
  @tweets = Tweet.all.where(user_id: @user.id)
  erb :profile
end

# for header new tweets in profile & timeline
post '/profile/:user_name' do
  @tweet = Tweet.create(user_name: params[:user_name], content: params[:content])
  redirect'/profile/:user_name'
end

# for header new tweets in profile & timeline
post '/timeline/:user_name' do
  @tweet = Tweet.create(user_name: params[:user_name], content: params[:content])
  redirect'/timeline/:user_name'
end

#TWEET IS NOT A SEPARATE PAGE. BUILD DELETE INTO PROFILE AND TIMELINE
get '/tweet/:user_name' do
  @tweet = Tweet.find_by user_name: params[:user_name]
  #delete option on this page
  #link back to timeline & profile on this page
  erb :tweet
end

delete '/tweet/:user_name' do
  Tweet.destroy(params[:user_name])
  redirect '/profile/:user_name'
end

#FOLLOWERS IS NOT A SEPARATE PAGE. IT'S A SIDEBAR ON PROFILE
get '/follow/:user_name' do

  #both your followers & who you follow
  @user = User.find(params[:user_name])
  @followers_ids = Follow.where(user: @user.id)
  @followers_objects = @followers.followed_by.user
  #returns list of objects for specific user.. Erb will get followers ids
  @following_ids = Follow.where(followed_by: @user.id)
  @following_objects = @following.user.user
end

get '/timeline/:user_name' do
  @user = User.find(params[:user_name])
  @follow_objects = Follow.where(user: @user.id)
  @user_ids = @follow_objects.followed_by
  # @tweets = @user_objects.user_id.tweet

  @tweet_objects = []
  @user_ids.each { |user_id| @tweet_objects << Tweet.where(:user_id = user_id)

  erb :timeline
end



# ============SESSIONS
get '/secret' do
  if !logged_in?
    redirect '/'
  else
    redirect '/timeline/:user_name'
  end
end

post '/signup' do
  user = User.new(params)
  if user.save
    session[:user_id]=user.id
  else
    flash[:error]=user.errors.full_messages
  end
  redirect '/timeline/:user_name'
end

post '/login' do
  @user = User.find_by_email(params[:email])
  if @user && @user.authenticate(params[:password])
    session[:user_id] = @user.id
    redirect '/secret'
  else
    flash[:errors] = "Try again"
    erb :index
  end

end

get '/logout' do
  session[:user_id]=nil
  redirect '/'
end

