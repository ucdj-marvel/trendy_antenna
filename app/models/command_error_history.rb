$client = Slack::Web::Client.new

class CommandErrorHistory < ApplicationRecord
  after_commit :slack_notify, on: :create

  enum :command, {
    wear: 0
  }

  def slack_notify
    $client.chat_postMessage(
      channel: ENV["TRENDY_ANTENNA_CHANNEL"],
      text: "#{error_class}: #{message}"
    )
    if screen_shot
      decoded_data = Base64.decode64(screen_shot)
      ss_path = "#{Rails.root}/tmp/wear/decode_screen_shot.png"
      File.open(ss_path, 'wb') do |f|
        f.write(decoded_data)
      end
      $client.files_upload(
        channels: ENV["TRENDY_ANTENNA_CHANNEL"],
        file: Faraday::UploadIO.new(
          ss_path, 'image/png'
        ),
        filename: 'error_screen_shot.png',
      )
    end
  end
end
