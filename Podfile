xcodeproj 'crypto-sdk.xcodeproj'

platform :ios, '7.0'

pod 'libsodium-ios', '~> 0.4.5'

target 'crypto-sdkTests', :exclusive => true do
    # we need to rely on a specific commit on 'master' cause of kiwi bug: https://github.com/allending/Kiwi/pull/370
    # once kiwi 3.0 is released that will incorporate this fix, we should change to use it.
    pod 'Kiwi', :git => 'https://github.com/allending/Kiwi', :commit => '3267f9a'
end
