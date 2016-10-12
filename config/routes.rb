Rails.application.routes.draw do
  # Trello Listener
  # post 'path'
  get '/getCardsOrderedByPriority', to: 'main#get_cards_by_priority'
  get '/getListsByPriority', to: 'main#get_lists_priority'
end
