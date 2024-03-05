# frozen_string_literal: true

# run this then back up db with
#   pg_dump -F t country_guessr_development > dev_backup.tar
# if the file exists, restore db with
#   pg_restore -C -d country_guessr_development development_backup.tar
# pull down the VCR cassettes located at
# [the link to the Google Drive containing this zip will be included in an email]

desc 'Scrape a website to get surname nationality information'
task run_surname_nationality_scraper: :environment do
  # uncomment below to clear seed data out of db before running
  # wipe_db
  agent = SurnameOriginsScraper.new
  # get the main page
  # "https://www.familyeducation.com/baby-names/surname/origin"
  main_page = VCR.use_cassette('main_page') do
    agent.retrieve_main_page
  end

  # get all nationality links
  nationality_links = agent.page_links(main_page)

  # get all the nationalities so we have them for surname_nationalities
  nationality_links.each do |link|
    Nationality.create(name: link.text)
  end

  # click through all the nationality links
  # rubocop:disable Style/CombinableLoops
  nationality_links.each do |nat_link|
    nationality = Nationality.find_by(name: nat_link.text)
    # click through to the nationality pages
    # e.g. https://www.familyeducation.com/baby-names/surname/origin/african
    nationality_page = VCR.use_cassette("nationality_page_#{nationality.name}") do
      nat_link.click
    end

    # collect all visible surname links
    surname_links = agent.page_links(nationality_page)
    # check the page for pagination links, collect remaining links
    collect_surname_links(agent, nationality_page, surname_links)

    surname_links.each do |link|
      # exlude surnames pages that come back 404 or if it alredy exists
      next if link.text.include?("’")
      next if link.text.include?('.')
      next if link.text == 'Prodoehl'
      next if link.text == 'Malcolm'
      next if Surname.find_by(name: link.text)

      # create surname
      surname = Surname.create(name: link.text)
      origin_page = VCR.use_cassette("origin_page_#{link.text}") do
        link.click
      end
      # collect the info and create the record
      origins = agent.surname_nationalities(origin_page)
      origins.each do |origin|
        nationality = Nationality.find_by(name: origin)
        begin
          surnat = SurnameNationality.create(
            surname_id: surname.id,
            surname_name: surname.name,
            nationality_id: nationality.id,
            nationality_name: nationality.name
          )
          puts "#{surnat.surname_name}, #{surnat.nationality_name}"
        # don't stop the rake task if there is a duplicate record
        rescue StandardError
          puts "Coould not create record for #{origin}."
        end
      end
    end
    # rubocop:enable Style/CombinableLoops
  end
end

def wipe_db
  Surname.destroy_all
  Nationality.destroy_all
  SurnameNationality.destroy_all
end

def collect_surname_links(agent, page, links)
  # look for pagination links, return if none exist
  pagination_links = agent.pagination_links(page)
  return if pagination_links.empty?

  # click next page unless you're on the last page in the pagination links
  next_page_button = agent.next_page_button(page)
  return if next_page_button.nil?

  # collect more surname links, recurse to get all the surname info
  next_page = next_page_button.click
  new_surname_links = agent.page_links(next_page)
  new_surname_links.each { |link| links << link }
  collect_surname_links(agent, next_page, links)
end
