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
#import <CommonCrypto/CommonCryptor.h>

/**
 * Class that handles AES symmetric encryption/decryption using the CommonCrypto API.
 *
 * Note: Currently the mode of operation used is CBC.
 * (see http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher-block_chaining_.28CBC.29)
 */
@interface AGSymmetricCryptoEngine : NSObject

/**
 * Initialize the symmetric crypto engine.
 *
 * @param operation Set to 'kCCEncrypt' for encryption, or 'kCCDecrypt' for decryption.
 * @param key The key to use for encrypt/decrypt.
 * @param IV  A randomly chosen value used as the initialization vector.
 * @param error An error object containing details of why the initialization failed.
 *
 * @return the AGSymmetricCryptoEngine object.
 */
- (id)initWithOperation:(CCOperation)operation key:(NSData *)key
                                                IV:(NSData *)IV
                                             error:(NSError **)error;

/**
 * Add new data to encrypt/decrypt. It can be invoked multiple times passing the new data.
 *
 * @param data  The data object to encrypt/decrypt.
 * @param error An error object containing details of why the encrypt/decrypt failed.
 *
 * @return An NSData object that holds the encrypted/decrypted data.
 */
- (NSData *)add:(NSData *)data error:(NSError **)error;

/**
 * Finalize the encrypt/decrypt process.
 *
 * Note: It SHOULD be called at the end to finalize the encrypt/decrypt process.
 *
 * @param error An error object containing details of why the encrypt/decrypt failed.
 *
 * @return An NSData object that holds the encrypted/decrypted data.
 */
- (NSData *)finish:(NSError **)error;

@end
