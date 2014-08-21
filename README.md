### About

This app is an example of using Angular.js with a decoupled Rails server. "Decoupled" means that the browser app and server will run on different servers. The server runs on Puma and the client on Node/Connect to serve up its static assets. The server serves up JSON, and the browser app will use said JSON for maximum SPA awesomeness. The authentication between the two uses token-based-authentication with devise.

The application functionality is of an Online Schooling Platform (OSM). Teachers may sign their classes (refered to internally as assemblies) up, students may sign up and add their classes. Teachers can create textbooks and upload or create chapters for these textbooks. Teachers can create and assign their students online homework, quizzes, and tests. Students can take these tests and have their score recorded.

##### Etcetera

The reason for decoupling the server from client was that I was planning on - and still might - build the Angular app into an Ionic app, whilst keeping a single server/api between the mobile and browser clients.

Not all of the browser app functionality was completed. The backend is fully matured, simple, and highly performant. The browser client unfortunately still needs a lot of Jade and CSS. The majority of the CS should be done. I enjoyed using Jade and CS for this repo. I believe they slightly increased my productivity solely because they are more human-readable than their HTML/JS counterparts. They also allowed (and forced) me to structure my code better.

The Rails server utilizes a ton of metaprogramming. This is to keep the models and controllers as thin and simple as possible. The biggest model is the `User` model with ~40 lines of actual code. This was acheived in part via Redis, which keeps track of all foreign ids and automatically relates objects using a method called `rbridge`. This method will relate many to many and one to many relationships (one to one is done via Postgres). For instance, if a comment is created with a `user_id` of 2, `rbridge` will append the comment's id to user two's `comment_ids` key. This is all done via naming convention, staying true to the "Rails way". I avoided using Rails' model relations (even though they can be used for the one to one relations) to keep uniformity of methods in the models. Take a look at the specs for further understanding of the api.

### Downloading

#### Clients

##### Browser

Make sure you have Node.js, npm, and bower installed. Run `npm install` and `bower install` from `/clients/browser` to install dependencies.

To run the browser client app, run `gulp dev` in `/clients/browser`. The server will run on `localhost:9000`.

#### Server

The server runs on Rails with Postgres and Redis. Bundle and run `rails s` to start the server.

The server will run on `localhost:3000.` It will spit out a JSON api for the client app to consume.