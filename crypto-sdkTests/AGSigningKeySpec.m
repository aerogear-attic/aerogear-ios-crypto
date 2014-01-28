
#import <Kiwi/Kiwi.h>
#import "AGSigningKey.h"
#import "AGVerifyKey.h"


SPEC_BEGIN(AGSigningKeySpec)

        describe(@"AGSigningKey", ^{
            context(@"Keypair creation", ^{

                AGSigningKey * signingKey = [[AGSigningKey alloc] init];
                NSLog(@"Public key getter: %d", sizeof(signingKey.getPublicKey));


                //Sign the message
                NSString * m = @"Hello ladies";

                //NSData *s = [NSData dataWithBytes:signature length:sizeof(signature)];
                NSData *s = [signingKey sign:m];

                char const * message = [m UTF8String];
                unsigned char* signature = (unsigned char*) [s bytes];

                AGVerifyKey * verifyKey = [[AGVerifyKey alloc] init:signingKey.getPublicKey];
                BOOL *status = [verifyKey verify:message signature:signature];
                NSLog(@"Status: %d", status);


            });
        });

SPEC_END