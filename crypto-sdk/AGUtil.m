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

#import "AGUtil.h"


@implementation AGUtil {

}

+ (NSData *)prependZeros:(NSUInteger)n msg:(NSString *)message {
    // allocate n+message.length buffer
    uint8_t * result = malloc( (n + message.length) * sizeof(uint8_t) );

    // 'zero' the contents
    memset((void *)result, 0x0, n + message.length);

    // extract c string
    const char *source = [message UTF8String];

    // copy from 'source' to 'result' starting from (result+n) pos
    memcpy(result+n, source, message.length);

    NSData *data = [NSData dataWithBytes:result length:n + message.length ];

    return data;
}

+ (NSMutableData *)prependZeros:(NSUInteger)n{
    // allocate n+message.length buffer
    uint8_t * result = malloc( n * sizeof(uint8_t) );

    // 'zero' the contents
    memset((void *)result, 0x0, n);

    NSMutableData *data = [NSMutableData dataWithBytes:result length:n];

    return data;
}

+ (BOOL) isValid:(NSUInteger)status msg:(NSString *)message {
    if (status != 0) {
        NSException* myException = [NSException
                exceptionWithName:@"RuntimeException"
                           reason:message
                         userInfo:nil];
        @throw myException;
    }
    return YES;
}

+ (NSData *) slice:(NSData *)buffer start:(NSUInteger)start end:(NSUInteger)end {
    return [buffer subdataWithRange:NSMakeRange(start, end)];
}

+ (void) checkLength:(NSData *) data size:(NSUInteger)size {
    if (data == nil || [data length] != size) {
        [NSException raise:@"RuntimeException"
                    format:@"Invalid size %ul", [data length]];
    }
}

+ (NSString*) hexString:(NSData *)data {
	NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([data length] * 2)];
	const unsigned char *dataBuffer = [data bytes];

	for (int i = 0; i < [data length]; ++i) {
        [stringBuffer appendFormat:@"%02X", dataBuffer[i]];
	}
	return stringBuffer;
}

@end