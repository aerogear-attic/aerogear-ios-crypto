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
#import "AGSecretBox.h"
#import "AGUtil.h"
#import "AGPBKDF2.h"
#import "AGRandomGenerator.h"

SPEC_BEGIN(AGSecretBoxSpec)

describe(@"AGSecretBox", ^{
    
    context(@"Symmetric encryption", ^{
        
        NSString * const BOB_SECRET_KEY = @"5DAB087E624A8A4B79E17F8B83800EE66F3BB1292618B6FD1C2F8B27FF88E0EB";
        NSString * const BOB_CORRUPTED_SECRET_KEY = @"1FAC087E124A8A4B79E17F8B83800EE66F3BB1292618B6FD1C2F8B27FF88E0EB";
        
        NSString * const BOX_NONCE = @"69696EE955B62B73CD62BDA875FC73D68219E0036B7A0B37";
        
        NSString * const BOX_MESSAGE = @"BE075FC53C81F2D5CF141316EBEB0C7B5228C52A4C62CBD44B66849B64244FFCE5ECBAAF33BD751A1AC728D45E6C61296CDC3C01233561F41DB66CCE314ADB310E3BE8250C46F06DCEEA3A7FA1348057E2F6556AD6B1318A024A838F21AF1FDE048977EB48F59FFD4924CA1C60902E52F0A089BC76897040E082F937763848645E0705";
        
        const NSString *BOX_CIPHERTEXT = @"FF3E9EDA8A2CAE2BD500805C39B3B0453C4085503EAADC170CEAD52C6DFFAAA3E31CADF835C65530C0DA6D2EFA79A94C47DC3397D8F6999C1B7D768E681E5B528EE048B7652E2756E4EC011213D2D5C8EB8D1BE454C18EC319D363E79EE493F1C146E9D27C7A14BD5A5B82DA7B30CA9D4A706CD7C77F4491A41504F6B8814AA9CD28224966571A9E45FD1FD029B73CF43EA382";

        __block AGSecretBox *secretBox;
        
        it(@"should accept the key provided", ^{
            NSData *key = [AGUtil hexStringToBytes:BOB_SECRET_KEY];
            secretBox = [[AGSecretBox alloc] initWithKey:key];
        });
        
        it(@"should reject nil secret key", ^{
            [[theBlock(^{
                secretBox = [[AGSecretBox alloc] initWithKey:nil];
            }) should] raise];
        });
        
        it(@"should reject invalid secret key", ^{
            NSData *invalidKey = [AGUtil hexStringToBytes:@"000000"];

            [[theBlock(^{
                secretBox = [[AGSecretBox alloc] initWithKey:invalidKey];
            }) should] raise];
        });

        it(@"should accept KDF keys", ^{
            
            AGPBKDF2 *pbkdf2 = [[AGPBKDF2 alloc] init];
            NSString *PASSWORD = @"My Bonnie lies over the ocean, my Bonnie lies over the sea";
            NSData *salt = [AGRandomGenerator randomBytes];
            NSData *key = [pbkdf2 deriveKey:PASSWORD salt:salt];
            
            NSData *nonce = [AGUtil hexStringToBytes:BOX_NONCE];
            NSData *message = [AGUtil hexStringToBytes:BOX_MESSAGE];
            
            secretBox = [[AGSecretBox alloc] initWithKey:key];

            NSData *cipherText = [secretBox encrypt:message nonce:nonce error:nil];

            //Create a new box to test end to end symmetric encryption
            AGSecretBox *pandora = [[AGSecretBox alloc] initWithKey:key];
            NSData *plainText = [pandora decrypt:cipherText nonce:nonce error:nil];
            [[[AGUtil hexString:plainText] should] equal:BOX_MESSAGE];
        });
        
        it(@"should properly encrypt the raw bytes provided", ^{
            NSData *key = [AGUtil hexStringToBytes:BOB_SECRET_KEY];
            
            NSData *nonce = [AGUtil hexStringToBytes:BOX_NONCE];
            NSData *message = [AGUtil hexStringToBytes:BOX_MESSAGE];
            
            secretBox = [[AGSecretBox alloc] initWithKey:key];
            NSData *cipherText = [secretBox encrypt:message nonce:nonce error:nil];
            [[[AGUtil hexString:cipherText] should] equal:BOX_CIPHERTEXT];
        });
        
        it(@"should properly decrypt the raw bytes provided", ^{
            NSData *key = [AGUtil hexStringToBytes:BOB_SECRET_KEY];
            
            NSData *nonce = [AGUtil hexStringToBytes:BOX_NONCE];
            NSData *message = [AGUtil hexStringToBytes:BOX_MESSAGE];
            
            secretBox = [[AGSecretBox alloc] initWithKey:key];
            
            NSData *cipherText = [secretBox encrypt:message nonce:nonce error:nil];

            //Create a new box to test end to end symmetric encryption
            AGSecretBox *pandora = [[AGSecretBox alloc] initWithKey:key];
            NSData *plainText = [pandora decrypt:cipherText nonce:nonce error:nil];
            [[[AGUtil hexString:plainText] should] equal:BOX_MESSAGE];
        });
        
        it(@"should reject to decrypt corrupted ciphertext", ^{
            NSData *key = [AGUtil hexStringToBytes:BOB_SECRET_KEY];
            
            NSData *nonce = [AGUtil hexStringToBytes:BOX_NONCE];
            NSData *message = [AGUtil hexStringToBytes:BOX_MESSAGE];
            
            secretBox = [[AGSecretBox alloc] initWithKey:key];
            
            NSData *cipherText = [secretBox encrypt:message nonce:nonce error:nil];
            
            // corrupt ciphertext
            NSMutableData *corupted_cipherText = [NSMutableData dataWithData:cipherText];
            [corupted_cipherText resetBytesInRange:NSMakeRange(0,5)];
            
            AGSecretBox *pandora = [[AGSecretBox alloc] initWithKey:key];
            
            NSError *error;
            NSData __unused *plainText = [pandora decrypt:corupted_cipherText nonce:nonce error:&error];
            
            [error shouldNotBeNil];
            [[theValue(error.code) should] equal:theValue(AGCryptoFailedToDecryptError)];
        });

        it(@"should reject to decrypt corrupted key", ^{
            NSData *key = [AGUtil hexStringToBytes:BOB_SECRET_KEY];
            
            NSData *nonce = [AGUtil hexStringToBytes:BOX_NONCE];
            NSData *message = [AGUtil hexStringToBytes:BOX_MESSAGE];
            
            secretBox = [[AGSecretBox alloc] initWithKey:key];
            
            NSData *cipherText = [secretBox encrypt:message nonce:nonce error:nil];
            
            // initialize with corrupted key
            NSData *corruptedkey = [AGUtil hexStringToBytes:BOB_CORRUPTED_SECRET_KEY];
            AGSecretBox *pandora = [[AGSecretBox alloc] initWithKey:corruptedkey];

            NSError *error;
            NSData __unused *plainText = [pandora decrypt:cipherText nonce:nonce error:&error];

            [error shouldNotBeNil];
            [[theValue(error.code) should] equal:theValue(AGCryptoFailedToDecryptError)];
        });
    });
});

SPEC_END