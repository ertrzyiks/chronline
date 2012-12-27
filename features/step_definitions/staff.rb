###
# Given step definitions
###

Given /^an author "(.*?)" exists$/ do |name|
  @author = Author.create(name: name)
end

Given /^there exists an author staff member$/ do
  @staff = FactoryGirl.create(:author)
end


###
# When step definitions
###

When /^I enter a valid author$/ do
  @author = FactoryGirl.build(:author)
  select @author.type, from: "Type"
  fill_in 'Name', with: @author.name
  fill_in 'Affiliation', with: @author.affiliation
  fill_in 'Tagline', with: @author.tagline
  fill_in 'Twitter', with: @author.twitter
  check 'Current Columnist?' if @author.columnist
end

When /^I fill in the search box with "(.*?)"$/ do |query|
  fill_in 'staff-search-input', with: query
end

When /^I make valid changes to the author$/ do
  @author = @staff

  @staff.twitter = "pikachu"
  @staff.columnist = true
  @staff.biography = "Travelled Kanto at age 10."

  fill_in 'Twitter', with: @staff.twitter
  check 'Current Columnist?' if @staff.columnist
  fill_in 'Biography', with: @staff.biography
end


###
# Then step definitions
###

Then /^the author should have the correct properties$/ do
  author = Author.find_by_name @author.name
  author.affiliation.should == @author.affiliation
  author.tagline.should == @author.tagline
  author.twitter.should == @author.twitter
  author.columnist.should == @author.columnist
  author.biography.should == @author.biography
end

Then /^I should see the typeahead suggestion "(.*?)"$/ do |name|
  # puts find('.typeahead').text
  pending
end

Then /^I should be on the edit staff page for "(.*?)"$/ do |name|
  Staff.find_by_name(name) do |staff|
    current_path.should == edit_admin_staff_path(staff)
  end
end

Then /^I should see the fields with staff information$/ do
  confirm_field_values('Name' => @staff.name,
                       'Affiliation' => @staff.affiliation,
                       'Tagline' => @staff.tagline,
                       'Twitter' => @staff.twitter,
#                       'Current Columnist?' => @staff.columnist,
                       'Biography' => @staff.biography,
                       )
end
