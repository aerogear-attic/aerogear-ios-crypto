/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <libsodium-ios/sodium/crypto_sign_ed25519.h>
#import <libsodium-ios/sodium/randombytes.h>


@interface AGSigningKey : NSObject {
    const unsigned char secretKey[crypto_sign_ed25519_SECRETKEYBYTES];
    const unsigned char publicKey[crypto_sign_ed25519_PUBLICKEYBYTES];
}

- (NSData *)sign:(NSString *)message;
- (unsigned char)getPublicKey;

@end