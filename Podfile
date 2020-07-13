platform :ios, '10.0'
inhibit_all_warnings!

target 'Audiometer' do
  use_frameworks!
  
  pod 'mobile-ffmpeg-audio', '4.2.2.LTS'
  pod 'AudioKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSwiftExt'
  pod 'RxOptional'
  pod 'RxDataSources'
  
  pod 'PinLayout', '~> 1.6.0'
  pod 'FlexLayout', '1.3.6'
  
  pod 'VerticalSteppedSlider'
  pod 'IQKeyboardManagerSwift', '6.0.1'
  pod 'LGButton'#, git: 'https://github.com/SergeyKachan/LGButton.git'
  pod 'Apollo', '0.19.1'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'EPSignature', git: 'https://github.com/imkhan334/EPSignature.git', branch: 'swift4-support'
  pod 'ActionSheetPicker-3.0'
  pod 'KeychainSwift'
  pod 'Charts'
  pod 'BEMCheckBox'
  pod "WARangeSlider"

  pod 'Firebase/Crashlytics'


  pod 'AgoraRtcEngine_iOS_Crypto'
  pod 'AgoraRtm_iOS'

end

swift4 = ['EPSignature','VerticalSteppedSlider','IQKeyboardManagerSwift','RxCocoa','LGButton']

post_install do |installer|
  installer.pods_project.targets.each do |target|
    swift_version = nil


    if swift4.include?(target.name)
      swift_version = '4.0'
    end

    if swift_version
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = swift_version
      end
    end
  end
end
