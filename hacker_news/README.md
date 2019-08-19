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

# Offline Storage

## SQLite API Implementation

In this section, we'll work with a lot of underlying file system and SQLite, so we need to import these:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
```

Next, we need to think what need to build in **DbProvider**. And I come up with 3 method:
- init(): Initialize state for app when startup
- fetchItem(): Get items
- addItem(): Add new items to DB

## Init() Method

As we all think that **init()** has the similiar function as **Constructor** like set connection to DB, preparet data,...

But those work need *asynchronous* and **Constructor** can't be *async* function. So we need **init()** works for **Constructor**

Okay I want to analysis some code I wrote in this function:
```dart
Directory documentsDirectory = await getApplicationDocumentsDirectory();
final path = join(documentsDirectory.path, 'items.db');
```

- First, we try to get directory path of this application in the mobile device. Method call from *path_provider* will return **Directory** type (*dart:io*).
- In that directory, we will get DB file path with **join** function.

With DB in hand, we must consider 2 scenarios:
- This is the very first time app is fired up.
    - Then we must create or initial data in this DB
- App is already opened at least once.

If this is the first time we open DB (launch app), we can use parameter **onCreate** in open DB to create a new table in this SQLite DB.
- NOTE: **onCreate** only works when there is no DB exists before. When it finishes creating new table, it'll return a connection to that DB

## Fetching New Item

Again, from previous connection we query data from that DB, this is required **async** method.

In **Database** object has **query()** which has similiar function as Relational Calculus. Method takes:
- Required: Name of table is queried
- Named parameters: Condition or how to retrieve data.
    - *columns*: List of column is retrieved, set *null* to retrieve all columns.
    - *whereArgs*: Instead of hard-coded argument for *where*, we set in *where* with `?`. The reason is to avoid SQL injection attack.
- The return value from **query()** is a table as *List<Map<String, dynamic>>*

From retrieved Item, we found another problem: 2 Provider don't have the same data type.
- News_Api_Provider's ItemModel `has BOOLEAN type`.
- News_Db_Provider's ItemModel `uses INTEGER for BOOLEAN`.

We must make a way for this problem. We create **Named Constructor** again which is similiar to **fromJson()** but:
- It converts INTEGER to BOOLEAN for *dead* and *deleted*.
- And *kids* is defined as BLOB, we just convert into List<int>.
    - BLOB: is Binary Large Object, it's stored as binary
    - When retrieve from DB, *kids* is a JSON of Array type. So we *jsonDecode()* the result to get *List<int>*.

## Add new Item into DB

Add a tuple to SQLite Database is quiet straight-forward, all you need to do is included in **Database** object.
We will work with *insert()* method:
- *@Required* Table name which you insert a tuple in.
- *@Required* A tuple is inserted as **Map<String, dynamic>**. So therefore, we should add a method in **ItemModel** for convertion.

# Repository class

At this point, we may realize that we are following **Adapter Design Pattern**.

And as you may guess, we need 2 method:
- *fetchTopIds()*: only fetch top ids. Implement from *NewsApiProvider.fetchTopIds()*
- *fetchItem()*: Try to fetch from DB if not exists then fetch from API.