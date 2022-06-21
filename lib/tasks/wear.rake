require "#{Rails.root}/lib/selenium/wear"

namespace :wear do
  desc "WEAR Scraping"

  task :scraping do
    logger = Logger.new("log/wear.log")
    logger.formatter = CustomFormatter.new
    begin
      b = WearBrowser.new
      b.ranking_info.each do |type, path|
        b.ranking_type = type
        b.ranking_path = path
        b.access_ranking_page
        b.get_ranking
        sleep 2
      end
      b.get_user_profile
      logger.info "done."
    rescue => e
      logger.error e.class
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end
  end
end
