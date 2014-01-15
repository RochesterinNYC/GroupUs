module GroupMeAnalyzer

  #Most liked message
  #First ever message
  #Last ever message
  #Most frequent poster
  #Most used word
  #Word frequency breakdown
  #Time of Day posting --> Graph!
  #Number of attachments
  #Number of messages
  #Average sentence length
  #Total number of words posted

  def self.analyze_group(messages)
    most_liked_message = nil
    first_message = messages.first
    last_message = messages.last
    user_freq = Hash.new
    word_freq = Hash.new
    time_freq = Hash.new
    num_attachments = 0
    num_words = 0
    messages.each do |message|
      #Will skip all the analysis code if message is a system message
      next if message['system']

      num_attachments += message['attachments'].count

      if !most_liked_message.blank? && message['favorited_by'].count > most_liked_message['favorited_by'].count
        most_liked_message = message
      elsif most_liked_message.blank?
        most_liked_message = message
      end
      
      if user_freq[message['name']].nil?
        user_freq[message['name']] = 1
      else
        user_freq[message['name']] += 1
      end

      #Time.hour rounds down so message that returns 17 would be 17-18 (5-6 PM)
      if time_freq[Time.at(message['created_at']).hour].nil?
        time_freq[Time.at(message['created_at']).hour] = 1
      else
        time_freq[Time.at(message['created_at']).hour] += 1
      end

      #Will skip all the text analysis code if message's text is nil
      next if message['text'].blank?
      text = message['text'].downcase.gsub(/[^a-z\s]/, '')
      text.split.each do |word|
        num_words += 1
        if word_freq[word].nil?
          word_freq[word] = 1
        else
          word_freq[word] += 1
        end
      end

    end

    average_words_message = num_words == 0 ? 0 : num_words / messages.count 
    user_freq = Hash[user_freq.sort_by {|_key, value| -value}]
    word_freq = Hash[word_freq.sort_by {|_key, value| -value}]
    time_freq = Hash[time_freq.sort_by {|_key, value| -value}]

    { most_liked: most_liked_message, first: first_message, last: last_message, num_messages: messages.count, user_frequency: user_freq, word_frequency: word_freq, time_frequency: time_freq, num_attachments: num_attachments, num_words: num_words, average_words: average_words_message}
  end

end
