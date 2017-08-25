## About
ArtDraw is a game in which users complete each others' drawings. That being said, the most important part is to have seemless play from one game to another.

## Pushing to Production
The current implementation is running on a Heroku application. To push changes to the heroku app, use the login information that will be provided in the credintials file and the following steps.
```
$ bundle exec rake assets:precompile
$ heroku login
$ git add .
$ git commit -m "Add commit message"
$ git push heroku master
$ heroku run rake db:migrate
```

## Complete and Future works
This section will first describe what has already been done with ArtDraw and then give a brief description of future features.


**User Profiles**
The user profiles uses the [Devise](https://github.com/plataformatec/devise) user management Gem. The two account creation methods that have been set up already are e-mail and Facebook login. To add login via Weibo part I would recommend looking into the documentation for creating the Facebook gem and modeling it after that as they also use Oath2.

**Game State**
The games are stored in a Game record where the table is called the games table. The games table has the following columns:
*   integer  "challenger_id"
*   integer  "opponent_id"
*   boolean  "active"
*   string   "title"
*   text     "clickX"
*   text     "clickY"
*   text     "clickDrag"
*   text     "clickColor"
*   datetime "created_at"
*   datetime "updated_at"
*   string   "challenge_name"

The creator of the game's id is listed as the **challenger_id** and will challenge someone based on a string **challenge_name** which links to the numerical opponent id in the database. The **challenger_id** and **opponent_id** are the keys which link to the user table. The boolean **active** is used to indicate when a game is still being played, the current layout is a game only lasts one turn before being reset. The string **title** is the title of the completed drawing and will be filled in by the second player when they complete the drawing. The variables **clickX**, **clickY**, **clickDrag**, **clickColor** are all filled in by the JavaScript as the user draws on the canvas. These arrays store all necessary data for the canvas state to be reloaded from the database. 

## Contributors
The list of contributors and Github accounts 
*   Brandon Arroyo - BrandonArroyo
*   Kyle Wilson - Bluyam