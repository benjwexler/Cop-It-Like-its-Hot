
<h1> Database Architecture </h1>

<p> 
I chose to implement 3 tables for this project (Users, Holdings, Transactions).
<br>
 I could have set the database up without the Holdings table, but I believe creating this Table lessons the strain on the back-end tremendously and will help with scaling.
  
  To derive a users' portfolio evaluation without a Holdings table would require that I calculate how many shares a user has of a stock based on each transaction the user created for a particular stock. A user could potentially make 1000 different trades for 1 stock. If I had a lot of users' this would not be scalable for the server and would slow down load speed.
  <br>
</p>

<h1> IEX API Calls </h1>

<p> 
I chose to implement all API calls on the front-end using AJAX. This allows the page to load extremely quickly.

</p>

### Site Demo 
I encourage you to test out the site! You can either sign up and create your own account, or login to a demo account [here](https://thawing-island-46559.herokuapp.com/) using the following credtials:

```
Email: neonBullTrading@gmail.com

Password: 123456
```

<h1> Future Improvements </h1>

<p> 
I will update this shortly

</p>
