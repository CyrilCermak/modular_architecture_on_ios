require 'fileutils'

class ProjectFactory
  
  def initialize project_name, destination_path
    @project_name = project_name
    @destination_path = destination_path
  end
  
  # Makes new app from the pre-defined template
  def make_new_app
    # App paths
    app_path = "#{@destination_path}/#{@project_name}/"
    app_tests_path = "#{@destination_path}/#{@project_name}Tests/"
    app_uitests_path = "#{@destination_path}/#{@project_name}UITests/"
    
    # Template paths
    current_dir_name = File.dirname(__FILE__)
    template_path = "#{current_dir_name}/template/Template/"
    template_tests_path = "#{current_dir_name}/template/TemplateTests/"
    template_uitests_path = "#{current_dir_name}/template/TemplateUITests/"
    
    # Create folder structure
    [app_path, app_tests_path, app_uitests_path].each { |path| FileUtils.mkdir_p path }
    
    # Copy app's template files
    ["Assets.xcassets", "Base.lproj", 'Info.plist'].each do |entry|
      FileUtils.cp_r "#{template_path}#{entry}", "#{app_path}/#{entry}"
    end
    
    # Copy Info.plist for targets
    FileUtils.cp "#{template_tests_path}/Info.plist", "#{app_tests_path}/Info.plist"
    FileUtils.cp "#{template_uitests_path}/Info.plist", "#{app_uitests_path}/Info.plist"
    
    # Generate essential files for the app and its tests from the template
    substitute_name_and_copy "#{template_path}AppDelegate.swift", "#{app_path}/AppDelegate.swift"
    substitute_name_and_copy "#{template_path}SceneDelegate.swift", "#{app_path}/SceneDelegate.swift"
    substitute_name_and_copy "#{template_path}../project.yml", "#{app_path}../project.yml"
    substitute_name_and_copy "#{template_tests_path}TemplateTests.swift", "#{app_tests_path}/#{@project_name}Tests.swift"
    substitute_name_and_copy "#{template_uitests_path}TemplateUITests.swift", "#{app_uitests_path}/#{@project_name}UITests.swift"
  end
  
  # Makes new framework from the pre-defined template
  def make_new_framework
    # To avoid conflicts it is better to prefix locally developed frameworks 
    # the template already has prefix fixed within
    prefix = "ISS"
    # Framework paths
    fw_path = "#{@destination_path}/#{@project_name}/"
    fw_tests_path = "#{@destination_path}/#{@project_name}Tests/"
    
    # Template paths
    current_dir_name = File.dirname(__FILE__)
    template_path = "#{current_dir_name}/template_fw/Template/"
    template_tests_path = "#{current_dir_name}/template_fw/TemplateTests/"
    
    # Create folder structure
    [fw_path, fw_tests_path].each { |path| FileUtils.mkdir_p path }
    
    # Generate essential files for the framework and its tests from the template
    substitute_name_and_copy "#{template_path}/Template.h", "#{fw_path}/#{prefix}#{@project_name}.h"
    FileUtils.cp "#{template_path}/Info.plist", "#{fw_path}/Info.plist"
    
    substitute_name_and_copy "#{template_tests_path}/TemplateTests.swift", "#{fw_tests_path}/#{@project_name}Tests.swift"
    FileUtils.cp "#{template_tests_path}/Info.plist", "#{fw_tests_path}/Info.plist"
    
    substitute_name_and_copy "#{template_path}/../project.yml", "#{fw_path}/../project.yml"
  end
  
  private
  
  def substitute_name_and_copy file_path, destination
    file = File.read file_path
    substituted_file = file.gsub "**NAME**", @project_name
    File.open(destination, "w") { |f| f.puts substituted_file }
  end
  
end