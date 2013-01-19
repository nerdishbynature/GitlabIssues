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