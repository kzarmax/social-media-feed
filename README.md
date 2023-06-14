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
- Demo Video

https://github.com/kjeih/social-media-feed/assets/56865797/3bc0a43c-462a-487d-a45a-01eaf8686474

- Pages
<img width="135" alt="Screenshot_20230614_231920" src="https://github.com/kjeih/social-media-feed/assets/56865797/1fb27e0d-b975-45f1-a49c-f17e165c4421">
<img width="135" alt="Screenshot_20230614_232005" src="https://github.com/kjeih/social-media-feed/assets/56865797/97501e74-666c-4ec4-810c-f22eee85179f">
<img width="135" alt="Screenshot_20230614_232023" src="https://github.com/kjeih/social-media-feed/assets/56865797/7d864a83-8525-4ca9-8653-28c4f5ce9a71">
<img width="135" alt="Screenshot_20230614_232035" src="https://github.com/kjeih/social-media-feed/assets/56865797/c22d7934-7870-45e8-932b-509955c5387a">
<img width="135" alt="Screenshot_20230614_233231" src="https://github.com/kjeih/social-media-feed/assets/56865797/8e262f50-03e4-432b-be2c-f4909f5d9ba7">
