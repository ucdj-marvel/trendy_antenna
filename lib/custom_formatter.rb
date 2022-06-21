class CustomFormatter < ActiveSupport::Logger::SimpleFormatter
  def call(severity, time, progname, msg)
    "[#{severity}] #{time} (pid=#{$PROCESS_ID}) -- #{msg}\n"
  end
end