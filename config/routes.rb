Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :cages, except: %i[new edit destroy]
      resources :dinosaurs, except: %i[new edit destroy]
    end
  end

  match '*unmatched_route', to: 'application#routing_error', via: :all
end
