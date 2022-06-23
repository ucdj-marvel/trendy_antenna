require "#{Rails.root}/lib/selenium/wear"

$logger = Logger.new("log/wear.log")
$logger.formatter = CustomFormatter.new

$client = Slack::Web::Client.new

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
      puts "Task Error: #{e.class}"
      $client.chat_postMessage(
        channel: ENV["TRENDY_ANTENNA_CHANNEL"],
        text: "#{e.class}: #{e.message}\n#{e.backtrace.join('\n')}"
      )
    end
  end
end
