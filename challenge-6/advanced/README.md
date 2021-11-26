# Challenge 6

## Advanced

### Usage

To run the application:

1. Execute `bundler install` in the Terminal to install the dependencies.
2. Enter `dbname`, `user` and `password` in the `env.rb` file.
3. Execute `bundle exec rackup` to run the application.
4. The last number you will see in the output is the `port`.\
Open a browser and go to address `localhost:port`.

The corresponding error will be shown if you forgot to set up the database connection.

You will see the start page if database connection is ok.\
Here you can go to "Upload CSV File" and "Empty the Database" pages.

"Upload CSV File" page contains the form to upload the `.csv` file.

"States Report" will show you the reports for each state.\
Press on the state name to see the report for this state only.

"Fixture Type Count Report" will show you the reports for each fixture type and their totals.\
Press on the office name to see the report for this office only.

"Marketing Materials Costs Report" will show you the report on spent funds for each type of marketing material by the office.
