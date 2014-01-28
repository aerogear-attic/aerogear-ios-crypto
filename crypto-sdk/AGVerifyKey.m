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
    NSData *_key;
}

- (id)initWithKey:(NSData *)key {
    self = [super init];
    if (self) {
        [AGUtil checkLength:key size:crypto_sign_ed25519_PUBLICKEYBYTES];
        _key = key;
    }

    return self;
}

- (BOOL)verify:(NSString *)message signature:(NSData *)signature {
    [AGUtil checkLength:signature size:crypto_sign_ed25519_BYTES];

    NSMutableData *signAndMsg = [NSMutableData data];
    [signAndMsg appendData:signature];
    [signAndMsg appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    
    unsigned long long bufferLen;

    NSData *newBuffer = [AGUtil prependZeros:signAndMsg.length];
    unsigned char *bytePtr = (unsigned char *)[newBuffer bytes];

    int status = crypto_sign_ed25519_open(bytePtr, &bufferLen,
            signAndMsg.mutableBytes, signAndMsg.length, (unsigned char *)[_key bytes]);

    if( status != 0 ) {
        NSLog(@"Invalid signature %i", status);
        return NO;
    }

    return YES;
}
@end