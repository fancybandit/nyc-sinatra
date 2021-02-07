
class LandmarksController < ApplicationController

  get '/landmarks' do
    @landmarks = Landmark.all
    erb :'landmarks/index'
  end

  get '/landmarks/new' do
    @figures = Figure.all
    @titles = Title.all
    erb :'landmarks/new'
  end

  get '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])
    erb :'landmarks/show'
  end

  get '/landmarks/:id/edit' do
    @landmark = Landmark.find(params[:id])
    @titles = Title.all
    @figures = Figure.all
    erb :'landmarks/edit'
  end

  post '/landmarks' do
    @landmark = Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed])

    if !params[:figure][:name].empty?
      @landmark.figures << Figure.create(params[:figure])
    end
    if params[:landmark][:figure_ids]
      params[:landmark][:figure_ids].each do |id|
        @landmark.figures << Figure.find(id)
      end
    end

    @landmark.save

    redirect "/landmarks/#{@landmark.id}"
  end

  patch '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])

    if !(params[:landmark][:name] == @landmark.name)
      @landmark.update(name: params[:landmark][:name])
    end
    if !(params[:landmark][:year_completed] == @landmark.year_completed)
      @landmark.update(year_completed: params[:landmark][:year_completed])
    end

    if params[:landmark][:figure_ids]
      params[:landmark][:figure_ids].each do |id|
        @landmark.figures.each do |figure|
          if figure.id != id
            @landmark.figures << Figure.find(id)
          end
        end
      end
    else
      @landmark.figures.clear
    end
    if !params[:figure][:name].empty?
      @landmark.figures << Figure.create(params[:figure])
    end
    @landmark.save

    redirect "/landmarks/#{@landmark.id}"
  end
end

