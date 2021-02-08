require 'cocoapods'
require 'set'

$linkedPods = Set.new

Lib = Struct.new(:name, :version, :is_static)

$snapKit = Lib.new("SnapKit", "5.0.0")
$siren = Lib.new("Siren", "5.8.1")

def uicomponents_sdk
  target 'ISSUIComponents' do 
    project '../../core/UIComponents/UIComponents.xcodeproj'
    pod $snapKit.name, $snapKit.version
  end
end