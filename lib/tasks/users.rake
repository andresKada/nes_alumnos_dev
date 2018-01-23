require 'tasks/miscelaneos'
namespace :users do

  desc "Crear cuentas de usuario para todos los alumnos inscritos que aún no tienen una cuenta"
  task :create_missing_users => :environment do 
    alumnos = Miscelaneos.get_actual_alumnos.select{|a| a.user.blank?}
    puts ""
    alumnos.each_with_index do |alumno, index|   
      print "\n #{index}.- " 
      u = Miscelaneos.create_alumno_user(alumno[:id], alumno[:curp], {})
    end
    puts '', '',  'FINALIZADO' , ''   
  end
  
  desc "Asignar a las cuentas de usuario para todos los alumnos inscritos el password por default"
  task :assign_default_password_users => :environment do 
    semestres = Semestr.where.not(clave: 1).pluck(:id)
    semestres = Semestr.all.pluck(:id)
    alumnos = Miscelaneos.get_actual_alumnos({semestre_id: semestres})
    failed =  Array.new
    alumnos.each do |alumno|
      def_password =  alumno.curp.to_s.strip.upcase
      def_login =  alumno.matricula.to_s.strip
      u = alumno.user
      if u.present?
        if u.update_attributes({login: def_login, password: def_password, password_confirmation: def_password})
          puts  "Actualizado:  #{alumno.curp} --- #{u.login}"
        else
          failed << " #{alumno.curp}"
        end
      end
    end
    puts '', 'Failed: ',  failed   if failed.present?
    puts '', '',  'FINALIZADO' , ''    
  end
  
  
  desc "Asignar la cuenta de usuario para el alumno inscrito"
  task :assign_default_user_to_alumno, [:curp, :force_create] => :environment do |t, args| 
    curp = args['curp'].upcase unless args['curp'].blank?
    force_create = !([nil, false, 'false', ''].include?(args['force_create']))
    if curp.present?
      alumnos = Array.new
      alumnos = Miscelaneos.get_actual_alumnos().where(curp: curp)
      failed =  Array.new
      alumnos.each do |alumno|
        if alumno.present?
          def_password =  alumno.curp.to_s.strip.upcase
          def_login =  alumno.matricula.to_s.strip
          u = alumno.user
          if u.present?
            if u.update_attributes({login: def_login, password: def_password, password_confirmation: def_password})
              puts  "Actualizado:  #{alumno.curp} --- #{u.login} - #{def_password}"
            else
              failed << " #{alumno.curp} error al actualizar"
            end
          elsif force_create 
            u = Miscelaneos.create_alumno_user(nil, alumno[:curp], {} )
            if u.present? && u.persisted?
              puts  "    Usuario Creado:  #{alumno.curp} --- #{u.login} - #{def_password} >  #{alumno.user_id}, #{u.id}"
            else
              failed << " #{alumno.curp} no pudo guardarse el usuario"
            end
          else
            failed << " #{alumno.curp} no tiene un usuario asignado"
          end
        else
          puts "", "Error, no se encuentra al alumno con la curp: #{curp}. "
        end
      end
    else
      puts "", "Error, no se encuentra la curp #{curp}. "
    end 
    puts '', 'Failed: ',  failed   if failed.present?
    puts '', '',  'FINALIZADO' , ''    
  end
  
  desc "Reporta el login y el email de las cuentas de usuario para todos los alumnos inscritos"
  task :report_users => :environment do 
    alumnos = Miscelaneos.get_actual_alumnos.select{|a| a.user.present?}
    alumnos.each_with_index do |alumno, index|   
      print "\n #{index + 1}.-  #{alumno.curp}   #{alumno.user.login}   #{alumno.user.email}" 
    end
    puts '', '',  'FINALIZADO' , ''      
  end
  
  
end

