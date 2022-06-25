require "date"
require "custom_formatter"

$logger = Logger.new("log/controller.log")
$logger.formatter = CustomFormatter.new

class HomeController < ApplicationController
  def index
    today = Date.today
    @men_rankings = OutfitRanking.with_outfit_detail_and_poster.with_ranking_type.where(
      ranking_type: {
        name: "men"
      }
    ).where(
      year: 2022,
      month: 6
    )
    @women_rankings = OutfitRanking.with_outfit_detail_and_poster.with_ranking_type.where(
      ranking_type: {
        name: "women"
      }
    ).where(
      year: 2022,
      month: 6
    )
    @kids_rankings = OutfitRanking.with_outfit_detail_and_poster.with_ranking_type.where(
      ranking_type: {
        name: "kids"
      }
    ).where(
      year: 2022,
      month: 6
    )
    if Rails.env.development?
      msg = "#{QueryDiet::Logger.count} queries / #{QueryDiet::Logger.time} ms"
      $logger.debug(msg)
      $logger.debug(@men_rankings.inspect.to_yaml)
    end
  end
end
