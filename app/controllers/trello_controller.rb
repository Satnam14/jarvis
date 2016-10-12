class TrelloController < ApplicationController

  def webhook_ready
    render json: 'OK', status: 200
  end

  def receive
    post_data = JSON.parse(request.raw_post)
    action = post_data['action']

    if action['type'] == "createCard"
      create_card(action)
    elsif action['type'] == "updateCard"
      if action['data']['card']['closed']
        close_card(action)
      elsif action['data']['listAfter']
        move_card_list(action)
      elsif action['data']['old']['pos']
        move_card_position(action)
      else
        rename_card(action)
      end
    elsif action['type'] == "addLabelToCard"
      add_label_to_card(action)
    elsif action['type'] == "removeLabelFromCard"
      remove_label_from_card(action)
    elsif action['type'] == "moveCardToBoard"
      move_card_board(action)
    else
    end
  end

  def create_card(action)
    link = 'https://trello.com/c/' + action['data']['card']['shortLink']
    list = List.find_by_title(action['data']['list']['name'])
    @card = Card.new
    @card.title = action['data']['card']['name']
    @card.list = list
    if @card.save
      render json: @card
    else
      render json: @card.errors.full_messages
    end
  end

  def close_card(action)
    @card = Card.find_by_title(action['data']['card']['name'])
    if @card.update(archived: true)
      render json: @card
    else
      render json: @card.errors.full_messages
    end
  end

  def move_card_list(action)
    @new_list = List.find_by_title(action['data']['listAfter']['name'])
    @card = Card.find_by_title(action['data']['card']['name'])
    @card.list = @new_list
    if @card.save
      render json: @card
    else
      render json: @card.errors.full_messages
    end
  end

  def move_card_position(action)
    trello_list = Trello.get_list_cards(action['data']['list']['id'])
    list_name = action['data']['list']['name']
    jarvis_list = List.find_by_title(list_name).cards.order(:position)
    jarvis_list.each_with_index do |card, index|
      next if trello_list[index]['name'] == card['title']
      actual_position = trello_list.find_index do |trello_card|
        trello_card['name'] == card['title']
      end
      card.position = actual_position + 1
      card.save
    end
    render json: { result: 'OK' }
  end

  def move_card_board(action)
    @new_list = List.find_by_title(action['data']['list']['name'])
    @card = Card.find_by_title(action['data']['card']['name'])
    @card.list = @new_list
    if @card.save
      render json: @card
    else
      render json: @card.errors.full_messages
    end
  end

  def rename_card(action)
    @card = Card.find_by_title(action['data']['old']['name'])
    if @card.update(title: action['data']['card']['name'])
      render json: @card
    else
      render json: @card.errors.full_messages
    end
  end

  def add_label_to_card(action)
    # var cardName = action.data.card.name;
    # var rowNumber = getRowNumber(cardName);
    # var colLetter = getColumnLetter();
    # var cell = Measure.getRange('E' + rowNumber);
    # cell.setValue(action.data.label.name);
  end

  def remove_label_from_card(action)
    # var cardName = action.data.card.name;
    # var rowNumber = getRowNumber(cardName);
    # var cell = Measure.getRange('E' + rowNumber);
    # cell.setValue('');
  end

end
