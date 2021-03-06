class Document
  include RbConfig
  def self.generate_report(xml_data, report_design, output_type, select_criteria)
    report_design << '.jasper' if !report_design.match(/\.jasper\Z/)
    interface_classpath=Dir.getwd+"/app/jasper/bin"
    case CONFIG['host']
    when /mswin32/
      mode = "w+" #windows requires binary mode
      Dir.foreach(Dir.getwd+"/app/jasper/lib") do |file|
        interface_classpath << ";#{Dir.getwd}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
      end
    else
      mode = "w+"
      Dir.foreach(Dir.getwd+"/app/jasper/lib") do |file|
        interface_classpath << ":#{Dir.getwd}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
      end
    end
		result=nil
		IO.popen "java -Djava.awt.headless=true -cp \"#{interface_classpath}\" XmlJasperInterface -o#{output_type} -f#{Dir.getwd}/app/reports/#{report_design} -x#{select_criteria}", mode do |pipe|
			pipe.write xml_data
			pipe.close_write
			result = pipe.read
			pipe.close
		end
    return result
  end
end
