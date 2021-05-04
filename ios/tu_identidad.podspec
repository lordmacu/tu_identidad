#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tu_identidad.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tu_identidad'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source           = { :branch => 'master', :git => 'https://github.com/tu-identidad/tu-identidad-ios-sdk.git'}
  s.source_files = 'Classes/**/*'

  s.dependency 'Flutter'
  s.dependency 'TuIdentidadSDK', '~>1.1.5'
  s.dependency 'TuIdentidadSDK/AddressKit', '~>1.1.5'

  s.ios.deployment_target = '10.0'
  s.platform = :ios, '10.0'
  s.swift_version = '5.0'


  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
