source 'https://github.com/wangjianglin/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

workspace 'swift.xcworkspace'

project 'rac/LinRac.xcodeproj'

platform:ios,'8.0'

target :'LinRac' do
#    platform:ios,'8.0'
    #指定podspec文件
    #    pod 'LinUtil.swift', :podspec => "/lin/code/lib/Specs/LinUtil.swift/0.0.0/LinUtil.swift.podspec"
    #
    #    pod 'LinComm.swift', :podspec => "/lin/code/lib/Specs/LinComm.swift/0.0.0/LinComm.swift.podspec"
    #
    #    pod 'LinCore.swift', :podspec => "/lin/code/lib/Specs/LinCore.swift/0.0.0/LinCore.swift.podspec"
    
    #    pod 'LinUtil.swift', '0.0.3'
    #    pod 'LinComm.swift', '0.0.3'
    #    pod 'LinCore.swift', '0.0.3'
    #    pod 'ReactiveCocoa',:git=>'https://github.com/ReactiveCocoa/ReactiveCocoa.git'
#    pod 'ReactiveCocoa','5.0.0'
    pod 'ReactiveCocoa', '~> 5.0.0'
    #pod 'ReactiveCocoa',:git=>'https://github.com/ReactiveCocoa/ReactiveCocoa.git'
   pod 'GPUImage',:git=>'https://github.com/BradLarson/GPUImage.git'
   pod 'SVProgressHUD',:git=>'https://github.com/SVProgressHUD/SVProgressHUD'
    project 'rac/LinRac.xcodeproj'
end

#workspace 'swift.xcworkspace'
#xcodeproj 'demo/demo.xcodeproj'
#platform:ios,'8.0'
#
target :'demo' do
#    pod 'ReactiveCocoa','5.0.0'
    pod 'ReactiveCocoa', '~> 5.0.0'

#    pod 'ReactiveCocoa',:git=>'https://github.com/ReactiveCocoa/ReactiveCocoa.git'
    project 'demo/demo.xcodeproj'
end


post_install do |installer|
    
    puts installer.pods_project.targets.class
    puts installer.pods_project.targets[1]

    installer.pods_project.targets.each do |target|
        
        if "#{target}" != 'ReactiveCocoa' and
            "#{target}" != 'ReactiveSwift'
            next;
        end
        
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0.1'
        end
    end
end