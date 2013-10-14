//
//  AGCryptoBox.h
//  crypto-sdk
//
//  Created by Corinne Krych on 10/11/13.
//  Copyright (c) 2013 AeroGear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

typedef struct {
    CCOperation operation;
    CCAlgorithm algorithm;
} AGCryptoOptions;

@interface AGCryptoBox : NSObject
-(id)initWithOptions:(AGCryptoOptions)options andKey:(NSData*)key error:(NSError**)error;
-(NSData*) encryptData:(NSData*)data;
@property (nonatomic, readonly) CCCryptorRef cryptor;
@end
