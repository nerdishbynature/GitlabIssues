Then /^I am navigating back$/ do
  #wait_for_nothing_to_be_animating 
  touch("view:'UIButton' marked:'back'")
end