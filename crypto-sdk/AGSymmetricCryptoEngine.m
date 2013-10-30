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

#import "AGSymmetricCryptoEngine.h"

NSString *const AGSymmetricCryptoErrorDomain = @"AGCryptoErrorDomain";

@implementation AGSymmetricCryptoEngine {
    CCCryptorRef _cryptor;
    NSMutableData *_buffer;
}

- (id)initWithOperation:(CCOperation)operation key:(NSData *)key
                     IV:(NSData *)IV
                  error:(NSError **)error {
    self = [super init];
    
    if (self) {
        CCCryptorStatus status = CCCryptorCreateWithMode(operation,
                                                         kCCModeCBC,
                                                         kCCAlgorithmAES128,
                                                         kCCOptionPKCS7Padding,
                                                         (const void *) [IV bytes],
                                                         (const void *) [key bytes],
                                                         kCCBlockSizeAES128,
                                                         NULL, // raw tweak material (unused)
                                                         0,    // tweakLength (unused)
                                                         0,    // The number of rounds of the cipher to use (unused)
                                                         0,    // A word of flags defining options (unused)
                                                         &_cryptor);
        
        if (status != kCCSuccess || _cryptor == NULL) {
            if (error) {
                *error = [NSError errorWithDomain:AGSymmetricCryptoErrorDomain code:status userInfo:nil];
            }
            
            self = nil;
            return nil;
        }
        
        _buffer = [NSMutableData data];
    }
    
    return self;
}

- (NSData *)add:(NSData *)data error:(NSError **)error {
    [_buffer setLength:CCCryptorGetOutputLength(_cryptor, [data length], true)];
    
    size_t length;
    CCCryptorStatus status = CCCryptorUpdate(_cryptor,
                                             (const void *) [data bytes],
                                             [data length],
                                             (void *) [_buffer mutableBytes],
                                             [_buffer length],
                                             &length);
    
    if (status != kCCSuccess) {
        if (error) {
            *error = [NSError errorWithDomain:AGSymmetricCryptoErrorDomain code:status userInfo:nil];
        }
        return nil;
    }
    
    return [_buffer subdataWithRange:NSMakeRange(0, length)];
}

- (NSData *)finish:(NSError **)error
{
    size_t length;
    
    CCCryptorStatus status = CCCryptorFinal(_cryptor,
                                            [_buffer mutableBytes],
                                            [_buffer length],
                                            &length);
    
    if (status != kCCSuccess) {
        if (error) {
            *error = [NSError errorWithDomain:AGSymmetricCryptoErrorDomain code:status userInfo:nil];
        }
        return nil;
    }
    
    return [_buffer subdataWithRange:NSMakeRange(0, length)];
}

@end
