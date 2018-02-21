#
# Be sure to run `pod lib lint NRLocationManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'NRLocationManager'
s.version          = '1.0.1'
s.summary          = 'This class is used to provide a location updates via completion handler.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
NRLocationManager: This class is used to provide a location updates via completion handler.Some of the main features this library provide are:
* One time Location
* Continous Location
* Significant Location
* Check System location is on/off.

DESC

s.homepage         = 'https://github.com/naveenrana1309/NRLocationManager'
s.screenshots     = 'https://cdn.rawgit.com/naveenrana1309/NRLocationManager/master/Example/sample.png'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'naveenrana1309' => 'naveenrana1309@gmail.com' }
s.source           = { :git => 'https://github.com/naveenrana1309/NRLocationManager.git', :tag => s.version.to_s }

#s.social_media_url = 'https://www.facebook.com/naveen.rana.146'

s.ios.deployment_target = '10.0'

s.source_files = 'NRLocationManager/Classes/**/*'

# s.resource_bundles = {
#   'NRLocationManager' => ['NRLocationManager/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'

end

