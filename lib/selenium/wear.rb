require "date"
require "selenium-webdriver"
require "custom_formatter"


$logger = Logger.new("log/wear.log")
$logger.formatter = CustomFormatter.new


def get_acquisition_results
  $logger.info "get_acquisition_results"
  today = Date.today
  return AcquisitionResult.find_by(
    command: 0,
    date: today
  )
end


def save_acquisition_results(rankings)
  $logger.info "save_acquisition_results"
  today = Date.today
  return AcquisitionResult.create!(
    command: 0,
    date: today,
    result: rankings
  )
end


def save_error_history(error_contents)
  $logger.info "save_error_history"
  binary_data = File.read(
    error_contents[:ss_path]
  )
  CommandErrorHistory.create!(
    command: 0,
    error_class: error_contents[:error_class],
    message: error_contents[:message],
    backtrace: error_contents[:backtrace],
    html: error_contents[:html],
    screen_shot: Base64.strict_encode64(
      binary_data
    ),
    error_datetime: error_contents[:error_datetime]
  )
end


def save_wear_rankings(acquisition_result)
  d = acquisition_result.date
  ApplicationRecord.transaction do
    for rank_info in acquisition_result.result do
      rank_info = rank_info.symbolize_keys
      gender = Gender.find_or_create_by!(
        name: rank_info[:gender]
      )
      hairstyle = nil
      if rank_info[:hairstyle]
        hairstyle = Hairstyle.find_or_create_by!(
          name: rank_info[:hairstyle]
        )
      end
      outfit_poster = OutfitPoster.create!(
        gender: gender,
        hairstyle: hairstyle,
        user_id: rank_info[:user_id],
        name: rank_info[:name],
        icon_url: rank_info[:icon_url],
        age: rank_info[:age],
        height: rank_info[:height],
        intro: rank_info[:profile_txt],
      )
      outfit_detail = OutfitDetail.create!(
        outfit_poster: outfit_poster,
        fashion_id: rank_info[:fashion_id],
        title: rank_info[:title],
        img_url: rank_info[:image_url],
      )
      ranking_type = RankingType.find_or_create_by(
        name: rank_info[:ranking_type]
      )
      OutfitRanking.create!(
        outfit_detail: outfit_detail,
        ranking_type: ranking_type,
        rank: rank_info[:rank],
        year: d.year,
        month: d.month,
      )
    end
  end
end


def get_wear_rankings
  b = WearBrowser.new
  begin
    b.ranking_info.each do |type, path|
      b.ranking_type = type
      b.ranking_path = path
      b.access_ranking_page
      b.get_ranking
      sleep 2
    end
    b.get_user_profile
    return {
      "status": "success",
      "rankings": b.rankings
    }
  rescue => e
    puts "WearBrowser Error: #{e.class}"
    $logger.error e.class
    $logger.error e.message
    $logger.error e.backtrace.join("\n")
    return {
      "status": "error",
      "error_contents": b.error_contents(e)
    }
  end
end


