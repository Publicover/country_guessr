# frozen_string_literal: true

# main page:
# "https://www.familyeducation.com/baby-names/surname/origin"

# nationality_links link to:
# "https://www.familyeducation.com/baby-names/surname/origin/african"

# nationality_page is:
# "https://www.familyeducation.com/baby-names/surname/origin/african"

# surname_links link to:
# "https://www.familyeducation.com/baby-names/name-meaning/ba"

# surname_page is:
# "https://www.familyeducation.com/baby-names/name-meaning/ba"

class SurnameOriginsScraper
  def retrieve_main_page
    agent = Mechanize.new
    agent.get(SurnameOriginsUrl.full_url)
    agent.page
  end

  # due to the CSS on this site, the following method works for multiple pages here
  def page_links(page)
    page.links_with(css: '#block-babynamebybrowseoriginblock > ul > li > a')
  end

  # the pagination css looks the same on every page
  # return empty array so we can tell if it ran and found nothing rather than just failing
  def pagination_links(page)
    links = page.links_with(css: '//*[@id="block-babynamebybrowseoriginblock"]/nav/ul/li/a')
    links.empty? ? [] : links
  end

  # this site's pattern for pagination is Current, Page, Next, Last
  # return empty array so we can tell if it ran and found nothing rather than just failing
  def next_page_button(page)
    button_text = "\n            Next page\n            Next\n          "
    button = page.link_with(text: button_text)
    button || nil
  end

  # only for pages of individual names
  # for instance: https://www.familyeducation.com/baby-names/name-meaning/ba
  def get_surname(page)
    page.search('//*[@id="speak-title"]').text
  end

  # only for pages of individual names, returns array of strings for use in surname_nationality
  # for instance: https://www.familyeducation.com/baby-names/name-meaning/ba
  def surname_nationalities(page)
    origins = []
    nationalities = page.search('//*[@id="block-fentheme-content"]/article/div/div/ul/li')
    nationalities.each do |nationality|
      origins << nationality.text.match(/^.+?(\b)/).to_s
    end
    origins
  end
end
