# Uncomment the next line to define a global platform for your project
platform :ios, '16.4'

# Map the custom "Staging" build configuration onto CocoaPods' :release behavior.
# Without this, `pod install` does not generate a Pods-pwa-shell.staging.xcconfig
# or wire up the [CP] script phases for Staging, producing a broken/unsigned
# embedded-frameworks layout that iOS refuses to install.
project 'pwa-shell.xcodeproj',
  'Debug'   => :debug,
  'Release' => :release,
  'Staging' => :release

target 'pwa-shell' do
  # Static linkage: Firebase compiles into the app binary.
  # No separate .framework bundles = no provisioning profile errors at export.
  use_frameworks! :linkage => :static

  # Add the pod for Firebase Cloud Messaging
  pod 'Firebase/Messaging'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.4'
    end
  end
end
