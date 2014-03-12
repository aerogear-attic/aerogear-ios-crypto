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

#import "AGSecretBox.h"
#import "AGUtil.h"

@implementation AGSecretBox {
    NSData *_key;
}

- (id)initWithKey:(NSData *)key {
    NSParameterAssert(key != nil && [key length] == crypto_secretbox_xsalsa20poly1305_KEYBYTES);
    
    self = [super init];
    if (self) {
        _key = key;
    }
    
    return self;
}

- (NSData *)encrypt:(NSData *)nonce msg:(NSData *)message {
    NSParameterAssert(nonce != nil && [nonce length] == crypto_secretbox_xsalsa20poly1305_NONCEBYTES);
    NSParameterAssert(message != nil);
    
    NSData *msg = [AGUtil prependZeros:crypto_secretbox_xsalsa20poly1305_ZEROBYTES msg:message];
    NSMutableData *ct = [[NSMutableData alloc] initWithLength:msg.length];
    
    int status = crypto_secretbox_xsalsa20poly1305(
                                                   [ct mutableBytes],
                                                   [msg bytes],
                                                   msg.length,
                                                   [nonce bytes],
                                                   [_key bytes]);
    
    NSAssert(status == 0, @"failed to encrypt data provided", status);
    
    
    return [ct subdataWithRange:NSMakeRange(crypto_secretbox_xsalsa20poly1305_BOXZEROBYTES,
                                            ct.length - crypto_secretbox_xsalsa20poly1305_BOXZEROBYTES)];
}

- (NSData *)decrypt:(NSData *)nonce msg:(NSData *)ciphertext {
    NSParameterAssert(nonce != nil && [nonce length] == crypto_secretbox_xsalsa20poly1305_NONCEBYTES);
    NSParameterAssert(ciphertext != nil);
    
    NSData *ct = [AGUtil prependZeros:crypto_secretbox_xsalsa20poly1305_BOXZEROBYTES msg:ciphertext];
    NSMutableData *message = [[NSMutableData alloc] initWithLength:ct.length];
    
    int status = crypto_secretbox_xsalsa20poly1305_open(
                                                        [message mutableBytes],
                                                        [ct bytes],
                                                        message.length,
                                                        [nonce bytes],
                                                        [_key bytes]);
    
    NSAssert(status == 0, @"failed to decrypt data provided", status);
    
    return [message subdataWithRange:NSMakeRange(crypto_secretbox_xsalsa20poly1305_ZEROBYTES,
                                                 message.length - crypto_secretbox_xsalsa20poly1305_ZEROBYTES)];
}

@end
