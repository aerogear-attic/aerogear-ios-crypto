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

#import <Foundation/Foundation.h>

/**
 * Utility class for cryptographic operations
 */
@interface AGUtil : NSObject

/**
* Append zeros to the message provided
* @param n number of zeros
* @param message
*/
+ (NSData *)prependZeros:(NSUInteger)n msg:(NSString *)message;

/**
* Initialize an empty buffer filled by zeros
* @param n number of zeros
*/
+ (NSData *)prependZeros:(NSUInteger)n;

/**
* Validate the size of the message, key and digital signature provied
* @param status value returned by the C library. Ex: 1 and -1
* @param message error message
*/
+ (BOOL) isValid:(NSUInteger)status msg:(NSString *)message;

/**
* Read a range of bytes from the buffer provided
* @param buffer provided
* @param start the initial index of the range
* @param end the final index of the range
*/
+ (NSData *) slice:(NSData *)buffer start:(NSUInteger)start end:(NSUInteger)end;

/**
* Validate the length of the data provided
* @param data provided. Ex: public key
* @param size length expected
*/
+ (void) checkLength:(NSData *) data size:(NSUInteger)size;

/**
* Convert the provided data to Hex
* @param data to be converted
*/
+ (NSString*) hexString:(NSData *)data;
@end