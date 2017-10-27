Pod::Spec.new do |s|
  s.name         = "AeroGearCrypto"
  s.version      = "1.0.0"
  s.summary      = "Provides encryption utilities."
  s.homepage     = "https://github.com/aerogear/aerogear-ios-crypto"
  s.license      = 'Apache License, Version 2.0'
  s.author       = "Red Hat, Inc."
  s.source       = { :git => 'https://github.com/aerogear/aerogear-ios-crypto.git', :tag => s.version }
  s.platform     = :ios, 9.0
  s.source_files = 'AeroGearCrypto/**/*.{h,m}'
  s.public_header_files = 'AeroGearCrypto/AeroGearCrypto.h', 'AeroGearCrypto/AGPBKDF2.h', 'AeroGearCrypto/AGRandomGenerator.h', 'AeroGearCrypto/AGSecretBox.h', 'AeroGearCrypto/AGCryptoBox.h', 'AeroGearCrypto/AGHash.h', 'AeroGearCrypto/AGSigningKey.h', 'AeroGearCrypto/AGVerifyKey.h', 'AeroGearCrypto/AGVerifyKey.h', 'AeroGearCrypto/AGKeyPair.h', 'AeroGearCrypto/AGUtil.h'
  s.requires_arc = true
  s.dependency 'libsodium', '~> 1.0'
end
