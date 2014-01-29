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
#import "AGUtil.h"

SPEC_BEGIN(AGUtilSpec)

describe(@"AGUtil", ^{
    context(@"Prepend zeros", ^{

        __block AGUtil *agUtil = [[AGUtil alloc] init];

        it(@"should prepend zeros correctly to the message provided", ^{

            NSString* src = @"test";
            unsigned char data[] = {0, 0, 0, 't', 'e', 's', 't'};

            NSData * expected = [NSData dataWithBytes:data length:sizeof(data)];
            NSData * result = [AGUtil prependZeros:3 msg:src];

            BOOL isDataValid = [expected isEqualToData:result];
            [[theValue(isDataValid) should] equal:theValue(YES)];
        });

        it(@"should prepend zeros correctly", ^{
            unsigned char data[] = {0, 0, 0};

            NSData * expected = [NSData dataWithBytes:data length:sizeof(data)];
            NSData * result = [AGUtil prependZeros:3];

            BOOL isDataValid = [expected isEqualToData:result];
            [[theValue(isDataValid) should] equal:theValue(YES)];
        });

    });
});

SPEC_END