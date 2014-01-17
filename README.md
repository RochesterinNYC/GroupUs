<a href="http://group-us.herokuapp.com" target="_blank">GroupUs</a>
------

###Functionality
GroupUs is an application that lets [GroupMe](http://groupme.com) users view statistics, full conversations, and other information about the groups that they belong to.

####GroupMe Login:

GroupUs allows for easy login and authentication through [GroupMe oauth](https://dev.groupme.com/tutorials/oauth). No GroupUs account creation or sign in is needed as long as a user has a GroupMe account.

![GroupUs Login](http://s3.amazonaws.com/jamesrwen/app/public/projects/groupus/groupuslogin_original.png?1389939059 "GroupUs Login")

Once logged in, all your groups will be automatically presented client-side through API calls and no details regarding your groups are stored in a database other than group ID and last update time (for caching purposes). The GroupMe API does not allow developers/users to access information about a group unless the access token passed is for a user that belongs to the group. Hence, with a group ID but no access token, developers/users cannot query for information about the group.
<br/><br/>
![GroupUs Index](http://s3.amazonaws.com/jamesrwen/app/public/projects/groupus/groupusindex_original.png?1389939060 "GroupUs Index")

####Messages:

GroupUs allows a user to view all the messages of a conversation on a single page (very useful for operations like searching). Currently, the messages are presented in reverse chronological order with the latest message at the top and earliest message at the bottom. Functionality involving user selection of different ways to order the messages is pending.
<br/><br/>
![GroupUs Messages](http://s3.amazonaws.com/jamesrwen/app/public/projects/groupus/groupusmessages_original.png?1389938408 "GroupUs Messages")

####Statistics/Information:
The following are presented:
* Message with the most Favorites/Likes
* Message posted last chronologically
* Message posted first chronologically
* User that posts most frequently and how many messages he/she has sent
* Word that is posted most frequently and how many times it has been used
* Timeframe messages are posted most frequently at and how many messages sent during that timeframe
<br/><br/>
![GroupUs Stats](http://s3.amazonaws.com/jamesrwen/app/public/projects/groupus/groupusstats_original.png?1389938409 "GroupUs Stats")

![GroupUs Frequencies](http://s3.amazonaws.com/jamesrwen/app/public/projects/groupus/groupusfrequencies_original.png?1389938410 "GroupUs Frequencies")

---
###Implementation Features

####GroupMe Interface Wrapper:
Faraday is used as the HTTP client for querying the GroupMe API. I chose to write my own GroupMe wrapper (GroupMeInterface) as I wanted to parse and arrange the response data in a very specific way for the analyzer (GroupMeAnalyzer) that the GroupMe Rails gem did not support. 

The wrapper can return the following data:
- User Info
- All of a user's groups and their info
- A specific group a user belongs to and its info
- All messages and message info for a group

However, the access token for the user must be passed in as a parameter (possibly along with other parameters) for all of these wrapper methods.

####Caching:
Due to the large amount of data that some groups may possess (think thousands of messages), the collection of all the message data for a group and the subsequent analysis of this data are the primary bottlenecks. Furthermore, due to how the GroupMe API only allows a maximum of 20 messages to be returned with any singular API call, the message data collection must be done in (# of messages / 20) API calls. Without parallel workers/threads making these API calls, the time complexity of the message data collection is essentially O(n). Additionally, the data analysis is done after processing each message and its data one by one. Without parallel implementations, the time complexity of this analysis process is also O(n).

To help alleviate the resulting loading time issue, GroupUs uses a manually implemented caching system using Memcache and Dalli. With this system, the message data collection and analysis process will only need to occur once for a group before the data and analysis can be quickly accessed in subsequent attempts. Additionally, if the group has been updated, GroupUs will realize this and perform the collection, analysis, and caching for that group again.

Hence, in speed trials, for a group that contains approximately 4000 messages, it takes an average user about 4-5 seconds to access the Full Conversation or Group Stats for a group. However, after this initial load, any attempts to access the Full Conversation or Group Stats for that same group take < 0.5 second and this is primarily due to rendering (especially for Full Conversations). The cache and these enhanced load times are maintained even with logouts and logins, but expire in 3 days as per GroupMe's [API Terms of Use](https://docs.google.com/viewer?url=https%3A%2F%2Fdev.groupme.com%2FGroupMe_API_License_Agreement.pdf).

---
###Future Additions
- Word Clouds
- NLP Analysis of Word Frequencies
- Add stoplist to filter pronouns and etc.