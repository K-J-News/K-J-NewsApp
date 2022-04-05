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
- **Mobile:** 
- **Story:** 
- **Market:** 
- **Habit:** 
- **Scope:** 

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* 

**Optional Nice-to-have Stories**

* 

### 2. Screen Archetypes

* 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* 

**Flow Navigation** (Screen to Screen)
* 

## Wireframes
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
