# aerogear-crypto-ios 

## Project Aim
_"Crypto for Humans"_

The aim of the project is to provide useful and easy to use API interfaces for performing advanced cryptographic techniques in the iOS platform. We base our work on the existing [Security and CommonCrypto](http://tinyurl.com/n6zf3le) services  already provided by the platform, but we strive to provide a friendlier interface around those services. Anyone who has tried to use those frameworks directly can understand the pain of using them (conversion of CF data types to Obj-C anyone?), let alone using them correctly. We understand that applying good cryptographic techniques is not an easy task and requires deep knowledge of the underlying concepts. But we _strongly_ believe a "friendlier" developer interface can ease the pain.

The project shares the same vision with our sibling AeroGear project [AeroGear-Crypto-Java](https://github.com/aerogear/aerogear-crypto-java). If you are a Java developer, we strongly recommend to look at the project. 

The project is also the base of providing cryptographic services to [AeroGear-IOS](http://www.aerogear.org) library project.

## Project Status
Currently we are in our initial stages, setting the ground for the next items to come. In particular, the following services are currently provided:

* A [Symmetric encryption](http://en.wikipedia.org/wiki/Symmetric-key_algorithm) interface
* Password based key generation using [PBKDF2](http://en.wikipedia.org/wiki/PBKDF2)
* Generation of Cryptographically secure [random numbers](http://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator).

Currently the [AeroGear-iOS](https://github.com/aerogear/aerogear-ios) library is already using it to provide initial versions of an encrypted memory and Property List versions of it's data stores interface. Have a look at the Cryptography support section [here](http://aerogear.org/docs/guides/iOSCookbook/) for a brief guide of example usage of the API. The page would be continuously enhanced as more items are added into the library.

## Ongoing work
Work is under way to provide the following features:

* An Asymmetric encryption interface
* Digital signatures support interface
* Hashing functions wrapper interface
* Apple's keychain wrapper interface
* Message authentication support

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which eases the pain of installing third-party libraries in your programs. The project is already published in the Cocoapods repository, so just add the following line in your _'Podfile'_ :

#### Podfile

```
pod "AeroGear-Crypto", '0.1.0'
```

## Join us
On-going work is tracked on project's [JIRA]((https://issues.jboss.org/browse/AGIOS) issue tracker as well as on our [mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-dev). You can also find the developers hanging on [IRC](irc://irc.freenode.net/aerogear), feel free to join in the discussions. We want your feedback!