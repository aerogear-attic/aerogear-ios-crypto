# aerogear-ios-crypto

![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)
[![circle-ci](https://img.shields.io/circleci/project/github/aerogear/aerogear-ios-crypto/master.svg)](https://circleci.com/gh/aerogear/aerogear-ios-crypto)
[![License](https://img.shields.io/badge/-Apache%202.0-blue.svg)](https://opensource.org/s/Apache-2.0)
[![GitHub release](https://img.shields.io/github/release/aerogear/aerogear-ios-crypto.svg)](https://github.com/aerogear/aerogear-ios-crypto/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/AeroGearCrypto.svg)](https://cocoapods.org/pods/AeroGearCrypto)
[![Platform](https://img.shields.io/cocoapods/p/AeroGearCrypto.svg)](https://cocoapods.org/pods/AeroGearCrypto)

Cryptographic services library

|                 | Project Info                                 |
| --------------- | -------------------------------------------- |
| License:        | Apache License, Version 2.0                  |
| Build:          | CocoaPods                                    |
| Languague:      | Objective-C                                  |
| Documentation:  | http://aerogear.org/ios/                     |
| Issue tracker:  | https://issues.jboss.org/browse/AGIOS        |
| Mailing lists:  | [aerogear-users](http://aerogear-users.1116366.n5.nabble.com/) ([subscribe](https://lists.jboss.org/mailman/listinfo/aerogear-users))                            |
|                 | [aerogear-dev](http://aerogear-dev.1069024.n5.nabble.com/) ([subscribe](https://lists.jboss.org/mailman/listinfo/aerogear-dev))     

## Table of Content

* [Features](#features)
* [Installation](#installation)
  * [CocoaPods](#cocoapods)
* [Usage](#usage)
  * [Password based key derivation](#password-based-key-derivation)
  * [Symmetric encryption](#symmetric-encryption)
  * [Asymmetric encryption](#asymmetric-encryption)
  * [Hashing functions](#hashing-functions)
  * [Digital Signatures](#digital-signatures)
  * [Generation of Cryptographically secure Random Numbers](#generation-of-cryptographically-secure-random-numbers)
* [Documentation](#documentation)
* [Demo apps](#demo-apps)
* [Development](#development)
* [Questions?](#questions)
* [Found a bug?](#found-a-bug)


## Features

* A [Symmetric encryption](http://nacl.cr.yp.to/secretbox.html) interface
* An [Asymmetric encryption interface](http://nacl.cr.yp.to/box.html)
* Password based key generation using [PBKDF2](http://en.wikipedia.org/wiki/PBKDF2)
* Generation of Cryptographically secure [random numbers](http://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator).
* [Digital signatures](http://ed25519.cr.yp.to) support interface 
* [Hashing functions](http://csrc.nist.gov/publications/fips/fips180-4/fips-180-4.pdf) interface

## Installation

### CocoaPods

In your `Podfile` add:

```bash
pod 'AeroGearCrypto'
```

and then:

```bash
pod install
```

to install your dependencies

## Usage

### Password based key derivation

```ObjC
AGPBKDF2 *pbkdf2 = [[AGPBKDF2 alloc] init];
NSData *rawKey = [pbkdf2 deriveKey:@"passphrase"];
```

### Symmetric encryption

```ObjC
//Generate the key
AGPBKDF2 *pbkdf2 = [[AGPBKDF2 alloc] init];
NSData *privateKey = [pbkdf2 deriveKey:@"passphrase"];

//Initializes the secret box
AGSecretBox *secretBox = [[AGSecretBox alloc] initWithKey:privateKey];

//Encryption
NSData *nonce = [AGRandomGenerator randomBytes:32];
NSData *dataToEncrypt = [@"My bonnie lies over the ocean" dataUsingEncoding:NSUTF8StringEncoding];

NSData *cipherData = [secretBox encrypt:dataToEncrypt nonce:nonce];

//Decryption
AGSecretBox *pandora = [[AGSecretBox alloc] initWithKey:privateKey];
NSData *message = [secretBox decrypt:cipherData nonce:nonce];
```

### Asymmetric encryption

```ObjC
//Create a new key pair
AGKeyPair *keyPairBob = [[AGKeyPair alloc] init];
AGKeyPair *keyPairAlice = [[AGKeyPair alloc] init];

//Initializes the crypto box
AGCryptoBox *cryptoBox = [[AGCryptoBox alloc] initWithKey:keyPairAlice.publicKey privateKey:keyPairBob.privateKey];

NSData *nonce = [AGRandomGenerator randomBytes:32];
NSData *dataToEncrypt = [@"My bonnie lies over the ocean" dataUsingEncoding:NSUTF8StringEncoding];

NSData *cipherData = [cryptoBox encrypt:dataToEncrypt nonce:nonce];

//Create a new box to test end to end asymmetric encryption
AGCryptoBox *pandora = [[AGCryptoBox alloc] initWithKey:keyPairBob.publicKey privateKey:keyPairAlice.privateKey];

NSData *message = [pandora decrypt:cipherData nonce:nonce];
```

### Hashing functions

```ObjC
// create an SHA256 hash
AGHash *agHash = [[AGHash alloc] init:CC_SHA256_DIGEST_LENGTH];
NSData *rawPassword = [agHash digest:@"My bonnie lies over the ocean"];

// create an SHA512 hash
AGHash *agHash = [[AGHash alloc] init:CC_SHA512_DIGEST_LENGTH];
NSData *rawPassword = [agHash digest:@"My bonnie lies over the ocean"];
```

### Digital Signatures

```ObjC
NSData *message = [@"My bonnie lies over the ocean" dataUsingEncoding:NSUTF8StringEncoding];
    
AGSigningKey *signingKey = [[AGSigningKey alloc] init];
AGVerifyKey *verifyKey = [[AGVerifyKey alloc] initWithKey:signingKey.publicKey];
// sign the message
NSData *signedMessage = [signingKey sign:message];

// should detect corrupted signature
NSMutableData *corruptedSignature = [NSMutableData dataWithLength:64];
BOOL isValid = [verifyKey verify:message signature:signedMessage];
   
// isValid should be YES
BOOL isValid = [verifyKey verify:message signature:corruptedSignature];
// isValid should be NO
```

### Generation of Cryptographically secure Random Numbers
```ObjC
NSData *random = [AGRandomGenerator randomBytes:<length>];
```
	
## Documentation

For more details about that please consult [our documentation](http://aerogear.org/ios/).

## Demo apps

Take a look in our demo apps:

* [CryptoPassword](https://github.com/aerogear/aerogear-ios-cookbook/tree/master/CryptoPassword)

## Development

If you would like to help develop AeroGear you can join our [developer's mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-dev), join #aerogear on Freenode, or shout at us on Twitter @aerogears.

Also takes some time and skim the [contributor guide](http://aerogear.org/docs/guides/Contributing/)

## Questions?

Join our [user mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-users) for any questions or help! We really hope you enjoy app development with AeroGear!

## Found a bug?

If you found a bug please create a ticket for us on [Jira](https://issues.jboss.org/browse/AGIOS) with some steps to reproduce it.
