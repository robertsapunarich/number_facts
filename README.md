# Number Facts API

A chat API powered by AI with a single endpoint to tell you interesting facts about a number.
## Setup

### Dependencies

Ruby Version 3.2.2
Using [rbenv](https://github.com/rbenv/rbenv) to manage Ruby versions is highly recommended.

### Running the application

Enter the directory.

`cd number_facts`

Use the correct Ruby version

`rbenv 3.2.2`

Install application dependencies from Gemfile

`bundle install` 

Start the server:

`rails s`

From Postman, Insomnia, cURL, or any HTTP client of your choice, make the following GET request

`localhost:3000/fun_facts?question=your question about the number N`

Run the tests from the local directory to ensure endpoints are working properly.

`bundle exec rspec`

