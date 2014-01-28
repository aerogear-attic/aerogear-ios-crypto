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


@interface AGUtil : NSObject
+ (NSData *)prependZeros:(NSUInteger)n msg:(NSString *)message;
+ (NSData *)prependZeros:(NSUInteger)n;
+ (BOOL) isValid:(NSUInteger)status msg:(NSString *)message;
+ (NSData *) slice:(NSData *)buffer start:(NSUInteger)start end:(NSUInteger)end;
+ (void) checkLength:(NSData *) data size:(NSUInteger)size;
+ (NSString*) hexString:(NSData *)data;
@end