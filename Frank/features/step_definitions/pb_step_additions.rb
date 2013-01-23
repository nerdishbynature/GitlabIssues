When /^I select (\d*) row in picker "(.*?)"$/ do |row_ordinal, theview| 
  selector = "view:'UIPickerView' marked:'#{theview}'" 
  row_index = row_ordinal.to_i - 1
  views_switched = frankly_map( selector, 'selectRow:inComponent:animated:', row_index, 0, false ) 
  raise "could not find anything matching [#{row_ordinal}] to switch" if views_switched.empty? 
end 

When /^I touch "(.*?)" picker button$/ do |mark|
  wait_for_nothing_to_be_animating 
  quote = get_selector_quote(mark)
  touch("view:'UIToolbarTextButton' marked:#{quote}#{mark}#{quote}")
end

When /^I touch the "(.*?)" bar button$/ do |mark|
	wait_for_nothing_to_be_animating 
	quote = get_selector_quote(mark)
	touch("view:'UIBarButtonItem' marked:#{quote}#{mark}#{quote}")
end

When /^I fill in text fields as follows using the keyboard :$/ do |table|
  table.hashes.each do |row|
    step %Q|I enter the text "#{row['text']}" from keyboard to the textfield "#{row['field']}"|
  end
end

Then /^I should see a bubble item marked "(.*?)"$/ do |mark|
  quote = get_selector_quote(mark)
  check_element_exists("view:'HEBubbleViewItem' marked:#{quote}#{mark}#{quote}")
end

When /^I touch the bubble item marked  "(.*?)"$/ do |mark|
  quote = get_selector_quote(mark)
  touch("view:'HEBubbleViewItem' marked:#{quote}#{mark}#{quote}")
end

Then /^I should see a table view label marked "(.*?)"$/ do |mark|
  quote = get_selector_quote(mark)
  touch("view:'UITableViewLabel' marked:#{quote}#{mark}#{quote}")
end
