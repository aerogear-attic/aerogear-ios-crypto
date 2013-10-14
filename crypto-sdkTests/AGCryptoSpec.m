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
#import "AGRandomGenerator.h"

SPEC_BEGIN(AGCryptoBoxSpec)

//describe(@"CryptoBox", ^{
//    context(@"encrypt raw bytes", ^{
//        __block AGCryptoBox* encryptEngine = nil;
//        __block AGCryptoBox* decryptEngine = nil;
//
//        beforeEach(^{
//            NSData *invertedVector = [@"ferfgfgfgfgfgffgfg" dataUsingEncoding:NSUTF8StringEncoding];
//            NSData* encryptionKeyData = [@"myEncryptKey" dataUsingEncoding:NSUTF8StringEncoding];
//            AGCryptoOptions options = {kCCEncrypt, kCCAlgorithmAES};
//            AGCryptoOptions decryptOptions = {kCCDecrypt, kCCAlgorithmAES};
//            
//            encryptEngine = [[AGCryptoBox alloc] initWithOptions:options withInvertedVector:invertedVector andKey:encryptionKeyData error:nil];
//            
//            decryptEngine = [[AGCryptoBox alloc] initWithOptions:decryptOptions withInvertedVector:invertedVector andKey:encryptionKeyData error:nil];
//        });
//        
//        it(@"should return encrypted data", ^{
//            NSString* stringToEncrypt = @"ReallySecretString";
//            NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
//            
//            NSData* encryptedData = [encryptEngine encryptData:dataToEncrypt error:nil];
//            
//            [encryptedData shouldNotBeNil];
//            [[theValue([encryptedData length]) should] equal:theValue(18)];
//            
//        });
//        
//        it(@"should return encrypted data and", ^{
//            NSString* stringToEncrypt = @"ReallySecretString";
//            NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
//            
//            NSData* encryptedData = [encryptEngine encryptData:dataToEncrypt error:nil];
//            
//            [encryptedData shouldNotBeNil];
//            [[theValue([encryptedData length]) should] equal:theValue(18)];
//            
//        });
//    });
//
//});

describe(@"CryptoBox", ^{
    context(@"encrypt raw bytes", ^{
        __block AGCryptoBox* cryptoEngine = nil;
        __block NSData* invertedVector = nil;
        __block NSData *encryptionSalt = nil;
        __block NSString* encryptionKey = nil;
        __block AGRandomGenerator* randomGenerator = nil;
        
        beforeEach(^{
            randomGenerator = [[AGRandomGenerator alloc] init];
            invertedVector = [randomGenerator generateSecret];
            encryptionSalt = [@"12345678" dataUsingEncoding:NSUTF8StringEncoding];
            encryptionKey = [randomGenerator keyForPIN:@"1234" salt:encryptionSalt];
            cryptoEngine = [[AGCryptoBox alloc] initWithKey:encryptionKey initializationVector:encryptionSalt];

        });
        
        it(@"should return identical encrypted/decrypted data when 16 characters", ^{
            NSString* stringToEncrypt = @"0123456789abcdef";
            NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
            
            NSData* encryptedData = [cryptoEngine encrypt:dataToEncrypt];
            
            [encryptedData shouldNotBeNil];
            NSData* decryptedData = [cryptoEngine decrypt:encryptedData];
            [decryptedData shouldNotBeNil];
            NSString* decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
            NSLog(@"Decrypted >>> %@", decryptedString);
            [[stringToEncrypt should] equal:decryptedString];
        });
        
        it(@"should return identical encrypted/decrypted data when less than 16 chars", ^{
            NSString* stringToEncrypt = @"0123456789abcde";
            NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
            
            NSData* encryptedData = [cryptoEngine encrypt:dataToEncrypt];
            
            [encryptedData shouldNotBeNil];
            NSData* decryptedData = [cryptoEngine decrypt:encryptedData];
            [decryptedData shouldNotBeNil];
            NSString* decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
            NSLog(@"Decrypted >>> %@", decryptedString);
            [[@"0123456789abcde" should] equal:decryptedString];
        });
        
        it(@"should return identical encrypted/decrypted data when data to encrypt is more than 16 chars", ^{
            NSString* stringToEncrypt = @"0123456789abcdef1234";
            NSData* dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
            
            NSData* encryptedData = [cryptoEngine encrypt:dataToEncrypt];
            
            [encryptedData shouldNotBeNil];
            NSData* decryptedData = [cryptoEngine decrypt:encryptedData];
            [decryptedData shouldNotBeNil];
            NSString* decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
            NSLog(@"Decrypted >>> %@", decryptedString);
            [[@"0123456789abcdef1234" should] equal:decryptedString];
        });
        
    });
    
});
SPEC_END



