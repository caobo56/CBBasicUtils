//
//  CBAPIRequestSerializer.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2019/8/5.
//  Copyright © 2019 caobo56. All rights reserved.
//

#import "CBAPISerializer.h"
#import <UIKit/UIKit.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
#import <MobileCoreServices/MobileCoreServices.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#pragma -mark CBAPIRequestSerializer
@interface CBAPIRequestSerializer()

@property(nonatomic,strong)NSMutableURLRequest * request;
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;
@property (readwrite, nonatomic, strong) dispatch_queue_t requestHeaderModificationQueue;

@end

@implementation CBAPIRequestSerializer

+(instancetype)serializer{
    CBAPIRequestSerializer *serializer = [[self alloc] init];    
    return serializer;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.request = [[NSMutableURLRequest alloc]init];
    self.requestHeaderModificationQueue = dispatch_queue_create("requestHeaderModificationQueue", DISPATCH_QUEUE_CONCURRENT);

    self.stringEncoding = NSUTF8StringEncoding;
    self.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    self.timeoutInterval = 20.0f;
    self.mutableHTTPRequestHeaders = [NSMutableDictionary dictionary];
    self.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
    
    NSString *userAgent = nil;
#if TARGET_OS_IOS
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif TARGET_OS_WATCH
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    return self;
}

#pragma mark -

-(void)setStringEncoding:(NSStringEncoding)stringEncoding{
    _stringEncoding = stringEncoding;
}

- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy {
    _cachePolicy = cachePolicy;
    self.request.cachePolicy = _cachePolicy;
}

-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval{
    _timeoutInterval = timeoutInterval;
    self.request.timeoutInterval = _timeoutInterval;
}

- (NSDictionary *)HTTPRequestHeaders {
    NSDictionary __block *value;
    dispatch_sync(self.requestHeaderModificationQueue, ^{
        value = [NSDictionary dictionaryWithDictionary:self.mutableHTTPRequestHeaders];
    });
    return value;
}

- (void)setValue:(NSString *)value
forHTTPHeaderField:(NSString *)field
{
    dispatch_barrier_async(self.requestHeaderModificationQueue, ^{
        [self.mutableHTTPRequestHeaders setValue:value forKey:field];
    });
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    NSString __block *value;
    dispatch_sync(self.requestHeaderModificationQueue, ^{
        value = [self.mutableHTTPRequestHeaders valueForKey:field];
    });
    return value;
}

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password{
    NSData *basicAuthCredentials = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthCredentials = [basicAuthCredentials base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    [self setValue:[NSString stringWithFormat:@"Basic %@", base64AuthCredentials] forHTTPHeaderField:@"Authorization"];
}

- (void)clearAuthorizationHeader {
    dispatch_barrier_async(self.requestHeaderModificationQueue, ^{
        [self.mutableHTTPRequestHeaders removeObjectForKey:@"Authorization"];
    });
}

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                URLString:(NSString *)urlstr
                               parameters:(NSDictionary *)params
                                    error:(NSError *__autoreleasing *)error{
    NSParameterAssert(method);
    NSParameterAssert(urlstr);
    
    NSURL *url = [NSURL URLWithString:urlstr];
    
    NSParameterAssert(url);
    self.request.URL = url;
    self.request.HTTPMethod = [method uppercaseString];
    
    self.request = [[self requestBySerializingRequest:self.request withParameters:params error:error] mutableCopy];

    return self.request;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    NSString *query = nil;
    if (parameters) {
        query = CBQueryStringFromParameters(parameters);
    }
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[request HTTPMethod]]) {
        if (query && query.length > 0) {
            mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query]];
        }
    } else {
        // #2864: an empty string is a valid x-www-form-urlencoded payload
        if (!query) {
            query = @"";
        }
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
    }

    return mutableRequest;
}

NSString * CBQueryStringFromParameters(NSDictionary *parameters) {
    NSMutableArray* arr;
    if (parameters) {
        NSArray* keys=[parameters allKeys];
        if ([keys count]>0) {
            arr = [NSMutableArray arrayWithCapacity:[keys count]];
            for (NSString* key in keys) {
                [arr addObject:[NSString stringWithFormat:@"%@=%@",key,CBEncodeToPercentEscapeString([parameters[key] description])]];
            }
        }
    }
    return [arr componentsJoinedByString:@"&"];
}

