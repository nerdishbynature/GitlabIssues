Feature: Adding a new domain

Scenario: Type in a correct domain

When I reset the simulator
Given I launch the app

Then I should see a navigation bar titled "Add your domain"
When I touch the 4 table cell
When I select 1 row in picker "Protocol"
When I touch "Done" picker button

Then I should see a navigation bar titled "Add your domain"
When I touch the cell with placeholder "www.example.com"
When I type "nerdishbynature.biz" into the "www.example.com" text field

When I touch the cell with placeholder "me@example.com"
When I type "appledemo@nerdishbynature.com" into the "me@example.com" text field

When I touch the cell with placeholder "password"
When I type "!Qayxsw2" into the "password" text field

When I touch "Done"
When I wait for 5 seconds
Then I should see a "Logout" button

Scenario: Choose the wrong Protocol

When I reset the simulator
Given I launch the app

Then I should see a navigation bar titled "Add your domain"
When I touch the 4 table cell
When I select 2 row in picker "Protocol"
When I touch "Done" picker button

When I touch the cell with placeholder "www.example.com"
When I type "nerdishbynature.com" into the "www.example.com" text field

When I touch the cell with placeholder "me@example.com"
When I type "appledemo@nerdishbynature.com" into the "me@example.com" text field

When I touch the cell with placeholder "password"
When I type "!Qayxsw2" into the "password" text field

When I touch "Done"
When I wait for 5 seconds
Then I should see an alert view with the message "Something went wrong, please check your input."

Scenario: Type in a incorrect domain

When I reset the simulator
Given I launch the app

Then I should see a navigation bar titled "Add your domain"
When I touch the 4 table cell
When I select 1 row in picker "Protocol"
When I touch "Done" picker button

Then I should see a navigation bar titled "Add your domain"
When I touch the cell with placeholder "www.example.com"
When I type "nerdishbynature.com" into the "www.example.com" text field

When I touch the cell with placeholder "me@example.com"
When I type "appledemo@nerdishbynature.com" into the "me@example.com" text field

When I touch the cell with placeholder "password"
When I type "!Qayxsw2" into the "password" text field

When I touch "Done"
When I wait for 5 seconds
Then I should see an alert view with the message "Something went wrong, please check your input."

Scenario: Type in a incorrect email

When I reset the simulator
Given I launch the app

Then I should see a navigation bar titled "Add your domain"
When I touch the 4 table cell
When I select 1 row in picker "Protocol"
When I touch "Done" picker button

Then I should see a navigation bar titled "Add your domain"
When I touch the cell with placeholder "www.example.com"
When I type "nerdishbynature.biz" into the "www.example.com" text field

When I touch the cell with placeholder "me@example.com"
When I type "nothing@nerdishbynature.com" into the "me@example.com" text field

When I touch the cell with placeholder "password"
When I type "!Qayxsw2" into the "password" text field

When I touch "Done"
When I wait for 5 seconds
Then I should see an alert view with the message "Something went wrong, please check your input."
