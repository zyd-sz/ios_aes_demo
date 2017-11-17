//
//  AES.h
//  aes_demo
//
//  Created by mm on 2017/11/16.
//  Copyright © 2017年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES : NSObject

//AES 256 ECB PKCS7Padding Encrypt
+(NSString *)encryptBase64:(NSString *)string :(NSString *)key;

+(NSString *)decryptBase64:(NSString *)string :(NSString *)key;

@end
