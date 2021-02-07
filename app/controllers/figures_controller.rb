class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :'figures/index'
  end

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'figures/new'
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'figures/edit'
  end

  post '/figures' do
    @figure = Figure.create(name: params[:figure][:name])
    if !params[:title][:name].empty?
      @figure.titles << Title.create(params[:title])
    end
    if params[:figure][:title_ids]
      params[:figure][:title_ids].each do |id|
        @figure.titles << Title.find(id)
      end
    end

    if !params[:landmark][:name].empty?
      @figure.landmarks << Landmark.create(params[:landmark])
    end
    if params[:figure][:landmark_ids]
      params[:figure][:landmark_ids].each do |id|
        @figure.landmarks << Landmark.find(id)
      end
    end

    @figure.save

    erb :'figures/show'
  end

  patch '/figures/:id' do
    @figure = Figure.find(params[:id])

    if !(params[:figure][:name] == @figure.name)
      @figure.update(name: params[:figure][:name])
    end

    if params[:figure][:title_ids]
      params[:figure][:title_ids].each do |id|
        @figure.titles.each do |title|
          if title.id != id
            @figure.titles << Title.find(id)
          end
        end
      end
    else
      @figure.titles.clear
    end
    if !params[:title][:name].empty?
      @figure.titles << Title.create(params[:title])
    end

    if params[:figure][:landmark_ids]
      params[:figure][:landmark_ids].each do |id|
        @figure.landmarks.each do |landmark|
          if landmark.id != id
            @figure.landmarks << Landmark.find(id)
          end
        end
      end
    else
      @figure.landmarks.clear
    end
    if !params[:landmark][:name].empty?
      @figure.landmarks << Landmark.create(params[:landmark])
    end
    @figure.save

    redirect "/figures/#{@figure.id}"
  end

end
