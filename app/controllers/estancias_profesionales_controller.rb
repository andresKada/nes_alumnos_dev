class EstanciasProfesionalesController < ApplicationController

  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []


  def index

  end

  def shows
  end

end