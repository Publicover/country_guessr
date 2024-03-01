# frozen_string_literal: true 

module ScraperHelpers
  def get_main_page
    VCR.use_cassette('setup_main_page') do 
      SurnameOriginsScraper.new.retrieve_main_page
    end
  end

  def get_african_page
    VCR.use_cassette('african_page') do 
      Mechanize.new.get('https://www.familyeducation.com/baby-names/surname/origin/african')
    end
  end

  def get_american_page 
    VCR.use_cassette('american_page') do 
      Mechanize.new.get('https://www.familyeducation.com/baby-names/surname/origin/american')
    end
  end

  def get_arabic_page 
    VCR.use_cassette('arabic_page') do 
      Mechanize.new.get('https://www.familyeducation.com/baby-names/surname/origin/arabic')
    end
  end
end