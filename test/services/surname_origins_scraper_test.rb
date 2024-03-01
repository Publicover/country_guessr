require 'test_helper'

class SurnameOriginsScraperTest < ActiveSupport::TestCase
  setup do 
    @agent = SurnameOriginsScraper.new
    @main_page = get_main_page
    @page_links = SurnameOriginsScraper.new.page_links(@main_page)
    # this is the first link on the nationality page; it has no pagination links 
    @african_page = get_african_page
    # this is the second link on the nationality page; it has no pagination links 
    @american_page = get_american_page
    # this is the third link on the nationality page; it has pagination links 
    @arabic_page = get_arabic_page
  end

  # return landing page with nationalities
  test 'should return surname origins page' do 
    page = @agent.retrieve_main_page
    refute page.nil? 
    refute page.blank?
    assert_equal @main_page.uri.to_s, page.uri.to_s
  end

  # collect the all the links of the nationalities 
  test 'should return links on main page' do 
    page_links = @agent.page_links(@main_page)
    assert_equal page_links[0].to_s, 'African'
    assert_equal page_links[-1].to_s, 'Welsh'
  end

  # click through those links to get to the pages with surnames 
  test 'should get next page' do 
    link = @page_links[0]
    next_page = VCR.use_cassette('next_page') do 
      @agent.next_page(link)
    end
    next_page_title = next_page.search('//*[@id="block-babynamebybrowseoriginblock"]/h2').text
    # whichever link is clicked, all the surname index pages have the same pattern for titles
    # so we shouldn't feel bad about checking against the string
    assert_equal next_page_title, "#{link.text} Last Names"
  end
  
  # grab the pagination links and make sure they have identifiable text 
  test 'should know pagination links for countries of origin pages' do 
    pagination_links = @agent.pagination_links(@arabic_page)
    assert pagination_links[0].text.include?('Current page')
    assert pagination_links[1].text.include?('Page')
    assert pagination_links[-2].text.include?('Next')
    assert pagination_links[-1].text.include?('Last')
  end

  test 'should return nil for blank pagination links' do 
    assert @agent.pagination_links(@african_page).empty?
  end

  # click on the next button in the pagination links, the arabic surnames index page
  test 'next page button should get pagination link to next page' do 
    pagination_links = @agent.pagination_links(@arabic_page)
    next_button = @agent.next_page_button(pagination_links)
    arabic_surnames_index = VCR.use_cassette('arabic_surnames_index') do 
      @agent.next_page(next_button)
    end
    assert_equal arabic_surnames_index.uri.to_s, 'https://www.familyeducation.com/baby-names/surname/origin/arabic?page=1'
  end 

  test 'next page button should return nil if on last page of surname index' do 
    # get the pagination links from the arabic page
    links = @agent.pagination_links(@arabic_page)
    # go to the last page of the nationality via the pagination links
    last_page = VCR.use_cassette('last_page') do  
      @agent.next_page(links[-1])
    end
    # check to make sure there is no next button 
    last_links = @agent.pagination_links(last_page)
    # get the link, expect it to return nil because it doesn't exist
    button = VCR.use_cassette('nil_button') do 
      @agent.next_page_button(last_links)
    end
    assert button.empty? 
  end
end