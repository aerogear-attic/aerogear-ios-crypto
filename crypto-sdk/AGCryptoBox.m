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

#import "AGCryptoBox.h"
#import "AGUtil.h"

@implementation AGCryptoBox {

}

- (id)initWithKey:(NSData *)publicKey privateKey:(NSData *)privateKey {
    self = [super init];
    if (self) {
        [AGUtil checkLength:privateKey size:crypto_box_curve25519xsalsa20poly1305_SECRETKEYBYTES];
        [AGUtil checkLength:publicKey size:crypto_box_curve25519xsalsa20poly1305_PUBLICKEYBYTES];
        _privateKey = privateKey;
        _publicKey = publicKey;
    }
    return self;
}

- (NSData *)encrypt:(NSData *)nonce msg:(NSData *)message {
    //Create a buffer to store the ciphertext
    [AGUtil checkLength:nonce size:crypto_box_curve25519xsalsa20poly1305_NONCEBYTES];

    NSMutableData *msg = [AGUtil prependZeros:crypto_box_curve25519xsalsa20poly1305_ZEROBYTES];
    [msg appendData:message];
    NSData *ct = [AGUtil prependZeros:msg.length];

    if ( crypto_box_curve25519xsalsa20poly1305(
            (unsigned char *)[ct bytes],
            (unsigned char *)[msg bytes],
            msg.length,
            (unsigned char *)[nonce bytes],
            (unsigned char *)[_publicKey bytes],
            (unsigned char *)[_privateKey bytes]) != 0 ) {
        NSLog(@"Failed to encrypt data provided");
    }

    NSData *data = [ct subdataWithRange:NSMakeRange(crypto_box_curve25519xsalsa20poly1305_BOXZEROBYTES,
            ct.length - crypto_box_curve25519xsalsa20poly1305_BOXZEROBYTES)];

    return data;
}

- (NSData *)decrypt:(NSData *)nonce msg:(NSData *)ciphertext {

    [AGUtil checkLength:nonce size:crypto_box_curve25519xsalsa20poly1305_NONCEBYTES];

    NSMutableData *ct = [AGUtil prependZeros:crypto_box_curve25519xsalsa20poly1305_BOXZEROBYTES];
    [ct appendData:ciphertext];

    NSData *message = [AGUtil prependZeros:ct.length];

    if ( crypto_box_curve25519xsalsa20poly1305_open(
            (unsigned char *)[message bytes],
            (unsigned char *)[ct bytes],
            message.length,
            (unsigned char *)[nonce bytes],
            (unsigned char *)[_publicKey bytes],
            (unsigned char *)[_privateKey bytes]) != 0 ) {
        NSLog(@"Failed to decrypt data provided");
    }
    NSData *data = [message subdataWithRange:NSMakeRange(crypto_box_curve25519xsalsa20poly1305_ZEROBYTES,
           message.length - crypto_box_curve25519xsalsa20poly1305_ZEROBYTES)];
    return data;

}
@end