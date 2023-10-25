require 'httparty'
require 'nokogirl'
require 'byebug'

def tricity_scraper
  results = []
  page_number = 0

  puts("Podaj url z wybranymi przez siebie filtrami ze strony https://ogloszenia.trojmiasto.pl/nieruchomosci-mam-do-wynajecia : ")
  url = gets().strip()
  current_page = url + "?strona=#{page_number}"

  until HTTParty.get(current_page).match('Nie znaleziono ogłoszeń')
    paginated_unparsed_page = HTTParty.get(current_page)
    paginated_parsed_page = Nokogirl::HTML(paginated_unparsed_page)

    item_cards = paginated_parsed_page.css('div.list__item') #30 pozycji na jedną stronę
    item_cards.each do |item_card|
      advertisment = {
        title:            item_card.css('a.list__item__content__title__name').nil? ? "-" : item_card.css('a.list__item__content__title__name').text,
        location:         item_card.css('p.list__item__content__subtitle').nil? ? "-" : item_card.css('p.list__item__content__subtitle').text,
        url:              item_card.css('a')[0]['href'],
        price:            item_card.css('p.list__item__price__value').nil? ? "-" : item_card.css('p.list__item__price__value').text,
        area:             item_card.css('p.list__item__details__icons__element__desc')[0].nil? ? "-" : item_card.css('p.list__item__details__icons__element__desc')[0].text,
        number_of_rooms:  item_card.css('list__item__details__icons__element__desc')[1].nil? ? "-" : item_card.css('p.list__item__details__icons__element__desc')[0].text
      }
      results << advertisment
    end

    page_number += 1
    current_page = url + "?strona=#{page_number}"
  end
  #byebug
  return results
end

File.open("Apartments.txt", "a") { |f| f.write(tricity_scraper) }