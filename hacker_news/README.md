# Hacker News Mobile (Clone)

This project is a clone mobile version of Hacker News using API in partnership with Firebase: https://github.com/HackerNews/API

## About design

The homepage has the similiar layout like in Hacker News webpage, displays each news. When click-in story will direct to post and comments.

# Data Fetching with API

## Ditch in API

From Hacker News homepage, we view a list of top stories. So to copy exactly like that, we may be follow these steps:
- HTTP GET -> **/v0/topstories**: Retrieve a list of story id.
- From list we again HTTP GET -> **/v0/item/{id}**: Retrieve item model for story *id*.

This seems very inefficiency. But that's not the end, there is worse part with fetching comments in each post.
- In story model, there is a list of comment id. And to show each comment, we must fetch by all id.
- But that are just the top-level comments, in each comments there are replies. We also need to fetch those relies (Tremendous works). 

Ok that's how learning project may do, but what if we build a commercial app (real-world project):
- First, we must set up a server which hosts our API.
- Our API must be:
    - Make requests all the time, every single 30s for example from Hack News API
    - Simplify or compose the large number of API. For example: make homepage, we need a API which does **/topstories** and **/item/{id}**.
- After finish our API, we just use that in our application.

## Improve API Fetching Performance

We will follow model below:
```
Our app decides |                |   |--> NewsDbProvider  -> Sqlite DB on device
to fetch        | --> Repository | --|  
an item         |       class    |   |--> NewsApiProvider -> Hacker News API
```

where: `Repository class` is just a plain Dart class.

So there are some scenario:
- First time load up, fetch all the data from API and show those.
    - Store those item into Sqlite DB.
- After that if we start app again.
    - Fetch a list of top stories
    - Check if *{id}* in **NewsDbProvider** before, if yes then show.
    - If not, go to **NewsApiProvider** and get story then put to Sqlite for later use.

## Start with Item Model & API Implementation

Item model for each post and comment has a lot of paramters, but I found a sample model so I use https://javiercbk.github.io/json_to_dart/ for time-efficient.

Next we create functions to retrieve items Hacker News API, here comes **NewsApiProvider** class:
- We need a function to get top items.
- And a function to get all top-level information of *id* post (type, time, title, etc...).