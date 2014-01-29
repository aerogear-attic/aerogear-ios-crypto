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

#import "AGSigningKey.h"
#import "AGUtil.h"


@implementation AGSigningKey

- (id)init {
    self = [super init];

    if (self) {

        const unsigned long long bufferLen = crypto_sign_ed25519_SECRETKEYBYTES;
        unsigned char seed[bufferLen];

        randombytes(seed, bufferLen);
        
        unsigned char cpublicKey[crypto_sign_ed25519_PUBLICKEYBYTES];
        unsigned char csecretKey[crypto_sign_ed25519_SECRETKEYBYTES];

        //Generate the keypair
        [AGUtil isValid:crypto_sign_ed25519_seed_keypair(cpublicKey, csecretKey, seed)
                    msg:@"Failed to generate a key pair"];

        _publicKey = [NSData dataWithBytes:cpublicKey length:crypto_sign_ed25519_PUBLICKEYBYTES];
        _secretKey = [NSData dataWithBytes:csecretKey length:crypto_sign_ed25519_SECRETKEYBYTES];

    }

    return self;
}

- (NSData *)sign:(NSString *)message {
    unsigned long long bufferLen;
    const unsigned char *msg = (const unsigned char *)[message UTF8String];
    unsigned long long mlen = strlen((const char*) msg);
    NSData *signature = [AGUtil prependZeros:crypto_sign_ed25519_BYTES msg:message];
    unsigned char *bytePtr = (unsigned char *)[signature bytes];

    if( crypto_sign_ed25519(bytePtr, &bufferLen, msg,
            mlen, (unsigned char *)[_secretKey bytes]) != 0 ) {
        NSLog(@"crypto_sign error");
    }

    return [AGUtil slice:signature start:0 end:crypto_sign_ed25519_BYTES];
}

@end