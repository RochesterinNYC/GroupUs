module GroupMeInterface

  @@conn = Faraday.new(:url => 'https://api.groupme.com/v3/') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end

  #Returns array of json groups
  def self.get_groups access_token
    response = @@conn.get 'groups', token: access_token
    groups = JSON.parse response.body
    return groups['response']
  end

  def self.get_user_info access_token
    response = @@conn.get 'users/me', token: access_token
    user_info = JSON.parse response.body
    return user_info['response']
  end

  def self.get_messages(access_token, group_id, options={})
    if options[:last_id].blank?
      response = @@conn.get "groups/#{group_id}/messages", token: access_token
    else
      response = @@conn.get "groups/#{group_id}/messages", token: access_token, before_id: options[:last_id]
    end
    messages = JSON.parse response.body
    return messages['response']['messages']
  end

end