# Social Media Feed

This app displays a list of posts fetched from an API. The feed should provide the following functionality.

 - Post Retrieval: Fetch a list of posts from an API endpoint. Each post should have a title, description, image URL, and author information.
 - Infinite Scroll: Implement an infinite scroll feature, where new posts are loaded as the user scrolls down the feed.
 - Post Interaction: Allow users to like and comment on posts. Display the number of likes and comments for each post, and provide the ability to add new comments.
 - Post Sorting: Implement the ability to sort posts based on different criteria, such as date, popularity, or author.
 
## Development

### Environment
- IDE : Android Studio
- Flutter SDK : 3.10.4
- Android Build SDK Version : 33, Min SDK Version: 24
- IOS Version : 14 

### Implements
- Build flutter app with common social posting app design style.
- Using "newsapi" public endpoint as posting url (https://newsapi.org/).
- Used the "Provider" package for state management.
- Used the SQLite database as internal app database.
- Used the "http" package for calling api endpoint.
- Constructed project with MVVM structure
    - models
    - pages
    - utils
    - theme

## Getting Started

### Install

1. Clone git repository

```
$ git clone https://github.com/kjeih/social-media-feed
```
2. Clean and install flutter pub packages

```
$ cd social-media-feed
$ flutter clean
$ flutter pub get
```

3. Run app

```
$ flutter run
```

## Result
Demo video is in [here](./media/demo_video.mp4)

Pages are in [here](./media)
