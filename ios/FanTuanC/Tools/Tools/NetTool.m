//
//  NetTool.m
//  
//
//  Created by shwally on 15/4/22.
//  Copyright (c) 2015年 shwally. All rights reserved.
//

#import "NetTool.h"
#import <AFNetworking.h>
#import "Reachability.h"
//#import "LoginViewController.h"

@implementation NetTool

+ (instancetype)shareInstance
{
    static NetTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetTool alloc] init];
    });
    return instance;
}

#pragma mark - 判断当前网络链接
- (BOOL) isConnectionAvailable
{
    BOOL isExistenceNetworking = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
            // 没有网络连接
            isExistenceNetworking = NO;
        }
            break;
        case ReachableViaWiFi:{
            // 使用WiFi网络
            isExistenceNetworking = YES;
        }
            break;
        case ReachableViaWWAN:{
            // 使用3G网络
            isExistenceNetworking = YES;
        }
            break;
        default:
            isExistenceNetworking = YES;
            break;
    }
    
    return isExistenceNetworking;
}

#pragma mark - wifi
- (BOOL)IsEnableWiFi
{
    return [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] !=NotReachable;
}

#pragma mark - 3G
- (BOOL)IsEnable3G
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}


+ (BOOL)isConnect
{
    BOOL isConnected = NO;
    NSURL *url = [NSURL URLWithString:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:nil];
    if (response == nil) {
        NSLog(@"没有网络");
        isConnected = NO;
    } else {
        NSLog(@"网络是通的");
        isConnected = YES;
    }
    
    return isConnected;
}

#pragma mark - 网络连接类型
- (NSString *)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
      formDataArray:(NSArray *)formDataArray
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    if(openHttpsSSL)
//    {
////        [manager setSecurityPolicy:[self customSecurityPolicy]];
//        [manager.securityPolicy setAllowInvalidCertificates:YES];
//        url = [self EncryptAESString:url];
//    }
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (FormData *fData in formDataArray) {
            [formData appendPartWithFileData:fData.data name:fData.name fileName:fData.filename mimeType:fData.mimeType];
        };
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
//            NSDictionary *responseObjectDic = [self dealresponseObject:responseObject];
//            success(responseObjectDic);
            
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postWithURL:(NSString *)url
//             params:(NSDictionary *)params
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    if(openHttpsSSL)
//    {
//        //        [manager setSecurityPolicy:[self customSecurityPolicy]];
//        [manager.securityPolicy setAllowInvalidCertificates:YES];
//        url = [self EncryptAESString:url];
//    }
    
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
//            NSDictionary *responseObjectDic = [self dealresponseObject:responseObject];
//            success(responseObjectDic);
            
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    if(openHttpsSSL)
//    {
//        //        [manager setSecurityPolicy:[self customSecurityPolicy]];
//        [manager.securityPolicy setAllowInvalidCertificates:YES];
//        url = [self EncryptAESString:url];
//    }
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES ? [[NSUserDefaults standardUserDefaults] objectForKey:kToken] : @"" forHTTPHeaderField:@"token"];
    NSLog(@" params:%@ \n token:%@ \n url:%@",params,[[NSUserDefaults standardUserDefaults] objectForKey:kToken],url);

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];

    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
//            NSDictionary *responseObjectDic = [self dealresponseObject:responseObject];
//            success(responseObjectDic);
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            
        }
    }];
}


- (void)getWithURL:(NSString *)url
//            params:(NSDictionary *)params
           success:(void (^)(id JSON))success
           failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    if(openHttpsSSL)
//    {
////        [manager setSecurityPolicy:[self customSecurityPolicy]];
//        
//        [manager.securityPolicy setAllowInvalidCertificates:YES];
//        
//        url = [self EncryptAESString:url];
//        NSLog(@"uuuuuuuuu  %@",url);
//    }
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
//            NSDictionary *responseObjectDic = [self dealresponseObject:responseObject];
//            success(responseObjectDic);
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        };
    }];
}

- (NSString *)EncryptAESString:(NSString *)url
{
    if ([url rangeOfString:@"?"].location != NSNotFound) {
        NSArray *array = [url componentsSeparatedByString:@"?"];
        NSString *httpsUrl = [array[0] stringByAppendingString:@"?vany="];
        NSString *parameterUrl = array[1];
        url = [httpsUrl stringByAppendingString:[[SecurityUtil encryptAESData:parameterUrl app_key:DecodeOrEncode_Key] uppercaseString]];
    }
    
    return url;
}

- (NSDictionary *)dealresponseObject:(NSDictionary *)responseObject{
    
    if (DecodeOrEncode_BOOL) {
        NSMutableDictionary *dic = [responseObject mutableCopy];
        NSString *passStr = [dic objectForKeyNotNull:@"encrypt"];
        
        if (passStr==nil) {
            return responseObject;
        }
        
        NSData *data = [MyTool convertHexStrToData:passStr];
        NSString * decryStr = [SecurityUtil decryptAESData:data app_key:DecodeOrEncode_Key];
        return [MyTool dictionaryWithJsonString:decryStr];
    }else{
        return responseObject;
    }
    
   
    
}

- (AFSecurityPolicy *)customSecurityPolicy
{

    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificatename ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
//    NSLog(@"%@",certData);
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

@end
