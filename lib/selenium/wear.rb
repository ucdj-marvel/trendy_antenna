require "selenium-webdriver"


class WearBrowser
  attr_reader :logger, :rankings

  def initialize()
    @logger = Logger.new("log/wear.log")
    @url = "https://wear.jp"
    @mens_ranking_url = "https://wear.jp/men-ranking/"
    @rankings = []

    if !File.directory?("#{Rails.root}/tmp/wear/")
      Dir.mkdir("#{Rails.root}/tmp/wear/")
    end

    Selenium::WebDriver::Chrome::Service.driver_path = "#{Rails.root}/bin/chromedriver"

    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-infobars")
    options.add_argument("--disable-setuid-sandbox")

    @driver = Selenium::WebDriver.for :chrome, capabilities: [options]
    @driver_wait = Selenium::WebDriver::Wait.new :timeout => 20
  end

  def handle_dialog
    @logger.info "alert: #{@driver.switch_to.alert.text}"
    @driver.switch_to.alert.accept
  end

  def save_screenshot
    page_width = @driver.execute_script('return document.body.scrollWidth')
    page_height = @driver.execute_script('return document.body.scrollHeight')
    @driver.manage.window.resize_to(page_width, page_height)
    @driver.save_screenshot("#{Rails.root}/tmp/wear/screenshot.png")
  end

  def access_mens_ranking
    @logger.info "access_mens_ranking"

    @driver.get @mens_ranking_url
    @driver_wait.until {
      @driver.find_element(:xpath, "//div[@class='image']/a/p[@class='img']/img")
    }
  end

  def get_ranking
    @logger.info "get_ranking"

    doc = Nokogiri::HTML.parse(@driver.page_source)

    file = File.open("#{Rails.root}/tmp/wear/ranking.html", "w")
    file.write(doc.to_s)
    file.close

    doc.xpath("//*[@id='main_list']/ol/li").each do |li|
      rank = li.css("p.rank").text.strip

      img = li.css(".image")
      detail_link = img.css("a").attribute("href").value
      image_src = img.css("p > img").attribute("src").value

      profile = li.css(".profile")
      profile_link = profile.css(".sub > p > a").attribute("href").value
      name = profile.css(".main > p > span.namefirst").text.strip
      @rankings.push(
        {
          "category": "men",
          "rank": rank,
          "detail_link": detail_link,
          "image_src": image_src,
          "profile_link": profile_link,
          "name": name,
        }
      )
    end
    @logger.info @rankings
  end
end