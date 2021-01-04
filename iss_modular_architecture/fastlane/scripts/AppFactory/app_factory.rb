class AppFactory
  
  def initialize app_name, destination_path
    @app_name = app_name
    @destination_path = destination_path
  end
  
  private 
  def make_new_app name, destination
    # App paths
    app_path = "#{destination}/#{name}/"
    app_tests_path = "#{destination}/#{name}Tests/"
    app_uitests_path = "#{destination}/#{name}UITests/"
    
    # Template paths
    template_path = "template/Template/"
    template_tests_path = "template/TemplateTests/"
    template_uitests_path = "template/TemplateUITests/"
    
    # Create folder structure
    [app_path, app_tests_path, app_uitests_path].each { |path| Dir.mkdir path }
    
    # Copy app's template files
    ["Assets.xcassets", "Base.lproj", "Info.plist"].each do |entry|
      FileUtils.copy_entry "template/Template/#{entry}", app_path
    end
    
    # Copy Info.plist for test targets
    File.cp "#{template_tests_path}/Info.plist", "#{app_tests_path}/Info.plist"
    File.cp "#{template_uitests_path}/Info.plist", "#{app_uitests_path}/Info.plist"
    
    # Generate essential files for the app
    substitute_name_and_copy "#{template_path}AppDelegate.swift", "#{app_path}/AppDelegate.swift"
    substitute_name_and_copy "#{template_path}SceneDelegate.swift", "#{app_path}/SceneDelegate.swift"
    substitute_name_and_copy "#{template_tests_path}TemplateTests.swift", "#{app_tests_path}/#{name}Tests.swift"
    substitute_name_and_copy "#{template_uitests_path}TemplateUITests.swift", "#{app_uitests_path}/#{name}UITests.swift"
    substitute_name_and_copy "template/project.yml", "#{app_path}../project.yml"
  end
  
  def substitute_name_and_copy file_path, destination
    file = File.open file_path, "r"
    file.gsub "**NAME**", name
    File.open(destination, "w") { |f| f.puts file }
  end
  
end