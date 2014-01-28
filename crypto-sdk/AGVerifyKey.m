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

#import "AGVerifyKey.h"
#import "AGUtil.h"
#import <libsodium-ios/sodium/crypto_sign_ed25519.h>


@implementation AGVerifyKey {
    unsigned char _key;
}

- (id)init:(unsigned char *)key {
    self = [super init];
    if (self) {
        [AGUtil checkLength:key size:crypto_sign_ed25519_PUBLICKEYBYTES];
        _key = key;
    }

    return self;
}

- (BOOL *) verify:(unsigned char *)message signature:(unsigned char*)signature {
    [AGUtil checkLength:signature size:crypto_sign_ed25519_BYTES];

    NSMutableData *signAndMsg = [NSMutableData data];
    [signAndMsg appendBytes:signature length:sizeof(signature)];
    [signAndMsg appendBytes:message length:sizeof(message)];
    unsigned long long bufferLen;


    NSData *newBuffer = [AGUtil prependZeros:signAndMsg.length];
    unsigned char *bytePtr = (unsigned char *)[newBuffer bytes];

    int status = crypto_sign_ed25519_open(bytePtr, bufferLen,
            signAndMsg.mutableBytes, signAndMsg.length, _key);

    if( status != 0 ) {
        NSLog(@"Invalid signature %i", status);
    }

    return status;
}
@end