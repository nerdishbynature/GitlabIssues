When /^I touch the cell marked "(.*?)"$/ do |name|
  touch "view:'UILabel' marked:'#{name}'"
end

When /^I touch the UIToolbarButton with text "(.*?)"$/ do |arg1|
  touch "view:'UIToolbarTextButton' marked:'#{arg1}'"
end

Then /^I should see a cell with description "(.*?)" and content "(.*?)"$/ do |arg1, arg2|
	
end