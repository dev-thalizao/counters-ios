# Cornershop iOS Development Test

### Before you begin

You will need to create a private GitHub repository using the information that we provided in this README. When you finish your test, share the project with [@Cornershop-HR](https://github.com/Cornershop-HR) and let your recruiter know.

Should you have any questions (UI design, deadlines, etc), please reach out to the recruiter.

Please read this whole README file. It's very important that you follow the instructions properly. That being said, we like surprises.

## The Test
We just provided you a base project, an iOS app for counting things. The project contains some components that are there to help you build quickly 🚀 However, you'll need to meet expectations for quality and functionality.

Your final result must meet at least the following criteria:

* **States are crucial**. You must handle each state transition properly.
* Add a named counter to a list of counters.
* Increment any of the counters.
* Decrement any of the counters.
* Delete a counter.
* Show a sum of all the counter values.
* Search counters.
* Enable sharing counters.
* Handle batch deletion.
* Unreliable networks are a thing. The app should handle this gracefully. State management and error handling are **important** across the entire app. 
* Persist data *locally* and back to the server.
   * The app should persist the counter list if the network is not available (i.e Airplane Mode).
* It must **not** feel like a learning exercise. Think you’re building this for the App Store.
* Don't build anything that doesn't feel right for iOS (**no** Material Design, for example).

### User Interface
Build the app using **[this Figma spec](https://www.figma.com/file/PyfLvIWQss7Ki9lmzeoY9a/Counters-for-iOS).**

### Other Important Notes

* If you're using a dependency manager (like `CocoaPods` or `Carthage`) or the project requires additional configurations before compiling the app, **please** add a proper `README`.
* You can use the latest Swift version and the latest beta of Xcode.
* `SwiftUI` is not welcomed yet, please avoid using it.
* Showing off the capabilities of `UIKit` and `Core` frameworks is **essential**.
* If you're not implementing a particular functionality, don't add/enable it in the project.

**Remember**:

- The UI is super important. It should be neat and tidy. If you have any doubts, please reach to the team so we can clarify whatever is unspecified.
- We look at your deliverable in a _holistic_ way: delivering 60% of the test doesn't translate to a B or C grade: it's an F.
- If you need additional time to properly finish the test, please don't hesitate to ask for more. There's no penalty in asking for more time; there's penalty for not delivering quality software. We're looking forward to reviewing your best code, not a rushed implementation. Seriously just ask!

### Bonus Points (not mandatory, but nice):

* Don't use any external dependencies.
* Don't use libraries such as `ReactiveCocoa`, `RxSwift` or `Combine` (really, any reactive programming library in general).
* Lightweight view controllers (view-code would be awesome 🚀).
* Showing off some `Core Animation` knowledge.
* `XCTest`s are good.
* Think that this project could be developed alongside multiple developers. `GitFlow` usage would be useful.
* This app could also be used on landscape and/or iPad devices (i.e 2/3 Split View).
* Other cool stuff! We like to be surprised 🙂

## Blueprints

We gave you a starting project, with a few things that might help you get started. Feel free to use and modify them as you like.

The starting project contains:

- **Welcome Screen**: This is the initial implementation for the welcome screen.
- **Networking**: Be careful, it's built in Objective-C 👻, what you gonna do?
- **Color Assets**: The main colors of the app are already there.
- **Button**: The primary button used across the application.


## The Server

Setting up the server is easy! You will need to download and install [NodeJS](https://nodejs.org/en/download/) if you do not already have it. To run the mock server (included in this repo at `Server/`) execute the following commands in Terminal while in `Server/`:

```
$ npm install
$ npm start
```

## API Endpoints and Examples

Here are the endpoints with examples of the corresponding bodies which should be `Content-Type: application/json`. The examples show what the responses would be if the requests are done in sequence:

- `GET` `/api/v1/counters`

   Response Body:
   ```
   [
   ]
   ```

- `POST` `/api/v1/counter`

   Request Body:
   ```
   {
      "title": "Coffee"
   }
   ```
   Response Body:
   ```
   [
      {
         "id": "foo",
         "title": "Coffee",
         "count": 0
      }
   ]
   ```

- `POST` `/api/v1/counter`

   Request Body:
   ```
   {
      "title": "Tea"
   }
   ```
   Response Body:
   ```
   [
     { 
        "id": "asdf",
        "title": "Coffee",
        "count": 0
     },
     {
        "id": "qwer",
        "title": "Tea",
        "count": 0
     }
   ]
   ```

- `POST` `/api/v1/counter/inc`

   Request Body:
   ```
   {
      "id": "asdf"
   }
   ```

   Response Body:
   ```
   [
      {
         "id": "asdf",
         "title": "Coffee",
         "count": 1
      },
      {
         "id": "qwer",
         "title": "Tea",
         "count": 0
      }
   ]
   ```

- `POST` `/api/v1/counter/dec`

   Request Body:
   ```
   {
      "id": "qwer"
   }
   ```
   Response Body:
   ```
   [
      {
         "id": "asdf",
         "title": "Coffee",
         "count": 1
      },
      {
         "id": "qwer",
         "title": "Tea",
         "count": -1
      }
   ]
   ```

- `DELETE` `/api/v1/counter`

   Request Body:
   ```
   {
      "id": "qwer"
   }
   ```
   Response Body:
   ```
   [
      {
        "id": "asdf",
        "title": "Coffee",
        "count": 1
      }
   ]
   ```

- `GET` `/api/v1/counters`

   Response Body:
   ```
   [
      {
         "id": "asdf",
         "title": "Coffee",
         "count": 1
      }
   ]
   ```

---

![Sir Jonathan Paul "Jony" Ive](Jony.jpg)

_"Design it to look like my sh*t." -J_
