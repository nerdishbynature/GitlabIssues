When /^I touch the cell with placeholder "(.*?)"$/ do |name|
  touch("view:'UITextFieldLabel' marked:'#{name}'")
end

When /^I touch the cell with label "(.*?)"$/ do |name|
  touch("view:'UIlabel' marked:'#{name}'")
end

When /^I touch the button labeled "(.*?)"$/ do |name|
  touch("view:'UIlabel' marked:'#{name}'")
end