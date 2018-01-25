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
  end
end
