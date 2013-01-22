Feature: Adding a new domain

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

Scenario: Type in a incorrect domain

When I reset the simulator
Given I launch the app

Then I should see a navigation bar titled "Add your domain"
And I touch the 4 table cell
And I wait for 1 second
And I touch the table cell marked "https"
And I touch "Back"
And I wait for 1 second

And I fill in text fields as follows using the keyboard :
      | field      		| text |
      | www.example.com | nerdishbynature.com |
      | me@example.com	| appledemo@nerdishbynature.com |
      | password | !Qayxsw2 |

And I touch "Done"

And I wait for 5 seconds
Then I should see an alert view with the message "Something went wrong, please check your input."

Scenario: Type in a incorrect email

When I reset the simulator
Given I launch the app

Then I should see a navigation bar titled "Add your domain"
And I touch the 4 table cell
And I select 2 row in picker "Protocol"
And I touch "Done" picker button

And I fill in text fields as follows using the keyboard :
      | field      		| text |
      | www.example.com | nerdishbynature.com |
      | me@example.com	| demo@nerdishbynature.com |
      | password | !Qayxsw2 |

And I touch "Done"

And I wait for 5 seconds
Then I should see an alert view with the message "Something went wrong, please check your input."
