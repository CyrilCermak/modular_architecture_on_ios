# SharedFastfile for Apps
# import into the apps Fastfile with import ../../fastlane/SharedFastfile.rb
# all lanes will be available to it since then

# Variable that points to the root of the project considering
# execution from the App's Fastfile
project_root = "../../../"

lane :generate do
  # Finding all projects within directories
  Dir["#{project_root}**/project.yml"].each do |project_path|
    # Skipping the template files
    next if project_path.include? "fastlane"
    
    UI.success "Generating project: #{project_path.gsub(project_root, "")}"
    `xcodegen -s #{project_path}`
  end 
end