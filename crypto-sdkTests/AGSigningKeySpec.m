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
#import "AGSigningKey.h"
#import "AGVerifyKey.h"
#import "AGUtil.h"

SPEC_BEGIN(AGSigningKeySpec)

        describe(@"AGSigningKey", ^{
            context(@"Signing message", ^{

                NSString const * message = @"My Bonnie lies over the ocean, my Bonnie lies over the sea";

                __block AGSigningKey *signingKey;
                __block AGVerifyKey *verifyKey;


                beforeEach(^{
                    signingKey = [[AGSigningKey alloc] init];
                    verifyKey = [[AGVerifyKey alloc] initWithKey:signingKey.publicKey];

                });

                it(@"should properly sign and verify the signature", ^{
                    NSData * signedMessage = [signingKey sign:message];
                    BOOL status = [verifyKey verify:message signature:signedMessage];
                    [[theValue(status) should] equal:theValue(YES)];
                });

                it(@"should detect bad signature", ^{
                    NSData *corruptedMessage = [AGUtil prependZeros:64];
                    BOOL status = [verifyKey verify:message signature:corruptedMessage];
                    [[theValue(status) should] equal:theValue(NO)];
                });
            });
        });

SPEC_END