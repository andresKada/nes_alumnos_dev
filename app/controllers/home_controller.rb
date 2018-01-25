class HomeController < ApplicationController
  before_filter :require_user

  def index
    @usuario = current_user  
    @periodo_actual = current_ciclo.ciclo
    @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == current_ciclo.id}
    user_data
  end
  
  def show_inscripciones
     @usuario = current_user
     @inscripciones = @usuario.alumno.inscripciones
     @inscripciones_agrupadas = @inscripciones.group_by { |inscripcion| inscripcion.semestr.clave_semestre  }
     user_data
  end
  
  def user_data
    @usuario = current_user  
    @periodo_actual = current_ciclo.ciclo
    ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
    @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
    @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last 
    @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
    @profesor =  @usuario.alumno.profesor || Profesor.new
  end    
  
end