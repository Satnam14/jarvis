class Trello < ApplicationRecord

  KEY = 'b771a902c965b9aadfbb873f48c0682b'
  TOKEN = '382ee3ca6c957de15387f2e0191029386e4380b2b954e069e635106a8a903780'

  def self.call(endpoint, params)
    base_url = 'https://api.trello.com/1/' + endpoint
    base_url += '?' + params + '&'
    base_url += 'key=' + KEY + '&'
    base_url += 'token=' + TOKEN
    return base_url
  end

  def self.get_list_cards(trello_list_id)
  	endpoint = "lists/#{trello_list_id}"
  	params = "fields=name&cards=open&card_fields=name"
  	request_body = call(endpoint, params)
  	response = HTTParty.get(request_body)
  	return response['cards']
  end
end