NSString* CBEncodeToPercentEscapeString(NSString *input)
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)input,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

@end

@implementation CBAPIRequestJsonSerializer

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                URLString:(NSString *)urlstr
                               parameters:(NSDictionary *)params
                                    error:(NSError *__autoreleasing *)error{
    NSParameterAssert(method);
    NSParameterAssert(urlstr);
    
    NSURL *url = [NSURL URLWithString:urlstr];
    
    NSParameterAssert(url);
    self.request.URL = url;
    self.request.HTTPMethod = [method uppercaseString];
    
    [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    self.request = [[self requestBySerializingRequest:self.request withParameters:params error:error] mutableCopy];
    
    return self.request;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[request HTTPMethod]]) {
        NSString *query = nil;
        if (parameters) {
            query = CBQueryStringFromParameters(parameters);
        }
        if (query && query.length > 0) {
            mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query]];
        }
    } else {
        if (parameters) {
            NSData* dataC = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
            [mutableRequest setHTTPBody:dataC];
        }
    }
    return mutableRequest;
}

@end

@implementation CBAPIRequestFormSerializer

@end

#pragma -mark CBAPIResponseSerializer

NSString* const CBAPIResponseSerializationErrorDomain = @"cb.api.response.serialization.response.error";
NSString* const CBAPIResponseErrorData = @"cb.api.response.error.data";
NSString* const CBAPIClientKey = @"CBAPIClient";

@interface CBAPIResponseSerializer()

@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;
@property (readwrite, nonatomic, strong) dispatch_queue_t responseHeaderModificationQueue;

@end

@implementation CBAPIResponseSerializer

+(instancetype)serializer{
    CBAPIResponseSerializer *serializer = [[self alloc] init];
    return serializer;
}

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.responseHeaderModificationQueue = dispatch_queue_create("responseHeaderModificationQueue", DISPATCH_QUEUE_CONCURRENT);

    self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    self.acceptableContentTypes = nil;
    
    return self;
}

- (BOOL)validateResponse:(nullable NSHTTPURLResponse *)response
                    data:(nullable NSData *)data
                   error:(NSError * _Nullable __autoreleasing *)error{
    BOOL responseIsValid = YES;
    NSError *validationError = nil;
    if (self.acceptableContentTypes && ![self.acceptableContentTypes containsObject:[response MIMEType]] &&
        !([response MIMEType] == nil && [data length] == 0)) {
        
        if ([data length] > 0 && [response URL]) {
            NSMutableDictionary *mutableUserInfo = [@{
                                                      NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: unacceptable content-type: %@", @"AFNetworking", nil), [response MIMEType]],
                                                      NSURLErrorFailingURLErrorKey:[response URL],
                                                      CBAPIResponseErrorData: response,
                                                      } mutableCopy];
            if (data) {
                mutableUserInfo[CBAPIResponseErrorData] = data;
            }
            validationError = CBERROR_INFO(NetworkErrCode_ResponseError, mutableUserInfo);
        }
        responseIsValid = NO;
    }
    
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode] && [response URL]) {
            NSMutableDictionary *mutableUserInfo = [@{
                                                      NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: %@ (%ld)", CBAPIClientKey, nil), [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], (long)response.statusCode],
                                                      NSURLErrorFailingURLErrorKey:[response URL],
                                                      CBAPIResponseErrorData: response,
                                                      }
                                                    mutableCopy];
            
            if (data) {
                mutableUserInfo[CBAPIResponseErrorData] = data;
            }
            
            validationError = CBERROR_INFO(NetworkErrCode_ResponseError, mutableUserInfo);
            
            responseIsValid = NO;
        }
    }
    
    if (error && !responseIsValid) {
        *error = validationError;
    }
    
    return responseIsValid;
}

