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
#import <libsodium-ios/sodium/crypto_secretbox_xsalsa20poly1305.h>

/**
 * Main class for performing encrypt/decrypt operations. Currently it only supports symmetric
 * key encryption but asymmetric support is currently in the works.
 */
@interface AGSecretBox : NSObject

/**
 * Default initializer.
 *
 * @param key The encryption key to use for the encryption/decryption.
 *
 * @return the AGSecretBox object.
 */
- (id)initWithKey:(NSData *)key;

/**
 * Encrypts the data object passed in.
 *
 * @param nonce the cryptographically secure pseudorandom number
 * @param message to be encrypted
*
 * @return An NSData object that holds the encrypted(cipher) data.
 */
- (NSData *)encrypt:(NSData *)nonce msg:(NSData *)message;

/**
 * Decrypts the data object(cipher) passed in.
 *
 * @param nonce the cryptographically secure pseudorandom number
 * @param ciphertext to be decrypted
 *
 * @return An NSData object that holds the decrypted data.
 */
- (NSData *)decrypt:(NSData *)nonce msg:(NSData *)ciphertext;

@end
