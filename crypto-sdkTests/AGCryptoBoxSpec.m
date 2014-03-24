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
#import "AGCryptoBox.h"
#import "AGUtil.h"

SPEC_BEGIN(AGCryptoBoxSpec)

        describe(@"AGCryptoBox", ^{

            context(@"Asymmetric encryption", ^{

                NSString * const ALICE_PUBLIC_KEY = @"8520F0098930A754748B7DDCB43EF75A0DBF3A0D26381AF4EBA4A98EAA9B4E6A";
                NSString * const ALICE_PRIVATE_KEY = @"77076D0A7318A57D3C16C17251B26645DF4C2F87EBC0992AB177FBA51DB92C2A";
                NSString * const ALICE_CORRUPTED_PRIVATE_KEY = @"1207640A7318B57D3C16C17251B26645DF4C2F87EBC0992AB177FBA51DB92C2A";

                NSString * const BOB_PRIVATE_KEY = @"5DAB087E624A8A4B79E17F8B83800EE66F3BB1292618B6FD1C2F8B27FF88E0EB";
                NSString * const BOB_PUBLIC_KEY = @"DE9EDB7D7B7DC1B4D35B61C2ECE435373F8343C85B78674DADFC7E146F882B4F";

                NSString * const BOX_NONCE = @"69696EE955B62B73CD62BDA875FC73D68219E0036B7A0B37";
                NSString * const BOX_MESSAGE = @"BE075FC53C81F2D5CF141316EBEB0C7B5228C52A4C62CBD44B66849B64244FFCE5ECBAAF33BD751A1AC728D45E6C61296CDC3C01233561F41DB66CCE314ADB310E3BE8250C46F06DCEEA3A7FA1348057E2F6556AD6B1318A024A838F21AF1FDE048977EB48F59FFD4924CA1C60902E52F0A089BC76897040E082F937763848645E0705";
                const NSString *BOX_CIPHERTEXT = @"F3FFC7703F9400E52A7DFB4B3D3305D98E993B9F48681273C29650BA32FC76CE48332EA7164D96A4476FB8C531A1186AC0DFC17C98DCE87B4DA7F011EC48C97271D2C20F9B928FE2270D6FB863D51738B48EEEE314A7CC8AB932164548E526AE90224368517ACFEABD6BB3732BC0E9DA99832B61CA01B6DE56244A9E88D5F9B37973F622A43D14A6599B1F654CB45A74E355A5";
                
                __block AGCryptoBox *cryptoBox;
                
                it(@"should accept the keys provided with AGKeyPair", ^{
                    NSData *alicePublicKey = [AGUtil hexStringToBytes:ALICE_PUBLIC_KEY];
                    NSData *bobPrivateKey = [AGUtil hexStringToBytes:BOB_PRIVATE_KEY];
                    AGKeyPair* keyPair = [[AGKeyPair alloc] initWithPrivateKey:bobPrivateKey publicKey:alicePublicKey];
                    
                    cryptoBox = [[AGCryptoBox alloc] initWithKeyPair:keyPair];
                });
                
                it(@"should accept the key provided", ^{
                    NSData *alicePublicKey = [AGUtil hexStringToBytes:ALICE_PUBLIC_KEY];
                    NSData *bobPrivateKey = [AGUtil hexStringToBytes:BOB_PRIVATE_KEY];

                    cryptoBox = [[AGCryptoBox alloc] initWithKey:alicePublicKey privateKey:bobPrivateKey];
                });

                it(@"should reject nil public key", ^{
                    NSData *bobPrivateKey = [AGUtil hexStringToBytes:BOB_PRIVATE_KEY];

                    [[theBlock(^{
                        cryptoBox = [[AGCryptoBox alloc] initWithKey:nil privateKey:bobPrivateKey];
                    }) should] raise];
                });

                it(@"should reject invalid public key", ^{
                    NSData *invalidPublicKey = [AGUtil hexStringToBytes:@"000000"];
                    NSData *bobPrivateKey = [AGUtil hexStringToBytes:BOB_PRIVATE_KEY];

                    [[theBlock(^{
                        cryptoBox = [[AGCryptoBox alloc] initWithKey:invalidPublicKey privateKey:bobPrivateKey];
                    }) should] raise];
                });

                it(@"should reject nil secret key", ^{
                    NSData *alicePublicKey = [AGUtil hexStringToBytes:ALICE_PUBLIC_KEY];

                    [[theBlock(^{
                        cryptoBox = [[AGCryptoBox alloc] initWithKey:alicePublicKey privateKey:nil];
                    }) should] raise];
                });

                it(@"should reject invalid secret key", ^{
                    NSData *alicePublicKey = [AGUtil hexStringToBytes:ALICE_PUBLIC_KEY];
                    NSData *bobPrivateKey = [AGUtil hexStringToBytes:@"000000"];

                    [[theBlock(^{
                        cryptoBox = [[AGCryptoBox alloc] initWithKey:alicePublicKey privateKey:bobPrivateKey];
                    }) should] raise];
                });

                it(@"should properly encrypt the raw bytes provided", ^{
                    NSData *alicePublicKey = [AGUtil hexStringToBytes:ALICE_PUBLIC_KEY];
                    NSData *bobPrivateKey = [AGUtil hexStringToBytes:BOB_PRIVATE_KEY];

                    NSData *nonce = [AGUtil hexStringToBytes:BOX_NONCE];
                    NSData *message = [AGUtil hexStringToBytes:BOX_MESSAGE];

                    AGCryptoBox *cryptoBox = [[AGCryptoBox alloc] initWithKey:alicePublicKey privateKey:bobPrivateKey];
                    NSData *cipherText = [cryptoBox encrypt:message nonce:nonce error:nil];
                    [[[AGUtil hexString:cipherText] should] equal:BOX_CIPHERTEXT];
                });

                it(@"should properly decrypt the raw bytes provided", ^{
                    NSData *alicePublicKey = [AGUtil hexStringToBytes:ALICE_PUBLIC_KEY];
                    NSData *alicePrivateKey = [AGUtil hexStringToBytes:ALICE_PRIVATE_KEY];
                    NSData *bobPrivateKey = [AGUtil hexStringToBytes:BOB_PRIVATE_KEY];
                    NSData *bobPublicKey = [AGUtil hexStringToBytes:BOB_PUBLIC_KEY];

                    NSData *nonce = [AGUtil hexStringToBytes:BOX_NONCE];
                    NSData *message = [AGUtil hexStringToBytes:BOX_MESSAGE];

                    AGCryptoBox *cryptoBox = [[AGCryptoBox alloc] initWithKey:alicePublicKey privateKey:bobPrivateKey];
                    NSData *cipherText = [cryptoBox encrypt:message nonce:nonce error:nil];

                    //Create a new box to test end to end asymmetric encryption
                    AGCryptoBox *pandora = [[AGCryptoBox alloc] initWithKey:bobPublicKey privateKey:alicePrivateKey];
                    NSData *plainText = [pandora decrypt:cipherText nonce:nonce error:nil];
                    [[[AGUtil hexString:plainText] should] equal:BOX_MESSAGE];
                });

                it(@"should reject to decrypt with corrupted key", ^{
                    NSData *alicePublicKey = [AGUtil hexStringToBytes:ALICE_PUBLIC_KEY];
                    NSData *alicePrivateKey = [AGUtil hexStringToBytes:ALICE_CORRUPTED_PRIVATE_KEY]; // corrupted key
                    NSData *bobPrivateKey = [AGUtil hexStringToBytes:BOB_PRIVATE_KEY];
                    NSData *bobPublicKey = [AGUtil hexStringToBytes:BOB_PUBLIC_KEY];

                    NSData *nonce = [AGUtil hexStringToBytes:BOX_NONCE];
                    NSData *message = [AGUtil hexStringToBytes:BOX_MESSAGE];

                    AGCryptoBox *cryptoBox = [[AGCryptoBox alloc] initWithKey:alicePublicKey privateKey:bobPrivateKey];
                    NSData *cipherText = [cryptoBox encrypt:message nonce:nonce error:nil];

                    //Create a new box to test end to end asymmetric encryption
                    AGCryptoBox *pandora = [[AGCryptoBox alloc] initWithKey:bobPublicKey privateKey:alicePrivateKey];
                    
                    NSError *error;
                    NSData __unused *plainText = [pandora decrypt:cipherText nonce:nonce error:&error];
                    
                    [error shouldNotBeNil];
                    [[theValue(error.code) should] equal:theValue(AGCryptoFailedToDecryptError)];
                });
            });
        });

SPEC_END