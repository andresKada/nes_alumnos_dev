require 'portal_alumnos/examenes_module'
require 'portal_alumnos/examenes_class'
require 'portal_alumnos/consulta_examenes_class'

class ExamenesController < ApplicationController
  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []
  
  include PortalAlumnos

  #
  # Acción principal que mostrará la lista de inscripciones que el alumno tenga registrados en el sistema.
  #
  def index
    info_alumno
    begin
      @consulta_examenes = ConsultaExamenesClass.new(current_user)
    rescue Exception => mensaje
      @mensaje = mensaje
    end
  end

  # Acción que muestra el horario del calendario de exámenes según la inscripción que el alumno haya seleccionado.
  #
  # Se toma este nombre porque hace alusión al método ''show'' del resorces de rails, pues el objeto es mostrar el contenido
  # de los horarios para el calendario de exámenes dado un identificador, además de que es llamado desde javascript y éste
  # está enviando el parámetro en formato ''json''. El Método show no recebe el parámetro bajo este formato.
  def shows
    info_alumno
    begin
      @user = current_user
      @examenes = ExamenesModule::load_examenes(@user, params[:inscripcion_id])
    rescue Exception => mensaje
      @mensaje = mensaje
    end

    render :partial => 'examenes_partial'
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
