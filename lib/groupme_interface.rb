module GroupMeInterface

  @@conn = Faraday.new(:url => 'https://api.groupme.com/v3/') do |faraday|
    faraday.request  :url_encoded
    faraday.response :logger
    faraday.adapter  Faraday.default_adapter
  end

  def self.get_user_info access_token
    response = @@conn.get 'users/me', token: access_token
    user_info = JSON.parse response.body
    user_info['response']
  end

  #Returns array of all json groups for member
  #Considers the GroupMe API pagination
  def self.get_all_groups access_token
    all_found = false
    page_to_get = 1
    groups = Array.new
    while !all_found do
      response = @@conn.get 'groups', token: access_token, page: page_to_get, per_page: 25
      body = JSON.parse response.body
      groups.concat body['response']
      response.headers['link'].blank? ? all_found = true : page_to_get += 1
    end
    groups
  end

  def self.get_all_messages access_token, group_id, num_messages
    all_found = false
    last_message_id = nil
    messages = Array.new
    until messages.count == num_messages do
      messages.concat get_messages(access_token, group_id, last_message_id, num_messages, messages.count)
      last_message_id = messages.last['id']
    end
    messages
  end

  def self.get_groups access_token
    response = @@conn.get 'groups', token: access_token
    groups = JSON.parse response.body
    groups['response']
  end

  def self.get_messages access_token, group_id, last_message_id, num_messages, count
    response = @@conn.get "groups/#{group_id}/messages", token: access_token, before_id: last_message_id
    messages = JSON.parse response.body
    messages['response']['messages']
  end

end