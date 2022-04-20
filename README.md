CST 495 Final Project - 
===

# K&J News

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)

## Overview
### Description

### App Evaluation
- **Category:** News 
- **Mobile:** This app would primarily be developed for mobile, and it can easily be used on a mobile web platform such as Safari.
- **Story:** Users can have a curated news feed of trending articles and change accordingly based on their preferences
- **Market:** Any individual that wants to be in the know about current trending news events 
- **Habit:** This app could be used as often or unoften as the user wanted depending on how much they would like to browse news 
- **Scope:** First we would start with account registration and getting the general news feed.  From there, we will add the catagory filtering and searching functionality. Lastly, we would impolement the selection of language and country.

## Product Spec
### 1. User Stories (Required and Optional)


**Required Must-have Stories**

* [x] User can register and login
* [] User can filter news catagories from pre-offered selection
* [x] User can search for a news article with custom search terms
* [] User can save/favorite an article
* [x] User can browse news articles and tap to view them in SafariView
* [x] User can change language and country preferences

**Optional Nice-to-have Stories**

* User can select a language and country for translated news and different sources from different countries

### 2. Screen Archetypes

* Login 
* Register - User signs up or logs into their account: User is prompted to login after force closing the app
* Profile Screen - User can select language/country preferences
* Main Feed - Allows the user to have a trending selection of news offerings
* Saved - Users can view saved articles
* Filtered Feed - User can selected predefined topics to filter news offerings
* Search - User can do a custom search for news articles

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Login
* Profile
* Main Feed
* Search/Filtered Feed
* Saved

**Flow Navigation** (Screen to Screen)
*  Register -> Login
*  Login -> Home Feed
*  Home Feed -> Saved
*  Home Feed -> Settings


## Wireframes
![K   J News Feed_Search_Search Results (1)](https://user-images.githubusercontent.com/8891981/161655157-44d991c2-26ce-4d51-a128-7e9c3f83de90.png)
![K   J News User_Favorites_Misc](https://user-images.githubusercontent.com/8891981/161655180-0b6f2796-7594-4fdd-a1ec-c9a9027c0e12.png)
## Schema 
### Models
#### Post
![K   J News User_Favorites_Misc (1)](https://user-images.githubusercontent.com/8891981/161654754-b0cc14ba-9c2d-47fd-a8f4-40e871a01ad8.png)

### Networking
#### List of Parse database network requests by screen
   - Home Feed Screen
      - (Read/GET) Query prefered language of current user
         ```swift
         let query = PFQuery(className:"User")
         query.whereKey("username", equalTo: currentUser.username)
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if  {
               print("Successfully retrieved \(posts.count) posts.")
                // TODO: Use as param for API request
            }
         }
         ```
      - (Read/GET) Query prefered country of current user
   - Profile Screen
      - (Read/GET) Query logged in user object
      - (Update/PUT) Update user language
      - (Update/PUT) Update user country

### Credits
<a href="https://www.flaticon.com/free-icons/news" title="news icons">News icons created by dickpra - Flaticon</a>

###**Gif of Update**


