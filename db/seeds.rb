require 'json'

files = [
  './db/trello_data/pixlee.json',
  './db/trello_data/destiny.json',
  './db/trello_data/growth.json',
  './db/trello_data/physique.json'
]

files.each do |file|
  reader = File.read(file)
  data = JSON.parse(reader)
  board = Board.create(title: data['name'])

  data['lists'].each do |list|
    next if list['closed']
    list_entry = List.new
    list_entry.board = board
    list_entry.title = list['name']
    list_entry.save

    cards = Trello.get_list_cards(list['id'])
    cards.each_with_index do |card, index|
      card_entry = Card.new
      card_entry.title = card['name']
      card_entry.list = list_entry
      card_entry.position = index + 1
      card_entry.save
    end
  end
end
