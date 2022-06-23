require "#{Rails.root}/lib/selenium/wear"

$logger = Logger.new("log/wear.log")
$logger.formatter = CustomFormatter.new

namespace :wear do
  desc "WEAR Scraping"

  task scraping: :environment do
    begin
      @result = get_acquisition_results
      if @result.nil?
        scraping_result = get_wear_rankings
        if scraping_result[:status] == "error"
          save_error_history(
            scraping_result[:error_contents]
          )
          next
        end
        @result = save_acquisition_results(
          scraping_result[:rankings]
        )
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
