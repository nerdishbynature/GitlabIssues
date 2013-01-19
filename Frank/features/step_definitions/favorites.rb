When /^I touch the table cell with label "(.*?)"$/ do |name|
	touch("view:'UILabel' marked:'#{name}'")
end