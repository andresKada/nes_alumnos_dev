class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
   

    if @user_session.save
      current_user_session_role = (UserSession.find).user.role_id
      if [1,2,3].include? current_user_session_role
        flash[:error] = " Nombre de Usuario y/o Contraseña inválidos. Inténtelo nuevamente"
        redirect_to :action => :destroy
      else
        current_user_session_id = (UserSession.find).user.id
        @alumno = Alumno.where("user_id = ?",current_user_session_id).first
        
        if @alumno.blank? 
          flash[:error] = "El usuario no existe en la tabla alumnos"
          redirect_to :action => :destroy
        else
          flash[:info] = ['¡Bienvenido!', 'Has iniciado sesión en el portal de Alumnos']
          redirect_back_or_default "/home#index"
        end
        
      end
    else
      render :action => :new
    end
  end
  

  def destroy
    current_user_session.destroy
    flash[:notice] = "Cierre de sesión satisfactoria"
    redirect_back_or_default new_user_session_url
  end
end
