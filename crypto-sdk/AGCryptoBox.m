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

#import "AGCryptoBox.h"


@implementation AGCryptoBox
@synthesize key = _key;
@synthesize initializationVector = _initializationVector;
//@synthesize cryptor = _cryptor;
//@synthesize encryptedData = _encryptedData;

//-(id)initWithOptions:(AGCryptoOptions)options withInvertedVector:(NSData*)invertedVector andKey:(NSData*)key error:(NSError**)error {
//    self = [super init];
//    if (self) {
//        CCCryptorStatus cryptorStatus = CCCryptorCreate(options.operation,
//                                                        kCCAlgorithmAES,
//                                                        kCCOptionECBMode, //Electronic Code Book Mode. Default is CBC.
//                                                        key.bytes,
//                                                        key.length,
//                                                        invertedVector.bytes,
//                                                        &_cryptor);
//        
//        
//        if (cryptorStatus != kCCSuccess || _cryptor == NULL) {
//            if (error) {
//                *error = [NSError errorWithDomain:@"AeroGearCrypto" code:cryptorStatus userInfo:nil];
//            }
//            self = nil;
//            return nil;
//        }
//    }
//    return self;
//}
//
//-(NSData*) encryptData:(NSData*)data error:(NSError**)error {
//    //NSLog(@">>>%d",[data length]);
//    //    [self.encryptedData setLength:CCCryptorGetOutputLength(self.cryptor, [data length], true)];
//    _encryptedData = [[NSMutableData alloc] initWithLength:[data length]];
//    size_t dataOutMoved;
//    CCCryptorStatus cryptorStatus = CCCryptorUpdate(self.cryptor,
//                                                    data.bytes,
//                                                    data.length,
//                                                    self.encryptedData.mutableBytes,
//                                                    self.encryptedData.length,
//                                                    &dataOutMoved);
//    
//    if (cryptorStatus != kCCSuccess) {
//        if (error) {
//            *error = [NSError errorWithDomain:@"AeroGearCrypto" code:cryptorStatus userInfo:nil];
//        }
//        return nil;
//    } else {
//        cryptorStatus = CCCryptorFinal(self.cryptor,                                                                                                         self.encryptedData.mutableBytes,
//                                       self.encryptedData.length,
//                                       &dataOutMoved);
//        if (cryptorStatus != kCCSuccess) {
//            if (error) {
//                *error = [NSError errorWithDomain:@"AeroGearCrypto" code:cryptorStatus userInfo:nil];
//            }
//            return nil;
//        }
//    }
//    return [NSData dataWithData:self.encryptedData];// subdataWithRange:NSMakeRange(0, dataOutMoved)];
//}

- (id)initWithKey:(NSString*)key initializationVector:(NSData*)vector {
    self = [super init];
    if (self) {
        _initializationVector = vector;
        _key = key;
    }
    return self;
}

- (NSData *)encrypt:(NSData *)data {
    char keyBuffer[kCCKeySizeAES256 * 2 + 1]; // room for terminator (unused)
    bzero(keyBuffer, sizeof(keyBuffer)); // fill with zeros (for padding)
    
    // fetch key data
    [self.key getCString:keyBuffer maxLength:sizeof(keyBuffer) encoding:NSASCIIStringEncoding];
    
    // iOS getCString truncates keyBuffer to maxLength. and replaces the first character with a 0
    // To ensure upgrading from iOS6 to 7 works. Do the same.
    keyBuffer[0] = 0;
    
    // For block ciphers, the output size will always be less than or
	// equal to the input size plus the size of one block.
	// That's why we need to add the size of one block here.
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
    
    // encrypt
    size_t numBytesEncrypted = 0;
    
    // check initialization vector length
    if ([self.initializationVector length] < kCCBlockSizeAES128) {
        self.initializationVector = nil;
    }
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     keyBuffer,
                                     kCCKeySizeAES256,
                                     self.initializationVector ? [self.initializationVector bytes] : NULL, // initialization vector (optional)
                                     [data bytes], // input
                                     [data length],
                                     buffer, // output
                                     bufferSize,
                                     &numBytesEncrypted);
    
    if (result == kCCSuccess) {
        // the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSData *)decrypt:(NSData *)data {
    char keyBuffer[kCCKeySizeAES256 * 2 + 1]; // room for terminator (unused)
    bzero(keyBuffer, sizeof(keyBuffer)); // fill with zeros (for padding)
    
    // fetch key data
    [self.key getCString:keyBuffer maxLength:sizeof(keyBuffer) encoding:NSUTF8StringEncoding];
    
    // iOS getCString truncates keyBuffer to maxLength. and replaces the first character with a 0
    // To ensure upgrading from iOS6 to 7 works. Do the same.
    keyBuffer[0] = 0;
    
    // For block ciphers, the output size will always be less than or
	// equal to the input size plus the size of one block.
	// That's why we need to add the size of one block here.
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
    
    // decrypt
    size_t numBytesDecrypted = 0;
    
    // check initialization vector length
    if ([self.initializationVector length] < kCCBlockSizeAES128) {
        self.initializationVector = nil;
    }
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     keyBuffer,
                                     kCCKeySizeAES256,
                                     self.initializationVector ? [self.initializationVector bytes] : NULL, // initialization vector (optional)
                                     [data bytes], // input
                                     [data length],
                                     buffer, // output
                                     bufferSize,
                                     &numBytesDecrypted);
    
    if (result == kCCSuccess) {
        // the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

@end
