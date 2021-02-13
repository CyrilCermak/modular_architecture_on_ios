require 'cocoapods'
require 'set'

$linkedPods = Set.new

Lib = Struct.new(:name, :version, :is_static)

$snapKit = Lib.new("SnapKit", "5.0.0")
$siren = Lib.new("Siren", "5.8.1")

def uicomponents_sdk
  target 'ISSUIComponents' do 
    project '../../core/UIComponents/UIComponents.xcodeproj'    
    
    link $snapKit
  end
end

# Helper method to install Pods that 
# track the overall linked pods in the linkedPods set 
def link *libs
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
    next if lib.is_static
    pod lib.name, lib.version
  end
end