# Cleanse

# Short description of your app
Cleanse is an application built to cleanse your social media. It will remove harmful and offensive tweets and allow you to unfollow and remove any content that is potentially damaging for viewers. This app will allow your feed to look more professional and interview ready so that your feed will not put off any potential recruiters.  

# Wireframes
https://www.fluidui.com/editor/live/preview/p_6Mng826ONsacWTC5pxVVW1TneXpX2GEo.1457654594268

# User Stories
What we absolutely want to complete:
* [ ] Use the Twitter API to find followers or retweeter of user
  * [ ] show list of each followers' tweets and content
    * [ ] have an option to unfollow and block
  * [ ] Create blacklist of tweets
    
Optional Features: 
* [ ] Have an option to confirm whether or not a tweet or retweet should be deleted 
* [ ] Related Suggestions
* [ ] Extending to Facebook
* [ ] Review Blocks (for unblocking)

#Collection Structure
* Table: Cleansers
  * Columns Needed:
    * Twitter Id (Unique identifier provided by Twitter API)
    * (Optional ?) Twitter handel

#API Endpoints
* <a href="https://dev.twitter.com/rest/reference/get/friends/list">GET friends/list (aka get people following current user list) </a>
* <a href="https://dev.twitter.com/rest/reference/post/blocks/create">POST blocks/create</a>
* <a href="https://dev.twitter.com/rest/reference/get/followers/list">GET followers/list</a>
* <a href="https://dev.twitter.com/rest/reference/get/statuses/user_timeline">GET statuses/user_timeline</a>
* Optional API endpoints that may be used:
  * <a href="https://dev.twitter.com/rest/reference/get/blocks/ids">GET blocks/ids (list of active blocks of user)</a>

#Model Classes
* ParseClient
  * class to deal with all database actions in the Parse Server and connecting to the server
* TwitterClient
  * class to deal with all Twitter API requests
* User class
  * class for Twitter User with all their corresponding timeline, id, handle, etc information

# Considerations
### Product Pitch
* Prepping for a job interview? Afraid your social media might show your bad side to your future employer. It's time to cleanse your social media with CLEANSE, an iOS app to make your cleansing experience as easy as possible. 
### Audience
* People looking for jobs, internships
* Students (particularly those applying to univeristy, grad school, medical school, etc)
### Core Functions
* User of app will log in and interact with card swiping of Twitter profiles
* Unfollow people deemed "not clean" by the user of the app
### Projected Final Demo
* User will log into app
* Swipe through list of friends to unfollow
* Swipe through list of followers to block
* User will logout
### Mobile Features Leveraged
* Twitter API, gesture recognizers 
### Technical Concerns
* Maintaining a stack so there is an option for undoing
* Having a great UX for the users