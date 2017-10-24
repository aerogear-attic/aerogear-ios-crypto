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
#import "AGPBKDF2.h"
#import "AGRandomGenerator.h"

SPEC_BEGIN(AGPBKDB2Spec)

describe(@"AGPBKDB2", ^{
    context(@"password generation", ^{

        NSString * const PASSWORD = @"My Bonnie lies over the ocean, my Bonnie lies over the sea";
        NSString * const INVALID_PASSWORD = @"invalid";
        
        __block AGPBKDF2 *pbkdf2;
        
        beforeEach(^{
            pbkdf2 = [[AGPBKDF2 alloc] init];
            
        });
        
        context(@"with valid password", ^{
            
            it(@"should be valid with random salt provided", ^{
                NSData *salt = [AGRandomGenerator randomBytes];
                NSData *rawPassword = [pbkdf2 deriveKey:PASSWORD salt:salt];

                [[theValue([pbkdf2 validate:PASSWORD encryptedPassword:rawPassword salt:salt]) should] beYes];
                [[theValue([rawPassword length]) should] equal:theValue(AGPBKDF2DerivedKeyLength)];
            });

            it(@"should be valid with salt generated", ^{
                NSData *rawPassword = [pbkdf2 deriveKey:PASSWORD];
                
                [[theValue([pbkdf2 validate:PASSWORD encryptedPassword:rawPassword salt:[pbkdf2 salt]]) should] beYes];
                [[theValue([rawPassword length]) should] equal:theValue(AGPBKDF2DerivedKeyLength)];
            });
        });
        
        context(@"with invalid password", ^{
            
            it(@"should be invalid with random salt provided", ^{
                NSData *salt = [AGRandomGenerator randomBytes];
                NSData *rawPassword = [pbkdf2 deriveKey:PASSWORD salt:salt];
                
                [[theValue([pbkdf2 validate:INVALID_PASSWORD encryptedPassword:rawPassword salt:salt]) should] beNo];
                [[theValue([rawPassword length]) should] equal:theValue(AGPBKDF2DerivedKeyLength)];
            });
            
            it(@"should be invalid with salt generated", ^{
                NSData *rawPassword = [pbkdf2 deriveKey:PASSWORD];
                
                [[theValue([pbkdf2 validate:INVALID_PASSWORD encryptedPassword:rawPassword salt:[pbkdf2 salt]]) should] beNo];
                [[theValue([rawPassword length]) should] equal:theValue(AGPBKDF2DerivedKeyLength)];
            });
        });
        
        context(@"with invalid parameters", ^{
            
            it(@"should throw an error with poor salt provided", ^{
                NSData *salt = [@"42" dataUsingEncoding:NSUTF8StringEncoding];

                [[theBlock(^{
                    __unused NSData *rawPassword = [pbkdf2 deriveKey:PASSWORD salt:salt];
                }) should] raise];
            });
        
            it(@"should throw an error with poor iterations provided", ^{
                NSData *salt = [AGRandomGenerator randomBytes];
                
                [[theBlock(^{
                    __unused NSData *rawPassword = [pbkdf2 deriveKey:PASSWORD salt:salt iterations:42];
                }) should] raise];
            });
        });
    });
});

SPEC_END