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
https://github.com/kjeih/social-media-feed/assets/56865797/b3ec7423-e51d-486a-bcce-c2027afd56e2

- Pages
<img width="135" alt="Screenshot_20230614_231920" src="https://github.com/kjeih/social-media-feed/assets/56865797/365aa500-6cf3-4058-a697-ff669aa443d9">
<img width="135" alt="Screenshot_20230614_232005" src="https://github.com/kjeih/social-media-feed/assets/56865797/da2d213c-724c-45b4-983a-2309a9805138">
<img width="135" alt="Screenshot_20230614_232023" src="https://github.com/kjeih/social-media-feed/assets/56865797/d2ac2d7e-a8ef-4288-9ad1-84ce1433d2e2">
<img width="135" alt="Screenshot_20230614_232035" src="https://github.com/kjeih/social-media-feed/assets/56865797/05328e20-919c-4530-bdc3-cdfa0ee75858">
<img width="135" alt="Screenshot_20230614_233231" src="https://github.com/kjeih/social-media-feed/assets/56865797/3f67aa0a-d415-4297-84f9-4c97af554ae7">
