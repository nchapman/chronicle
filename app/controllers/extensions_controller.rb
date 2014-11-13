class ExtensionsController < ApplicationController
  def firefox
    send_file "#{Rails.root}/public/extensions/firefox/chronicle.xpi", type: 'application/x-xpinstall', disposition: 'inline'
  end
end
