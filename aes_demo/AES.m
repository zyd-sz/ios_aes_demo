//
//  AES.m
//  aes_demo
//
//  Created by mm on 2017/11/16.
//  Copyright © 2017年 mm. All rights reserved.
//

#import "AES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation AES

#pragma mark -- AES 256 ECB PKCS7Padding Encrypt
+(NSString *)encryptBase64:(NSString *)string :(NSString *)key{

    if([string isKindOfClass:[NSString class]] == NO || [key isKindOfClass:[NSString class]] == NO){
        NSLog(@"string和key必须为string!");
        return nil;
    }
    
    NSData *keyData;
    NSData *encryptData;
    NSData *resultData;
    NSString *resultString;
    
    /*1.密钥md5处理*/
    const char* str = [key UTF8String];
    unsigned char result[16];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16 * 2];
    for(int i = 0; i<16; i++) {
        [ret appendFormat:@"%02x",(unsigned int)(result[i])];
    }
    keyData = [ret dataUsingEncoding:NSUTF8StringEncoding];
    
    
    /*2.原数据base64处理*/
    NSString * base64string = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    encryptData = [base64string dataUsingEncoding:NSUTF8StringEncoding];

    

    /*3.进行AES加密*/
    NSUInteger dataLength = [encryptData length];    //對於塊加密算法，輸出大小總是等於或小於輸入大小加上一個塊的大小   ..所以在下邊需要再加上一個塊的大小
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,  [keyData bytes], kCCKeySizeAES256, NULL, [encryptData bytes], dataLength,buffer,bufferSize,&numBytesEncrypted);
    if (cryptStatus != kCCSuccess) {
        free(buffer);//釋放buffer
        NSLog(@"加密操作失败!");
        return nil;
    }
    resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    

    /*4.加密结果转成base64字符串*/
    resultString = [resultData base64EncodedStringWithOptions:0];
    return resultString;
}

#pragma mark -- AES 256 ECB PKCS7Padding Decrypt
+(NSString *)decryptBase64:(NSString *)string :(NSString *)key{
    
    if([string isKindOfClass:[NSString class]] == NO || [key isKindOfClass:[NSString class]] == NO){
        NSLog(@"string和key必须为string!");
        return nil;
    }
    
    NSData *keyData;
    NSData *decryptData;
    NSData *resultData;
    NSString *resultString;
    
    /*1.密钥md5处理*/
    const char* str = [key UTF8String];
    unsigned char result[16];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16 * 2];
    for(int i = 0; i<16; i++) {
        [ret appendFormat:@"%02x",(unsigned int)(result[i])];
    }
    keyData = [ret dataUsingEncoding:NSUTF8StringEncoding];
    
    /*2.密文数据base64转Data处理*/
    decryptData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if(decryptData.length == 0){
        NSLog(@"密文数据处理失败!2");
       return nil;
    }


    /*3.进行AES解密*/
    const void * keyPtr2 = [keyData bytes];
    const char (*keyPtr)[32] = keyPtr2;   //同理，解密中，密鑰也是32位的
    NSUInteger dataLength = [decryptData length]; //對於塊加密算法，輸出大小總是等於或小於輸入大小加上一個塊的大小   ..所以在下邊需要再加上一個塊的大小
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,keyPtr, kCCKeySizeAES256,NULL,[decryptData bytes],dataLength,buffer, bufferSize,&numBytesDecrypted);
    if (cryptStatus != kCCSuccess) {
        free(buffer);
        NSLog(@"解密操作失败!");
        return nil;
    }
    resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    /*4.base64解码*/
    NSString *base64String = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if(base64String == NULL){
        NSLog(@"解密操作失败!4");
        return nil;
    }
    

    NSData * DecodeBase64Data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if(DecodeBase64Data == NULL){
        NSLog(@"base64解码失败!4");
        return nil;
    }
    resultString = [[NSString alloc]initWithData:DecodeBase64Data encoding:NSUTF8StringEncoding];
    return resultString;
}




@end
