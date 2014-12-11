get '/' do
  erb :login
  #erb :index
end

get '/profile/:user_name' do
  @user = User.find(params[:user_name])
  erb :profile
end

# for header new tweets in profile & timeline
post '/profile/:user_name' do
  @user = User.find(params[:user_name])
  @tweet = Tweet.create(user_id: @user.id, content: params[:content])
  redirect'/profile/:user_name'
end

# for header new tweets in profile & timeline
post '/timeline/:user_name' do
  @user = User.find(params[:user_name])
  @tweet = Tweet.create(user_id: @user.id, content: params[:content])
  redirect'/timeline/:user_name'
end

# get '/tweet/:user_name' do
#   @tweet = Tweet.find_by user_name: params[:user_name]
#   #delete option on this page
#   #link back to timeline & profile on this page
#   erb :tweet
# end

delete '/profile/:user_name' do
  Tweet.destroy(params[:id])
  redirect '/profile/:user_name'
end

get '/follow/:user_name' do
  #both your followers & who you follow
  @user = User.find(params[:user_name])
  @followers = Following.where(user: @user.id)
  @followers = @followers.followed_by.user
  #returns list of objects for specific user.. Erb will get followers ids
  @following = Following.where(followed_by: @user.id)
  @following = @following.user.user
  erb :follow
end

get '/timeline/:user_name' do
  @followers = Following.where(user: @user.id)
  @user_ids = @followers.followed_by
  # @tweets = @user_objects.user_id.tweet

  @tweet_objects = []
  @user_ids.each {|user_id| @tweet_objects << Tweet.where(user: user_id)}
  @tweet_objects = @tweet_objects.sort_by{|tweet_object| tweet_object.created_at}.reverse
  erb :timeline
end



# ============SESSIONS
get '/secret' do
  if !logged_in?
    redirect '/timeline/:user_name'
  end
  erb :secret
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

