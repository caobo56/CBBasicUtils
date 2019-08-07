//
//  CBAPIRequestSerializer.h
//  BasicUtilsTest
//
//  Created by caobo56 on 2019/8/5.
//  Copyright © 2019 caobo56. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBAPIRequestSerializer : NSObject

@property (nonatomic, assign) NSStringEncoding stringEncoding;

@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (readonly, nonatomic, strong) NSDictionary <NSString *, NSString *> *HTTPRequestHeaders;

@property (nonatomic, strong) NSSet <NSString *> *HTTPMethodsEncodingParametersInURI;

- (void)setValue:(nullable NSString *)value
forHTTPHeaderField:(NSString *)field;

- (nullable NSString *)valueForHTTPHeaderField:(NSString *)field;

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password;

- (void)clearAuthorizationHeader;

+(instancetype)serializer;

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                URLString:(NSString *)urlstr
                               parameters:(NSDictionary *)params
                                    error:(NSError *__autoreleasing *)error;


@end

@interface CBAPIRequestJsonSerializer : CBAPIRequestSerializer


-(NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                URLString:(NSString *)urlstr
                               parameters:(NSDictionary *)params
                                    error:(NSError *__autoreleasing *)error;

@end

@interface CBAPIRequestFormSerializer : CBAPIRequestSerializer

@end

enum {
    NetworkErrCode_Unknown = 0,
    NetworkErrCode_ReqParamError,
    NetworkErrCode_ReqURLError,
    NetworkErrCode_RespSCNot200 = 200,
    NetworkErrCode_ResponseError = 400,
    NetworkErrCode_SerializerError,
    NetworkErrCode_DefaultError
};

extern NSString* const CBAPIResponseErrorData;

extern NSString* const CBAPIResponseSerializationErrorDomain;

extern NSString* const CBAPIClientKey;

#define CBERROR(c)  [NSError errorWithDomain:CBAPIResponseSerializationErrorDomain code:(c) userInfo:nil]
#define CBERROR_INFO(c,info)  [NSError errorWithDomain:CBAPIResponseSerializationErrorDomain code:(c) userInfo:(info)]

@interface CBAPIResponseSerializer : NSObject

+ (instancetype)serializer;

@property (nonatomic, copy, nullable) NSIndexSet *acceptableStatusCodes;

@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;

- (BOOL)validateResponse:(nullable NSHTTPURLResponse *)response
                    data:(nullable NSData *)data
                   error:(NSError * _Nullable __autoreleasing *)error;

- (void)serializeData:(NSData *)data
             response:(NSURLResponse * _Nullable)response
                error:(NSError * _Nullable)error
    completionHandler:(nullable void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

@end

@interface CBAPIResponseJsonSerializer : CBAPIResponseSerializer

@property (nonatomic, assign) BOOL removesKeysWithNullValues;
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

@end

@interface CBAPIResponseXMLParserSerializer : CBAPIResponseSerializer

@end

NS_ASSUME_NONNULL_END
