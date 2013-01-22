Feature: Editing an Issue

Scenario: Adding a correct Domain

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

Scenario: Navigato to Issue

When I touch the 1 table cell
And I wait for 2 seconds
Then I should see a navigation bar titled "Projects"

When I touch the 1 table cell
And I wait for 2 seconds
Then I should see a navigation bar titled "AppleDemo"

Scenario: Close an issue

When I touch the 1 table cell
And I wait for 2 seconds
And I touch "Open"
And I wait for 2 seconds
Then I should see "Closed"

Scenario: Open Issue

When I touch "Closed"
And I wait for 2 seconds
Then I should see "Open"

Scenario: Add Assignee

When I touch "Edit"
And I wait for 1 second
And I touch the 1 table cell
And I wait for 1 second
And I select 2 row in picker "Assignee"
And I touch "Done" picker button
And I wait for 1 second
And I touch "Apply"
And I wait for 2 seconds
Then I should see a bubble item marked "AppleDemo"
