GroupUs::Application.routes.draw do
  get   '/login', :to => 'sessions#new', as: :login
  get   '/logout' => 'sessions#destroy', as: :logout
  match "/auth", to: redirect("https://api.groupme.com/oauth/authorize?client_id=soF5LCewG9wfZaXyUlKFXFerIcmUTva75ZPpRRnnrVWUyErz"), as: :auth, via: :get
  get   '/auth/:provider/callback' => 'sessions#create'
  get   '/auth/failure', :to => 'sessions#failure'
  
  get   '/groups', :to => 'groups#index', as: :groups
  get   '/groups/show', :to => 'groups#show', as: :show_group
  get   '/groups/messages', :to => 'groups#messages', as: :messages
  root  to: 'groups#index'
end
