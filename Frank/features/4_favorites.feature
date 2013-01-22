Feature: Add to favorites

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

Scenario: Star a project

Given I launch the app

Then I should see a "Logout" button

When I touch the 1 table cell
And I wait for 3 seconds
Then I should see a navigation bar titled "Projects"

When I touch the 1 table cell
And I wait for 3 seconds
Then I should see a navigation bar titled "AppleDemo"

When I touch "star"
And I am navigating back
And I wait for 3 seconds
And I am navigating back
Then I should see a "Logout" button

Scenario: Open the stared project in favorites

Given I launch the app

When I touch the 4 table cell
Then I should see a navigation bar titled "Favorites"
When I wait for 1 second
And I touch the 1 table cell
Then I should see a navigation bar titled "AppleDemo"

