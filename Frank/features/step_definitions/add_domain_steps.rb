When /^I touch the cell marked "(.*?)"$/ do |name|
  touch "view:'UILabel' marked:'#{name}'"
end