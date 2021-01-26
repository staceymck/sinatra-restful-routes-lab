class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/recipes' do
    @recipes = Recipe.all
    erb :index
  end
  
  get '/recipes/new' do
    erb :new
  end

  post '/recipes' do
    recipe = Recipe.new(name: params[:name], ingredients: params[:ingredients], cook_time: params[:cook_time])
    recipe.save

    if recipe.save
      redirect "/recipes/#{recipe.id}"
    else
      redirect '/recipes/new'
    end
  end

  get '/recipes/:id' do
    @recipe = Recipe.find_by_id(params[:id]) #not find method here because if find doesn't return a match, program throws an error
    erb :show
  end

  get '/recipes/:id/edit' do
    @recipe = Recipe.find_by_id(params[:id]) #find_by returns nil if no match is found, allowing you to add 'else' conditional    erb :edit
    erb :edit
  end

  patch '/recipes/:id' do
    @recipe = Recipe.find_by_id(params[:id])
    @recipe.name = params[:name]
    @recipe.ingredients = params[:ingredients]
    @recipe.cook_time = params[:cook_time]
    @recipe.save

    if @recipe.save
      redirect "/recipes/#{@recipe.id}"
    else
      redirect "/recipes/:id/edit"
    end
  end

  delete '/recipes/:id' do
    recipe = Recipe.find_by_id(params[:id])
    recipe.destroy

    redirect '/recipes'
  end
end