class WearBrowser
  attr_writer :ranking_type, :ranking_path
  attr_reader :ranking_info, :rankings

  def initialize()
    @url = "https://wear.jp/"
    @ranking_info = {
      # "all": "ranking",
      "men": "men-ranking",
      "women": "women-ranking",
      "kids": "kids-ranking",
      # "world": "world-ranking",
    }
    @gender = [
      "MEN",
      "WOMEN",
      "KIDS",
    ]
    @ranking_type = ""
    @ranking_path = ""
    @rankings = []

    if !File.directory?("#{Rails.root}/tmp/wear/")
      Dir.mkdir("#{Rails.root}/tmp/wear/")
    end

    driver_path = "#{Rails.root}/bin/chromedriver"
    if Rails.env.development?
      driver_path = "#{Rails.root}/tmp/chrome/chromedriver"
    end
    Selenium::WebDriver::Chrome::Service.driver_path = driver_path

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-gpu")
    options.add_argument("--disable-infobars")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-setuid-sandbox")

    @driver = Selenium::WebDriver.for :chrome, capabilities: [options]
    @driver_wait = Selenium::WebDriver::Wait.new :timeout => 20
  end

  def handle_dialog
    $logger.info "alert: #{@driver.switch_to.alert.text}"
    @driver.switch_to.alert.accept
  end

  def save_screenshot(ss_path)
    @driver.save_screenshot(ss_path)
  end

  def error_contents(e)
    doc = Nokogiri::HTML.parse(@driver.page_source)
    ss_path = "#{Rails.root}/tmp/wear/error.png"
    save_screenshot(ss_path)
    return {
      "error_class": e.class,
      "message": e.message,
      "backtrace": e.backtrace.join("\n"),
      "html": doc.to_s,
      "ss_path": ss_path,
      "error_datetime": DateTime.now,
    }
  end

  def access_ranking_page
    $logger.info "access_#{@ranking_type}_ranking_page"

    @driver.get "#{@url}#{@ranking_path}/"
    @driver_wait.until {
      @driver.find_element(:xpath, "//div[@class='image']/a/p[@class='img']/img")
    }
  end

  def get_ranking
    $logger.info "get_#{@ranking_type}_ranking"

    doc = Nokogiri::HTML.parse(@driver.page_source)

    if Rails.env.development?
      file = File.open("#{Rails.root}/tmp/wear/ranking.html", "w")
      file.write(doc.to_s)
      file.close
    end

    doc.xpath("//*[@id='main_list']/ol/li").each do |li|
      rank = li.css("p.rank").text.strip.to_i
      break if rank > 10

      img = li.css(".image")
      detail_link = img.css("a").attribute("href").value
      path_list = detail_link.split("/")
      image_path = img.css("p > img").attribute("src").value
      title = img.css("p > img").attribute("alt").value

      name = li.css(".profile > .main > p > span.namefirst").text.strip
      @rankings.push(
        {
          "ranking_type": @ranking_type,
          "rank": rank,
          "user_id": path_list[1],
          "fashion_id": path_list[2],
          "image_url": "https:#{image_path}",
          "name": name,
          "title": title,
        }
      )
    end

    if Rails.env.development?
      file = File.open("#{Rails.root}/tmp/wear/ranking.json", "w")
      ranking_json = {"ranking": @rankings}
      JSON.dump(ranking_json, file)
      file.close
    end
  end

  def get_user_profile
    $logger.info "get_user_profile"

    @rankings.each_with_index do |rank_info, index|
      profile_url = "#{@url}#{rank_info[:user_id]}/"
      @driver.get profile_url
      $logger.debug "#{rank_info[:category]} rank #{rank_info[:rank]}: #{profile_url}"
      @driver_wait.until {
        @driver.find_element(:xpath, "//*[@id='user_main']/section[@class='profile']/p[@class='txt']")
      }
      doc = Nokogiri::HTML.parse(@driver.page_source)

      if Rails.env.development? && index == 0
        $logger.debug "#{rank_info['user_id']} html file create."
        file = File.open("#{Rails.root}/tmp/wear/profile.html", "w")
        file.write(doc.to_s)
        file.close
      end

      icon_path = doc.xpath("//*[@id='user_sub']/div[@class='image']/p/img").attribute("src").value
      rank_info["icon_url"] = "https:#{icon_path}"
      doc.xpath(
        "//*[@id='user_main']/section[@class='intro']/div/ul[contains(@class, 'info')]/li"
      ).each do |li|
        li_txt = li.text.strip
        if li_txt.include?("@")
          next
        elsif li_txt.include?("歳")
          rank_info["age"] = li_txt.delete("歳").to_i
        elsif li_txt.include?("cm")
          rank_info["height"] = li_txt.delete("cm").to_i
        elsif @gender.include?(li_txt)
          rank_info["gender"] = li_txt
        else
          rank_info["hairstyle"] = li_txt
        end
      end
      profile_txt = doc.xpath("//*[@id='user_main']/section[@class='profile']/p[@class='txt']")
      profile_txt.search("br").each do |br|
        br.replace("\n")
      end
      rank_info["profile_txt"] = profile_txt.text.strip

      sleep 2
    end

    if Rails.env.development?
      file = File.open("#{Rails.root}/tmp/wear/ranking.json", "w")
      ranking_json = {"ranking": @rankings}
      JSON.dump(ranking_json, file)
      file.close
    end
  end
end