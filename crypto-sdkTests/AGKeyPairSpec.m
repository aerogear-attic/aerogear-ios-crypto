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
#import "AGKeyPair.h"

SPEC_BEGIN(AGKeyPairSpec)

        describe(@"AGKeyPair", ^{

            const int privateKeyLength = crypto_box_curve25519xsalsa20poly1305_SECRETKEYBYTES;
            const int publicKeyLength = crypto_box_curve25519xsalsa20poly1305_PUBLICKEYBYTES;

            __block AGKeyPair *keyPair;

            beforeEach(^{
                keyPair = [[AGKeyPair alloc] init];
            });

            it(@"should generate a new key pair", ^{
                [[theValue(keyPair.privateKey.length) should] equal:theValue(privateKeyLength)];
                [[theValue(keyPair.publicKey.length) should] equal:theValue(publicKeyLength)];
            });
        });

SPEC_END