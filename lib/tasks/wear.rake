require "#{Rails.root}/lib/selenium/wear"

namespace :wear do
  desc "WEAR Scraping"

  task :scraping do
    begin
      b = WearBrowser.new
      b.access_mens_ranking
      b.get_ranking
      b.save_screenshot
      b.logger.info b.rankings
      b.logger.info "done."
    rescue => e
      puts e
      puts e.message
      puts e.backtrace
    end
  end
end
