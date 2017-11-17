//
//  ViewController.m
//  aes_demo
//
//  Created by mm on 2017/11/16.
//  Copyright © 2017年 mm. All rights reserved.
//

#import "ViewController.h"

#import "AES.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *string = @"五笔拼音混合输入、纯五笔、纯拼音:多种输入模式向您提供便捷输入途径 词库随身:包括自造词在内的便捷同步,搜狗五笔是真正的互联网输入法 人性化设置:功能强大,兼";
    
   NSData* xmlData = [@"testdata" dataUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *str1 = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//
//
//    NSLog(@"%@",str1);
//
//
//    NSString *str2 = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//
//    NSLog(@"%@",str2);
    
    NSString * aesStr = [AES encryptBase64:string :@"1234567890"];

    if(aesStr == nil){
        NSLog(@"加密失败!");
        return;
    }
    
    NSLog(@"%@",aesStr);
    
    NSString * deStr = [AES decryptBase64: @"AloQMQ4ZZbHwKqLl8jWSeQVj7lmvT0StYx2HXw2lST2ivDi0nLBvKFC7fw8qnXwVkvaPXvsTTBmiIx2kxsBZlWhqAK40sMsVYwwtlThvaPptt/ppDfvETMq7ZdScwFn8FrpUzuDJTTvbdhvwGj4KolT5laCOI46c/SLLY4WAe9rWO6Y6v3gR9T8N13HJ9jNf5CsM6xK8DKJ1BANdw8FKs4ZJU93HY4R2qd5G/td3UBU9ebRDitoOry9tG1W0arBajR32smJAtdRrA4YyBne6EnK72Ze/jy71/r7OeQD98A+JYieXd5UO1+qJDZQZYK5vhPXyurX1B6Axea4oioVFo4EsrXHRObm9LGUmQM+x6vN+qplS1YPYaLjreydG5WAK7NbzdxLZGPNulse9BAuS+tR9aU/HkOWL5ptaJ2Nj/GI=" :@"1234567890"];
    
    if(deStr == nil){
        NSLog(@"解密失败!");
        return;
    }
    
    NSLog(@"----%@-----",deStr);
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
