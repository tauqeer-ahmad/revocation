class ErrorController < ApplicationController
  layout 'empty'

  protect_from_forgery except: [:not_found, :server]

  def not_found
  end

  def server
  end
end
