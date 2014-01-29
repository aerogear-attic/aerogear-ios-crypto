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
#import "AGSymmetricCryptoEngine.h"

@implementation AGSecretBox {
    NSData *_key;
}

- (id)initWithKey:(NSData *)key {
    self = [super init];
    if (self) {
        _key = key;
    }
    
    return self;
}

- (NSData *)encrypt:(NSData *)data IV:(NSData *)IV {
    NSParameterAssert(data != nil);
    NSParameterAssert(IV != nil);

    NSError *error;
    AGSymmetricCryptoEngine *engine = [[AGSymmetricCryptoEngine alloc] initWithOperation:kCCEncrypt
                                                                                     key:_key
                                                                                      IV:IV
                                                                                   error:&error];

    NSMutableData *cipher = [NSMutableData data];
    
    [cipher appendData:[engine add:data error:&error]];
    [cipher appendData:[engine finish:&error]];
    
    return cipher;
}

- (NSData *)decrypt:(NSData *)data IV:(NSData *)IV {
    NSParameterAssert(data != nil);
    NSParameterAssert(IV != nil);

    NSError *error;
    AGSymmetricCryptoEngine *engine = [[AGSymmetricCryptoEngine alloc] initWithOperation:kCCDecrypt
                                                                                     key:_key
                                                                                      IV:IV
                                                                                   error:&error];
    
    NSMutableData *cipher = [NSMutableData data];
    
    [cipher appendData:[engine add:data error:&error]];
    [cipher appendData:[engine finish:&error]];
    
    return cipher;
}

@end
