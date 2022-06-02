platform :ios, '12.0'
inhibit_all_warnings!
use_frameworks!

def main_pods
 pod 'pop'
 pod 'BonMot'
 pod 'SwiftyStoreKit'
 pod 'OneSignal', '>= 2.11.2', '< 3.0'
end

def snapchat_pod
 pod 'SnapSDK', :subspecs => ['SCSDKCreativeKit']
end

target 'looksee' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for looksee
  main_pods
  snapchat_pod

end

target 'OneSignalNotificationServiceExtension' do
  pod 'OneSignal', '>= 2.11.2', '< 3.0'
end
