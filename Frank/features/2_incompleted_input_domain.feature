Feature: Type in incompleted data

Scenario: Type in only domain

When I reset the simulator
Given I launch the app

Then I should see a navigation bar titled "Add your domain"
And I touch the 4 table cell
And I wait for 1 second
And I touch the 2 table cell
And I wait for 1 second

Then I should see a navigation bar titled "Add your domain"
When I touch the cell with placeholder "www.example.com"
When I type "nerdishbynature.biz" into the "www.example.com" text field

Given I launch the app
Then I should see a navigation bar titled "Add your domain"

Scenario: Type in only domain and email

Given I launch the app

Then I should see a navigation bar titled "Add your domain"
And I touch the 4 table cell
And I wait for 1 second
And I touch the 2 table cell
And I wait for 1 second

Then I should see a navigation bar titled "Add your domain"
When I touch the cell with placeholder "www.example.com"
When I type "nerdishbynature.biz" into the "www.example.com" text field

When I touch the cell with placeholder "me@example.com"
When I type "appledemo@nerdishbynature.com" into the "me@example.com" text field

Given I launch the app

Then I should see a navigation bar titled "Add your domain"

Scenario: Type in a correct domain without saving

Given I launch the app

Then I should see a navigation bar titled "Add your domain"
And I touch the 4 table cell
And I wait for 1 second
And I touch the 2 table cell
And I wait for 1 second

Then I should see a navigation bar titled "Add your domain"
When I touch the cell with placeholder "www.example.com"
When I type "nerdishbynature.biz" into the "www.example.com" text field

When I touch the cell with placeholder "me@example.com"
When I type "appledemo@nerdishbynature.com" into the "me@example.com" text field

When I touch the cell with placeholder "password"
When I type "!Qayxsw2" into the "password" text field

Given I launch the app

Then I should see a navigation bar titled "Add your domain"

Scenario: Type in a correct domain

Given I launch the app

And I touch the 4 table cell
And I wait for 1 second
And I touch the 2 table cell
And I wait for 1 second

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