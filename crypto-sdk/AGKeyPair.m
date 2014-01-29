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

#import "AGKeyPair.h"
#include "crypto_box_curve25519xsalsa20poly1305.h"


@implementation AGKeyPair {

}

- (id)init {
    self = [super init];

    if (self) {

        unsigned char cpublicKey[crypto_box_curve25519xsalsa20poly1305_PUBLICKEYBYTES];
        unsigned char csecretKey[crypto_box_curve25519xsalsa20poly1305_SECRETKEYBYTES];

        //Generate the keypair
        crypto_box_curve25519xsalsa20poly1305_keypair(cpublicKey, csecretKey);

        _publicKey = [NSData dataWithBytes:cpublicKey length:crypto_box_curve25519xsalsa20poly1305_PUBLICKEYBYTES];
        _secretKey = [NSData dataWithBytes:csecretKey length:crypto_box_curve25519xsalsa20poly1305_SECRETKEYBYTES];

    }

    return self;
}

@end