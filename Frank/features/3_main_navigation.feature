Feature: Main Navigation tests

Scenario: Type in a correct domain

When I reset the simulator
Given I launch the app

Then I should see a navigation bar titled "Add your domain"

When I fill in text fields as follows using the keyboard :
      | field      		| text |
      | www.example.com | nerdishbynature.biz |
      | me@example.com	| appledemo@nerdishbynature.com |
      | password | !Qayxsw2 |

And I touch "Done"
And I wait for 2 seconds
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
And I wait for 5 seconds
Then I should see a navigation bar titled "Created By Me"

When I am navigating back
Then I should see a "Logout" button

Scenario: Navigate to Find Repos

Given I launch the app

When I touch the 2 table cell
And I wait for 5 seconds
Then I should see a navigation bar titled "Search"

When I am navigating back
Then I should see a "Logout" button

Scenario: Navigate to Domain

Given I launch the app

When I touch the 1 table cell
And I wait for 5 seconds
Then I should see a navigation bar titled "Projects"

When I wait for 2 seconds
And I am navigating back
Then I should see a "Logout" button