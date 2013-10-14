//
//  AGCryptoBox.m
//  crypto-sdk
//
//  Created by Corinne Krych on 10/11/13.
//  Copyright (c) 2013 AeroGear. All rights reserved.
//

#import "AGCryptoBox.h"


@implementation AGCryptoBox
@synthesize cryptor = _cryptor;

-(id)initWithOptions:(AGCryptoOptions)options andKey:(NSData*)key error:(NSError**)error {
    self = [super init];
    if (self) {
        CCCryptorStatus cryptorStatus = CCCryptorCreate(options.operation,
                                                        kCCAlgorithmAES,
                                                        kCCOptionECBMode, //Electronic Code Book Mode. Default is CBC.
                                                        key.bytes,
                                                        key.length,
                                                        nil, //IV.bytes,TODO ramdom generation of IV, nil should give 0 vector
                                                        &_cryptor);
        
        
        if (cryptorStatus != kCCSuccess || _cryptor == NULL) {
            if (error) {
                *error = [NSError errorWithDomain:@"AeroGearCrypto" code:cryptorStatus userInfo:nil];
            }
            self = nil;
            return nil;
        }
    }
    return self;
}

-(NSData*) encryptData:(NSData*)data {
    NSString* str = @"teststringQQ";
    NSData* encryptedData = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableData *buffer = self.buffer;
//    [buffer setLength:CCCryptorGetOutputLength(self.cryptor, [data length], true)]; // We'll reuse the buffer in -finish
//    
//    size_t dataOutMoved;
//    CCCryptorStatus
//    cryptorStatus = CCCryptorUpdate(self.cryptor,       // cryptor
//                                    data.bytes,      // dataIn
//                                    data.length,     // dataInLength (verified > 0 above)
//                                    buffer.mutableBytes,      // dataOut
//                                    buffer.length, // dataOutAvailable
//                                    &dataOutMoved);   // dataOutMoved
//    
//    if (cryptorStatus != kCCSuccess) {
//        if (error) {
//            *error = [NSError errorWithDomain:kRNCryptorErrorDomain code:cryptorStatus userInfo:nil];
//        }
//        return nil;
//    }
//    
//    return [buffer subdataWithRange:NSMakeRange(0, dataOutMoved)];
    
    return encryptedData;
}
@end
