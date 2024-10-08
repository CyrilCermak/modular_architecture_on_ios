require 'cocoapods'
require 'set'

Lib = Struct.new(:name, :version, :is_static)
$linkedPods = Set.new


### available libraries within the whole Application Framework
$snapKit = Lib.new("SnapKit", "5.0.0")
$siren = Lib.new("Siren", "5.8.1")
$lottie = Lib.new("lottie-ios", "3.1.2")
$trustKit = Lib.new("TrustKit", "1.7.0")

### Project paths with required libraries

# Domains
$scaffold_project_path = '../../domain/Scaffold/Scaffold.xcodeproj'
$spacesuit_project_path = '../../domain/Spacesuit/Spacesuit.xcodeproj'
$cosmonaut_project_path = '../../domain/Cosmonaut/Cosmonaut.xcodeproj'
# Service
$cosmonautservic_project_path = '../../service/CosmonautService/CosmonautService.xcodeproj'
$spacesuitservic_project_path = '../../service/SpacesuitService/SpacesuitService.xcodeproj'
$overviewservic_project_path = '../../service/OverviewService/OverviewService.xcodeproj'
# Core
$uicomponents_project_path = '../../core/UIComponents/UIComponents.xcodeproj'

$network_project_path = '../../core/Network/Network.xcodeproj'

$radio_project_path = '../../core/Radio/Radio.xcodeproj'
$persistence_project_path = '../../core/Persistence/Persistence.xcodeproj'

# Linked libraries
$uicomponents_libs = [$snapKit, $siren, $lottie]
$network_libs = [$trustKit]
$cosmonaut_libs = [$snapKit]
$spacesuit_libs = [$snapKit]

# Helper variable for scripting to determine target's project
$projects = [
  $scaffold_project_path,
  $spacesuit_project_path,
  $cosmonaut_project_path,
  
  $cosmonautservic_project_path,
  $spacesuitservic_project_path,
  
  $uicomponents_project_path,
  $network_project_path,
  $radio_project_path,
  $persistence_project_path,
]

### Domain
def scaffold_sdk
  target_name = 'ISSScaffold'
  install target_name, $scaffold_project_path, []
end

def spacesuit_sdk
  target_name = 'ISSSpacesuit'
  install target_name, $spacesuit_project_path, $spacesuit_libs
end

def cosmonaut_sdk
  target_name = 'ISSCosmonaut'
  test_target_name = 'CosmonautTests'
  install target_name, $cosmonaut_project_path, $cosmonaut_libs
  
  install_test_subdependencies $cosmonaut_project_path, target_name, test_target_name, []
end

### Service
def spacesuitservice_sdk
  target_name = 'ISSSpacesuitService'
  install target_name, $spacesuitservic_project_path, []
end

def cosmonautservice_sdk
  target_name = 'ISSCosmonautService'
  install target_name, $cosmonautservic_project_path, []
end

def overviewservice_sdk
  target_name = 'ISSOverviewService'
  install target_name, $overviewservic_project_path, []
end

### Core
def uicomponents_sdk
  target_name = 'ISSUIComponents'
  install target_name, $uicomponents_project_path, $uicomponents_libs
end

def network_sdk
  target_name = 'ISSNetwork'
  install target_name, $network_project_path, $network_libs
end

def radio_sdk
  target_name = 'ISSRadio'
  install target_name, $radio_project_path, []
end

def persistence_sdk
  target_name = 'ISSPersistence'
  install target_name, $persistence_project_path, []
end

# Helper wrapper around Cocoapods installation
def install target_name, project_path, linked_libs
  target target_name do 
    use_frameworks!
    project project_path
    
    link linked_libs
  end
end

# Helper method to install Pods that 
# track the overall linked pods in the linkedPods set 
def link libs
  libs.each do |lib|
    pod lib.name, lib.version
    $linkedPods << lib
  end
end

# Helper method called from the App target to install 
# dynamic libraries, as they must be copied to the target
# without that the app would be crashing on start
def add_linked_libs_from_sdks_to_app
  $linkedPods.each do |lib|
    puts "Installing #{lib.name}"
    next if lib.is_static
    pod lib.name, lib.version
  end
end

# Maps the list of dependencies from YAML files to the global variables defined on top of the File
# e.g ISSUIComponents.framework found in subdependencies will get mapped to the uicomponents_libs.
# From all dependencies found a Set of desired libraries is taken and installed
def install_test_subdependencies project_path, target_name, test_target_name, found_subdependencies
  subdependencies = find_subdependencies project_path, target_name, found_subdependencies
  list = subdependencies.map { |name| "#{name.gsub(".framework", "").gsub("ISS", "")}_libs".downcase }
  list_variables = list.filter_map { |name| eval("$#{name}") }.flatten
  
  # Installing test pods found within all subdependencies of the main testing target
  target test_target_name do 
    use_frameworks!
    
    project project_path
  
    link list_variables
  end
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
  
  linked_frameworks = dependencies.map { |t| t["framework"]}.compact.filter { |f| f.start_with? "ISS" }
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