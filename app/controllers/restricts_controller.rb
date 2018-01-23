class RestrictsController < ApplicationController
  def access_denied
    @require = params[:required]
    @section = params[:section]
  end
end
