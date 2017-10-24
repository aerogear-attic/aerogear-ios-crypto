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

#import "AGRandomGenerator.h"


SPEC_BEGIN(AGRandomGeneratorSpec)

describe(@"AGRandomGenerator", ^{
    context(@"random generation", ^{

        it(@"should produce random bytes", ^{
            NSData *random = [AGRandomGenerator randomBytes:16];

            [[theValue([random length]) should] equal:theValue(16)];
        });
        
        it(@"should produce default random bytes", ^{
            NSData *random = [AGRandomGenerator randomBytes];
            
            [[theValue([random length]) should] equal:theValue(16)];
        });
        
        it(@"should produce different random bytes", ^{
            [[[AGRandomGenerator randomBytes:16] shouldNot] equal:[AGRandomGenerator randomBytes:16] ];
        });
        
        it(@"should produce different default random bytes", ^{
            [[[AGRandomGenerator randomBytes] shouldNot] equal:[AGRandomGenerator randomBytes] ];
        });
    });
});

SPEC_END