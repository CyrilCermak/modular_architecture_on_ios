require 'cocoapods'
require 'set'

$linkedPods = Set.new

Lib = Struct.new(:name, :version, :is_static)

$snapKit = Lib.new("SnapKit", "5.0.0")
$siren = Lib.new("Siren", "5.8.1")
$lottie = Lib.new("lottie-ios", "3.1.2")
$trustKit = Lib.new("TrustKit", "1.7.0")

### Required libraries
$uicomponents_libs = $snapKit, $siren, $lottie
$network_libs = [$trustKit]

### Project paths
$cosmonautservic_project_path = '../../service/CosmonautService/CosmonautService.xcodeproj'
$uicomponents_project_path = '../../core/UIComponents/UIComponents.xcodeproj'
$network_project_path = '../../core/Network/Network.xcodeproj'

$projects = [
  $cosmonautservic_project_path,
  $uicomponents_project_path,
  $network_project_path,
]
### Service
def cosmonautservice_sdk
  target_name = 'ISSCosmonautService'
  install target_name, $cosmonautservic_project_path, []
  install_subdependencies $cosmonautservic_project_path, target_name, []
end

### Core
def uicomponents_sdk
  install 'ISSUIComponents', $uicomponents_project_path, $uicomponents_libs
end

def network_sdk
  install "ISSNetwork", $network_project_path, $network_libs
end

# Helper wrapper around Cocoapods installation
def install target_name, project_path, linked_libs
  target target_name do 
    project project_path
    
    link linked_libs
  end
end

# Helper method to install Pods that 
# track the overall linked pods in the linkedPods set 
def link libs
  libs.each do |lib|
    p lib
    pod lib.name, lib.version
    $linkedPods << lib
  end
end

# Helper method called from the App target to install 
# dynamic libraries, as they must be copied to the target
# without that the app would be crashing on start
def add_linked_libs_from_sdks_to_app
  $linkedPods.each do |lib|
    next if lib.is_static
    pod lib.name, lib.version
  end
end

# Maps the list of dependencies from YAML files to the global variables defined on top of the File
# e.g ISSUIComponents.framework found in subdependencies will get mapped to the uicomponents_libs.
# From all dependencies found a Set of desired libraries is taken and installed
def install_subdependencies project_path, target_name, found_subdependencies
  subdependencies = find_subdependencies project_path, target_name, found_subdependencies
  list = subdependencies.map { |name| "#{name.gsub(".framework", "").gsub("ISS", "")}_libs".downcase }
  list_variables = list.filter_map { |name| eval("$#{name}") }
  
  p list_variables
end

# Finds recursively the dependencies of a project defined in the project.yml File
# of that project.
# Returns an array of found dependencies e.g [ISSNetwork.framework, UIComponents.framework]
def find_subdependencies project_path, target_name, found_subdependencies
  project_yml_path = project_path.split("/")
  project_yml_path = project_yml_path[0...project_yml_path.length-1].join("/")
  yaml = YAML.load_file("#{project_yml_path}/project.yml")
  dependencies = yaml["targets"][target_name]["dependencies"]
  
  # End of Recursion
  return found_subdependencies unless dependencies
  
  linked_frameworks = dependencies.map { |t| t["framework"]}.filter { |f| f.start_with? "ISS" }
  linked_frameworks.each do |framework|
    name = framework.gsub(".framework", "").gsub("ISS", "")
    dependency_path = $projects.detect { |project| project.include? name }
    
    # Recursion starts
    if dependency_path
      found_subdependencies << name
      find_subdependencies dependency_path, "ISS#{name}", found_subdependencies
    end
  end
end