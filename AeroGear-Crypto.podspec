#
# JBoss, Home of Professional Open Source
# Copyright Red Hat, Inc., and individual contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
Pod::Spec.new do |s|
  s.name         = "AeroGear-Crypto"
  s.version      = "1.0.0.M1.20131031"
  s.summary      = "Provides encryption utilities."
  s.homepage     = "https://github.com/aerogear/aerogear-crypto-ios"
  s.license      = 'Apache License, Version 2.0'
  s.author       = "Red Hat, Inc."
  s.source       = { :git => 'https://github.com/aerogear/aerogear-crypto-ios.git', :tag => '1.0.0.M1.20131031' }
  s.platform     = :ios, 5.0
  s.source_files = 'crypto-sdk/**/*.{h,m}'
  s.public_header_files = 'crypto-sdk/AeroGearCrypto.h', 'crypto-sdk/AGPBKDF2.h', 'crypto-sdk/AGRandomGenerator.h', 'crypto-sdk/AGCryptoBox.h'
  s.requires_arc = true
end
