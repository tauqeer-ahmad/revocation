class HomeController < ApplicationController
  layout 'splash'

  def index
    @subdomain = request.subdomain
  end
end
