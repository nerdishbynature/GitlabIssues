Feature: Main Navigation tests

Scenario: Type in a correct domain

When I reset the simulator
Given I launch the app

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

Scenario: Navigate to Favorites

Given I launch the app

When I touch the 4 table cell
Then I should see a navigation bar titled "Favorites"
When I am navigating back
Then I should see a "Logout" button

Scenario: Navigate to Dashboard

Given I launch the app

When I touch the 3 table cell
When I wait for 5 seconds
Then I should see a navigation bar titled "Created By Me"
When I am navigating back
Then I should see a "Logout" button

Scenario: Navigate to Find Repos

Given I launch the app

When I touch the 2 table cell
When I wait for 5 seconds
Then I should see a navigation bar titled "Search"
When I am navigating back
Then I should see a "Logout" button

Scenario: Navigate to Domain

Given I launch the app

When I touch the 1 table cell
When I wait for 5 seconds
Then I should see a navigation bar titled "Projects"
When I am navigating back
Then I should see a "Logout" button