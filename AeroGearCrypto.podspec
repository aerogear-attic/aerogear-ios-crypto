Pod::Spec.new do |s|
  s.name         = "AeroGearCrypto"
  s.version      = "0.2.3"
  s.summary      = "Provides encryption utilities."
  s.homepage     = "https://github.com/aerogear/aerogear-ios-crypto"
  s.license      = 'Apache License, Version 2.0'
  s.author       = "Red Hat, Inc."
  s.source       = { :git => 'https://github.com/aerogear/aerogear-ios-crypto.git', :tag => '0.2.3' }
  s.platform     = :ios, 9.0
  s.source_files = 'AeroGearCrypto/**/*.{h,m}'
  s.public_header_files = 'AeroGearCrypto/AeroGearCrypto.h', 'AeroGearCrypto/AGPBKDF2.h', 'AeroGearCrypto/AGRandomGenerator.h', 'AeroGearCrypto/AGSecretBox.h', 'AeroGearCrypto/AGCryptoBox.h', 'AeroGearCrypto/AGHash.h', 'AeroGearCrypto/AGSigningKey.h', 'AeroGearCrypto/AGVerifyKey.h', 'AeroGearCrypto/AGVerifyKey.h', 'AeroGearCrypto/AGKeyPair.h', 'AeroGearCrypto/AGUtil.h'
  s.requires_arc = true
  s.dependency 'libsodium-ios', '~> 0.4.5'
end