// TODO implement same test than for JavaScript implementation
/*
(function( $ ) {
 
    module( "PBKDF2 - Password-based key derivation" );
    
    test( "Password validation with random salt provided", function() {
        
        var hex = sjcl.codec.hex;
        rawPassword = AeroGear.crypto.deriveKey(PASSWORD);
        equal( hex.fromBits(rawPassword), ENCRYPTED_PASSWORD, "Password is not the same" );
        
    });
    
    module( "Symmetric encrytion with GCM" );
    
    test( "Encrypt raw bytes", function() {
        var hex = sjcl.codec.hex;
        var options = {
        IV: hex.toBits( BOB_IV ),
        AAD: hex.toBits( BOB_AAD ),
        key: hex.toBits( BOB_SECRET_KEY ),
        data: hex.toBits( MESSAGE )
        };
        var cipherText = AeroGear.crypto.encrypt( options );
        equal( hex.fromBits( cipherText ),  CIPHERTEXT, "Encryption has failed" );
    });
    
    test( "Decrypt raw bytes", function() {
        
        var hex = sjcl.codec.hex;
        
        var options = {
        IV: hex.toBits( BOB_IV ),
        AAD: hex.toBits( BOB_AAD ),
        key: hex.toBits( BOB_SECRET_KEY ),
        data: hex.toBits( MESSAGE )
        };
        options.data = AeroGear.crypto.encrypt( options );
        var plainText = AeroGear.crypto.decrypt ( options );
        equal( hex.fromBits( plainText ),  MESSAGE, "Encryption has failed" );
    });
    
    test( "Decrypt corrupted ciphertext", function() {
        var hex = sjcl.codec.hex;
        
        var options = {
        IV: hex.toBits( BOB_IV ),
        AAD: hex.toBits( BOB_AAD ),
        key: hex.toBits( BOB_SECRET_KEY ),
        data: hex.toBits( MESSAGE )
        };
        options.data = AeroGear.crypto.encrypt( options );
        options.data[23] = ' ';
        
        throws( function() {
            AeroGear.decrypt ( options )
        }, "Should throw an exception for corrupted ciphers");
    });
    
    test( "Decrypt with corrupted IV", function() {
        var hex = sjcl.codec.hex;
        
        var options = {
        IV: hex.toBits( BOB_IV ),
        AAD: hex.toBits( BOB_AAD ),
        key: hex.toBits( BOB_SECRET_KEY ),
        data: hex.toBits( MESSAGE )
        };
        options.data = AeroGear.crypto.encrypt( options );
        options.IV[23] = ' ';
        
        throws(function(){
            AeroGear.crypto.decrypt ( options )
        }, "Should throw an exception for corrupted IVs");
    });
    
    module( "Secure Hash Algorithm (SHA-256)" );
    
    test( "Should generated a valid SHA output", function() {
        var hex = sjcl.codec.hex;
        var digest = AeroGear.crypto.hash(SHA256_MESSAGE);
        equal( hex.fromBits( digest ),  SHA256_DIGEST, "Hash is invalid" );
    });
    
    test( "Should generated a valid SHA output for empty strings", function() {
        var hex = sjcl.codec.hex;
        var digest = AeroGear.crypto.hash("");
        equal( hex.fromBits( digest ),  SHA256_DIGEST_EMPTY_STRING, "Hash is invalid" );
    });
    
    module( "Digital signatures" );
    
    test( "Should generate a valid signature", function() {
        var options = {
        keys: sjcl.ecc.ecdsa.generateKeys(192),
        message: PLAIN_TEXT
        };
        options.signature = AeroGear.crypto.sign( options );
        var validation = AeroGear.crypto.verify( options );
        
        ok( validation, "Signature should be valid" );
        
    });
    
    test( "Should raise an error with corrupted key", function() {
        var options = {
        keys: sjcl.ecc.ecdsa.generateKeys(192),
        message: PLAIN_TEXT
        };
        options.signature = AeroGear.crypto.sign( options );
        options.keys = sjcl.ecc.ecdsa.generateKeys(192,10);
        
        throws(function(){
            AeroGear.crypto.verify( options );
        }, "Should throw an exception for corrupted or wrong keys");
    });
    
    test( "Should raise an error with corrupted signature", function() {
        var options = {
        keys: sjcl.ecc.ecdsa.generateKeys(192),
        message: PLAIN_TEXT
        };
        options.signature = AeroGear.crypto.sign( options );
        options.signature[1] = ' ';
        
        throws(function(){
            AeroGear.verify( options );
        }, "Should throw an exception for corrupted signatures");
    });
    
    test( "TODO", function() {
        ok( 1 == "1", "Passed!" );
    });
    
    
    module( "TODO - Asymmetric encryption with ECC" );
    
    test( "TODO", function() {
        ok( 1 == "1", "Passed!" );
    });
    
})( jQuery );*/