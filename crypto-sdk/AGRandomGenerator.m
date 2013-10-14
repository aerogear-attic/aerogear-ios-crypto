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

#import "AGRandomGenerator.h"

@implementation AGRandomGenerator

- (NSData *)generateSecret {
	uint8_t *bytes = malloc(kCCKeySizeAES256 * sizeof(uint8_t));
	memset((void *)bytes, 0x0, kCCKeySizeAES256);
	OSStatus sanityCheck = SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES256, bytes);
	if (sanityCheck == noErr) {
		NSData *secret = [[NSData alloc] initWithBytes:(const void *)bytes length:kCCKeySizeAES256];
		return secret;
	} else {
		return nil;
	}
}

- (NSString *)keyForPIN:(NSString *)PIN salt:(NSData *)salt {
    // For backwards compatability
    if (!salt) {
        return PIN;
    }
    
    NSData *PINData = [PIN dataUsingEncoding:NSUTF8StringEncoding];
    
    // How many rounds to use so that it takes 0.1s ?
    int rounds = 32894; // Calculated using: CCCalibratePBKDF(kCCPBKDF2, PINData.length, saltData.length, kCCPRFHmacAlgSHA256, 32, 100);
    
    // Open CommonKeyDerivation.h for help
    unsigned char key[32];
    int result = CCKeyDerivationPBKDF(kCCPBKDF2, PINData.bytes, PINData.length, salt.bytes, salt.length, kCCPRFHmacAlgSHA256, rounds, key, 32);
    if (result == kCCParamError) {
        NSLog(@"Error %d deriving key", result);
        return nil;
    }
    
    NSMutableString *keyString = [[NSMutableString alloc] init];
    for (int i = 0; i < 32; ++i) {
        [keyString appendFormat:@"%02x", key[i]];
    }
    return keyString;
}

@end
