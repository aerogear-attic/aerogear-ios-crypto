#import <libsodium-ios/sodium/crypto_sign_ed25519.h>
#import <libsodium-ios/sodium/randombytes.h>
#import <Kiwi/Kiwi.h>
#import "AGUtil.h"


SPEC_BEGIN(AGSigningKeySpec)

        describe(@"AGSigningKey", ^{
            context(@"Keypair creation", ^{

                const unsigned char publicKey[crypto_sign_ed25519_PUBLICKEYBYTES];
                const unsigned char secretKey[crypto_sign_ed25519_SECRETKEYBYTES];

                const unsigned long long bufferLen = crypto_sign_ed25519_SECRETKEYBYTES;
                unsigned char buffer[bufferLen];

                randombytes(buffer, bufferLen);

                //Generate the keypair
                crypto_sign_ed25519_seed_keypair(publicKey, secretKey, buffer);
                NSLog(@"PUBLIC KEY: %s", publicKey);

                //Sign the message
                NSString * message = @"Hello ladies";

                unsigned char *signature;
                unsigned long long smlen;
                unsigned char *convertedMessage = (const unsigned char *)[message cStringUsingEncoding:NSUTF8StringEncoding];
                unsigned long long mlen = strlen((const char*) convertedMessage);
                signature = malloc(mlen + crypto_sign_ed25519_BYTES);

                if( crypto_sign_ed25519(signature, &smlen, convertedMessage,
                        mlen, secretKey) != 0 ) {
                    NSLog(@"crypto_sign error");
                }
                NSLog(@"The code runs through here!");
                NSLog(@"Signature: %s", signature);


                //Verify the signature
                NSMutableData *data = [NSMutableData data];
                [data appendBytes:signature length:sizeof(signature)];
                [data appendBytes:convertedMessage length:sizeof(convertedMessage)];

                __block AGUtil* util = [[AGUtil alloc] init];
                NSMutableData *newBuffer = [util prependZeros:data.length];

                int status = crypto_sign_ed25519_open(newBuffer.mutableBytes, &smlen,
                        data.mutableBytes, mlen, publicKey);

                if( status != 0 ) {
                    NSLog(@"Invalid signature %i", status);
                }

            });
        });

SPEC_END