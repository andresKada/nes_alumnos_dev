require 'portal_alumnos/horarios_module'
require 'portal_alumnos/horarios_class'
require 'portal_alumnos/asignaturas_class'
require 'portal_alumnos/consulta_horarios_class'

class HorariosController < ApplicationController
  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []

  include PortalAlumnos

  def index
    begin
      @user = current_user
      @consulta_horarios = ConsultaHorariosClass.new(@user)
    rescue Exception => mensaje
      @mensaje = mensaje
    end
      info_alumno
  end
  #
  # Acción que muestra el horario del calendario de exámenes según la inscripción que el alumno haya seleccionado.
  #
  def shows
    begin
      @user = current_user
      @horarios = HorariosModule.load_horarios(@user, params[:inscripcion_id])
    rescue Exception => mensaje
      @mensaje = mensaje
    end
    info_alumno
    render :partial => 'horarios_partial'
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

