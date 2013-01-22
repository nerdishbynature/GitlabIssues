Feature: Issue adding

Scenario: Add a good formatted issue

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

When I touch the 1 table cell
And I wait for 2 seconds
Then I should see a navigation bar titled "Projects"

When I touch the 1 table cell
And I wait for 2 seconds
And I touch "Add"
And I wait for 2 seconds
Then I should see a navigation bar titled "New Issue"

When I enter the text "Frank issue" from keyboard to the textfield "title"
And I touch "Apply"
And I wait for 2 seconds
Then I should see "Frank issue"

Scenario: Add a bad formatted issue

When I touch "Add"
And I wait for 2 seconds
Then I should see a navigation bar titled "New Issue"

When I touch "Apply"

And I wait for 2 seconds
Then I should not see ""