- (NSDictionary *)validateDictResponse:(nullable NSHTTPURLResponse *)response
                                  data:(nullable NSData *)data
                                 error:(NSError * _Nullable __autoreleasing)error{
    NSMutableDictionary * validation = [NSMutableDictionary dictionaryWithCapacity:2];
    BOOL responseIsValid = YES;
    NSError *validationError = nil;
    
    if (!response && error) {
        responseIsValid = NO;
    }
    
    if (self.acceptableContentTypes && ![self.acceptableContentTypes containsObject:[response MIMEType]] &&
        !([response MIMEType] == nil && [data length] == 0)) {
        
        if ([data length] > 0 && [response URL]) {
            NSMutableDictionary *mutableUserInfo = [@{
                                                      NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: unacceptable content-type: %@", @"AFNetworking", nil), [response MIMEType]],
                                                      NSURLErrorFailingURLErrorKey:[response URL],
                                                      CBAPIResponseErrorData: response,
                                                      } mutableCopy];
            if (data) {
                mutableUserInfo[CBAPIResponseErrorData] = data;
            }
            validationError = CBERROR_INFO(NetworkErrCode_ResponseError, mutableUserInfo);
        }
        responseIsValid = NO;
    }
    
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode] && [response URL]) {
            NSMutableDictionary *mutableUserInfo = [@{
                                                      NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: %@ (%ld)", CBAPIClientKey, nil), [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], (long)response.statusCode],
                                                      NSURLErrorFailingURLErrorKey:[response URL],
                                                      CBAPIResponseErrorData: response,
                                                      }
                                                    mutableCopy];
            
            if (data) {
                mutableUserInfo[CBAPIResponseErrorData] = data;
            }
            
            validationError = CBERROR_INFO(NetworkErrCode_ResponseError, mutableUserInfo);
            
            responseIsValid = NO;
        }
    }
    
    [validation setObject:@(responseIsValid) forKey:@"responseIsValid"];
    
    if (error && !responseIsValid) {
        validationError = error;
        [validation setObject:validationError forKey:@"validationError"];
    }
    
    return validation;
}


-(void)serializeData:(NSData *)data
            response:(NSURLResponse * _Nullable)response
               error:(NSError * _Nullable)error
   completionHandler:(nullable void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary * validateDict = [self validateDictResponse:httpResponse data:data error:error];
    if ([validateDict[@"responseIsValid"] boolValue]) {
        completionHandler(data,response,error);
    }else{
        error = CBERROR_INFO(NetworkErrCode_SerializerError,validateDict);
        completionHandler(data,response,error);
    }
}

@end

@implementation CBAPIResponseJsonSerializer

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.readingOptions = (NSJSONReadingOptions)0;
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/json",@"text/json",@"text/javascript", nil];

    return self;
}


-(void)serializeData:(NSData *)data
            response:(NSURLResponse * _Nullable)response
               error:(NSError * _Nullable)error
   completionHandler:(nullable void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary * validateDict = [self validateDictResponse:httpResponse data:data error:error];
    if ([validateDict[@"responseIsValid"] boolValue]) {
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&error];
        if (!responseObject)
        {
            if (error) {
                error = CBERROR_INFO(NetworkErrCode_SerializerError,@{});
            }
        }
        if (self.removesKeysWithNullValues) {
            responseObject = JSONObjectByRemovingKeysWithNullValues(responseObject, self.readingOptions);
        }
        completionHandler(responseObject,response,error);
    }else{
        error = CBERROR_INFO(NetworkErrCode_SerializerError,validateDict);
        completionHandler(data,response,error);
    }
}

static id JSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:JSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = JSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    
    return JSONObject;
}


@end

@implementation CBAPIResponseXMLParserSerializer

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", nil];

    return self;
}

-(void)serializeData:(NSData *)data
            response:(NSURLResponse * _Nullable)response
               error:(NSError * _Nullable)error
   completionHandler:(nullable void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary * validateDict = [self validateDictResponse:httpResponse data:data error:error];
    if ([validateDict[@"responseIsValid"] boolValue]) {
        id responseObject = [[NSXMLParser alloc] initWithData:data];

        if (!responseObject)
        {
            error = CBERROR_INFO(NetworkErrCode_SerializerError,@{});
        }
        
        completionHandler(responseObject,response,error);
    }else{
        error = CBERROR_INFO(NetworkErrCode_SerializerError,validateDict);
        completionHandler(data,response,error);
    }
}

@end
