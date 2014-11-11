class PagePostProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(page)
    page.reload
    page.post_process!
  end
end
