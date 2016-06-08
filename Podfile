#workspace 'AntenatalTrainingWorkSpace'
#xcodeproj 'AntenatalTraining.xcodeproj'



platform :ios, '8.0'

target 'AntenatalTraining' do

use_frameworks!
inhibit_all_warnings!

pod 'TCBlobDownload', '~> 2.1.1'
pod 'StreamingKit', '~> 0.1.29'
pod 'UIImage-ResizeMagick', '~> 0.0.1'
pod 'DoActionSheet', '~> 1.0'
pod 'FastImageCache', :git => 'https://github.com/mojun/FastImageCache.git'
pod 'FMDB', :git => 'https://github.com/mojun/fmdb.git'
pod 'FCFileManager', '~>1.0.17'
pod 'MMTransitionAnimator'
pod 'SVProgressHUD'
pod 'Aspects'
pod 'Masonry'
pod 'SDCycleScrollView'
pod 'TYMProgressBarView'
pod 'RealReachability'
#pod 'MKInputBoxView'
#pod update --verbose --no-repo-update

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end