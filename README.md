# README

## THE PROJECT

I decided on an API becuase I like APIs. I focused on comments and tests so you can see how I'm 
thinking about everything. 

My first impression of the json I needed to return was that it came from a #pluck on a join table. 
That explains the way I structured the data as well as why I wanted to illustrate that structure with 
actual (probably accurate) information. 

For this project, I really took the instructions to "have fun" quite seriously. I wrote a web scraper--
something I haven't done in several years--to get the surnames and nationalities information. I reacquanted 
myself with the mechanize documentation. There were too few external APIs that you didn't need 
to sign up for or pay to access for my taste. I didn't quite expect there to be that much data for this, though, and 
I decided to let the scraper run for as long as it wanted. Which turns out to be about three days. 

I am having trouble explaining to my non-dev friends (all of them) why I find this so funny. 
But it was great babysitting my little scraper! My favorite part of it is the recursive bit 
that examines a page's pagination links, sees if there's a Next button, scoops up the links, then repeats.

## THE DATABASE 

I used the VCR gem to capture each API call so running the scraper doesn't require an internet connection. 
It speeds things up **massively**. If you'd like to see the scraper do it's thing, use the Google Drive link 
from the email I sent to get a zip of the VCR cassettes. (There are 52,740 files, so it might take a minute 
to download, but the files are relatively light.) Unzip them into lib/tasks/vcr_cassettes, where the 
app knows where to find them. If you'd like to change the location they're taken from, you can alter it in 
config/environments/development.rb. 

If you'd like to do something more sane, I put a .tar copy of the database in root. You can type the following 
into the terminal: pg_restore -C -d country_guessr_development development_backup.tar

## THE API

I use an auth system from scratch that I've been using for several years. It's been working well for me. It uses 
json web tokens. Users must first authorize at {localhost:3000 or whatever you're using}/api/v1/auth/login with 
email and password as params; headers must have Content-Type application/json. Record the token and put it as the 
value of the Authorization key for all subsequent requests (along with Content-Type application/json).

Country guesses have the query string paired to the name param, like this: localhost:3000/api/v1/countries/guess?name=Ba.
The return values are as specified in the assessment documentation.

I used rubocop for styling, VCR for catching API responses, bcrypt and jwt for the auth system, and mechanize for scraping. 
Minitest is my suite of choice, though I'm fine using RSpec also. I use minitest/pride to keep the colors of the test dots 
different from the colors of the linting dots. Finally, bullet helps to shave time of queries and brakeman makes sure 
I don't break security if I good around with the auth system. 