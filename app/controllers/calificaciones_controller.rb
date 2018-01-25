require 'portal_alumnos/consulta_examenes_class'
require 'portal_alumnos/calificaciones_class'

class CalificacionesController < ApplicationController
  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []
  
  include PortalAlumnos

  #
  # Acción que mostrará los periodos en los que el alumno tiene calificaciones.
  #
  def index
    begin
      @user = current_user
      @consulta_examenes = ConsultaExamenesClass.new(@user)
    rescue Exception => error
      @mensaje = error
    end
    info_alumno
  end
  
  #
  # Acción que mostrará las calificaciones del alumno de acuero al periodo que haya seleccionado.
  #
  def shows
    begin
      @user = current_user
      inscripcion = Inscripcion.find_by_id(params[:inscripcion_id])
      @calificaciones = CalificacionesClass.new(@user, inscripcion)
    rescue Exception => error
      @mensaje = error
    end    
    render :partial => 'calificaciones_partial'
    info_alumno
  end

  def info_alumno
    @usuario = current_user
    @periodo_actual = current_ciclo.ciclo
    ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
    @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
    @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last
    @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
    @profesor =  @usuario.alumno.profesor || Profesor.new
  end
end
