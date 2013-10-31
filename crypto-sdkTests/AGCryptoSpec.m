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

#import <Kiwi/Kiwi.h>
#import "AGCryptoBox.h"
#import "AGRandomGenerator.h"
#import "AGPBKDF2.h"

SPEC_BEGIN(AGCryptoBoxSpec)

describe(@"CryptoBox", ^{
    context(@"when newly created", ^{
        __block AGCryptoBox* cryptoBox = nil;
        __block NSData *encryptionSalt = nil;
        
        beforeEach(^{
            AGPBKDF2 *keyGenerator = [[AGPBKDF2 alloc] init];
            
            encryptionSalt = [AGRandomGenerator randomBytes:16];
            cryptoBox = [[AGCryptoBox alloc] initWithKey:[keyGenerator deriveKey:@"123456" salt:encryptionSalt]];
        });
        
        it(@"it should not be nil", ^{
            [[cryptoBox shouldNot] beNil];
        });
        
        context(@"should correctly encrypt/decrypt honouring kCCOptionPKCS7Padding" , ^{
            it(@"should return identical encrypted/decrypted data when 16 characters", ^{
                NSString* stringToEncrypt = @"0123456789abcdef";
                NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
                
                // encrypt
                NSData* encryptedData = [cryptoBox encrypt:dataToEncrypt IV:encryptionSalt];
                [encryptedData shouldNotBeNil];
                
                // decrypt
                NSData* decryptedData = [cryptoBox decrypt:encryptedData IV:encryptionSalt];
                [decryptedData shouldNotBeNil];
                
                // should match
                NSString* decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                [[@"0123456789abcdef" should] equal:decryptedString];
            });
            
            it(@"should return identical encrypted/decrypted data when less than 16 chars", ^{
                NSString* stringToEncrypt = @"0123456789abcde";
                NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
                
                // encrypt
                NSData* encryptedData = [cryptoBox encrypt:dataToEncrypt IV:encryptionSalt];
                [encryptedData shouldNotBeNil];
                
                // decrypt
                NSData* decryptedData = [cryptoBox decrypt:encryptedData IV:encryptionSalt];
                [decryptedData shouldNotBeNil];
                
                // should match
                NSString* decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                [[@"0123456789abcde" should] equal:decryptedString];
            });
            
            it(@"should return identical encrypted/decrypted data when data to encrypt is more than 16 chars", ^{
                NSString* stringToEncrypt = @"0123456789abcdef1234";
                NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];

                // encrypt
                NSData* encryptedData = [cryptoBox encrypt:dataToEncrypt IV:encryptionSalt];
                [encryptedData shouldNotBeNil];
                
                // decrypt
                NSData* decryptedData = [cryptoBox decrypt:encryptedData IV:encryptionSalt];
                [decryptedData shouldNotBeNil];
                
                // should match
                NSString* decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                [[@"0123456789abcdef1234" should] equal:decryptedString];
            });
        });
        
        context(@"should fail with corrupted crypto params", ^{
            it(@"should fail to decrypt with corrupted IV", ^{
                NSString* stringToEncrypt = @"0123456789abcdef1234";
                NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
                
                NSData* encryptedData = [cryptoBox encrypt:dataToEncrypt IV:encryptionSalt];
                // corrupt IV
                NSMutableData *mutEncryptionSalt = [encryptionSalt mutableCopy];
                [mutEncryptionSalt replaceBytesInRange:NSMakeRange(1, 1)
                                             withBytes:[[@" " dataUsingEncoding:NSUTF8StringEncoding] bytes]];

                // try to decrypt
                NSData* decryptedData = [cryptoBox decrypt:encryptedData IV:mutEncryptionSalt];
                NSString* decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];

                // should fail
                [[@"0123456789abcdef1234" shouldNot] equal:decryptedString];
            });
            
            it(@"should fail to decrypt with corrupted ciphertext", ^{
                NSString* stringToEncrypt = @"0123456789abcdef1234";
                NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
                
                NSData* encryptedData = [cryptoBox encrypt:dataToEncrypt IV:encryptionSalt];
                // corrupt cipher
                NSMutableData *mutEncryptedData = [encryptedData mutableCopy];
                [mutEncryptedData replaceBytesInRange:NSMakeRange(1, 1)
                                            withBytes:[[@" " dataUsingEncoding:NSUTF8StringEncoding] bytes]];
                // try to decrypt
                NSData* decryptedData = [cryptoBox decrypt:mutEncryptedData IV:encryptionSalt];
                NSString* decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                
                // should fail
                [decryptedString shouldBeNil];
            });
        });
    });
});

SPEC_END