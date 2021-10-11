platform :ios, '14.5'
inhibit_all_warnings!
use_frameworks!

def shared_pods
  pod 'Alamofire', '~> 5.4'
  pod 'SDWebImage', '~> 5.0', :modular_headers => true
end

abstract_target 'App' do
    shared_pods
    target 'MusicPlayer'
    
    abstract_target 'TestGroup' do
        target 'MusicPlayerTests'
    end
end

