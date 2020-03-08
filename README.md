# GramGram

Send your instagram photos to your grandma in the mail.

## Getting Started

Prerequisites:

* Ruby - The current version of ruby is defined [here](https://github.com/edance/gram-gram/blob/master/.ruby-version)
* Yarn

Here are the steps to get started:

1. Copy `.env.example` file to `.env` with `cp .env.example .env` and fill out the environment variables
1. Import your environment variables with `export $(cat .env | grep -v ^# | xargs)`
1. Run `bundle install` and `yarn install` to install dependencies
1. Run `rails db:create` and `rails db:migrate` to set up your local db
1. Start Rails endpoint with `rails server`

Now you can visit [`localhost:3000`](http://localhost:3000) from your browser.

### Feedback

Please email me with any ideas, bugs, suggestions at evan AT gramgram.app.
