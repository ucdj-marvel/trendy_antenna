require "#{Rails.root}/lib/selenium/wear"

$logger = Logger.new("log/wear.log")
$logger.formatter = CustomFormatter.new

namespace :wear do
  desc "WEAR Scraping"

  task scraping: :environment do
    begin
      @result = get_acquisition_results
      if @result.nil?
        result = get_wear_rankings
        if result[:status] == "error"
          return
        end
        @result = save_acquisition_results(result[:rankings])
      end
      $logger.info "done."
    rescue => e
      p "Task Error.\n#{e.class}"
      $logger.error e.class
      $logger.error e.message
      $logger.error e.backtrace.join("\n")
    end
  end
end
