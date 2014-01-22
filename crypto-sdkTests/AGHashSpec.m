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
#import <CommonCrypto/CommonDigest.h>
#import "AGHash.h"

SPEC_BEGIN(AGHashSpec)

describe(@"AGHash", ^{
    context(@"Hash creation", ^{

        NSString * const SHA2_MESSAGE = @"My Bonnie lies over the ocean, my Bonnie lies over the sea";
        NSString * const SHA256_DIGEST = @"0oHRApa3veIN8/P0ptG9tRP0qkzLAEjHsvf1eGtLy3c=";
        NSString * const SHA256_DIGEST_EMPTY_STRING = @"47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";

        NSString * const SHA512_DIGEST = @"EN6KNuCdDxUw0H8+hcBkSicxCvbU6FyRFr41EkNWYghyvzkPKNFXhzBmrqwZ9GQyvLvsaqC3bFOoYifNZjbPFg==";
        NSString * const SHA512_DIGEST_EMPTY_STRING = @"z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg/SpIdNs6c5H0NE8XYXysP+DGNKHfuwvY7kxvUdBeoGlODJ6+SfaPg==";

        context(@"SHA-256", ^{

            AGHash *agHash = [[AGHash alloc] init];

            it(@"should create a valid Hash with the provided string", ^{
                NSMutableData *rawPassword = [agHash digest:SHA2_MESSAGE];
                NSString *base64String = [rawPassword base64EncodedStringWithOptions:0];
                [[base64String should] equal:SHA256_DIGEST];
            });

            it(@"should create a valid Hash with the empty provided string", ^{
                NSMutableData *rawPassword = [agHash digest:@""];
                NSString *base64String = [rawPassword base64EncodedStringWithOptions:0];
                [[base64String should] equal:SHA256_DIGEST_EMPTY_STRING];
            });

            it(@"should not raise any exception on null bytes", ^{
                NSMutableData *rawPassword = [agHash digest:@"\0"];
                [rawPassword shouldNotBeNil];
            });
        });

        context(@"SHA-512", ^{

            AGHash *agHash = [[AGHash alloc] init:CC_SHA512_DIGEST_LENGTH];

            it(@"should create a valid Hash with the provided string", ^{
                NSMutableData *rawPassword = [agHash digest:SHA2_MESSAGE];
                NSString *base64String = [rawPassword base64EncodedStringWithOptions:0];
                [[base64String should] equal:SHA512_DIGEST];
            });

            it(@"should create a valid Hash with the empty provided string", ^{
                NSMutableData *rawPassword = [agHash digest:@""];
                NSString *base64String = [rawPassword base64EncodedStringWithOptions:0];
                [[base64String should] equal:SHA512_DIGEST_EMPTY_STRING];
            });

            it(@"should not raise any exception on null bytes", ^{
                NSMutableData *rawPassword = [agHash digest:@"\0"];
                [rawPassword shouldNotBeNil];
            });
        });
    });
});

SPEC_END