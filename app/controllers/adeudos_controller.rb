
class AdeudosController < ApplicationController

  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []

  def index
    @usuario = current_user
    @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last
    @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
  end

  def shows

  end

end