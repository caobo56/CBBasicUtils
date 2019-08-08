//
//  CBAPIClient.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2019/8/5.
//  Copyright © 2019 caobo56. All rights reserved.
//

#import "CBAPIClient.h"

static NSString * const CBAPIClientLockName = @"com.cb.apiclient.manager.lock";


@interface CBProgressHandler : NSObject

- (instancetype)initWithTask:(NSURLSessionTask *)task;

@property (nonatomic, weak) CBAPIClient *client;

@property (nonatomic, strong) NSProgress *uploadProgress;
@property (nonatomic, strong) NSProgress *downloadProgress;

@property (nonatomic, copy) NetworkProgressHandler uploadProgressHandler;
@property (nonatomic, copy) NetworkProgressHandler downloadProgressHandler;

@end

@implementation CBProgressHandler

- (instancetype)initWithTask:(NSURLSessionTask *)task{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uploadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    _downloadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    __weak __typeof__(task) weakTask = task;
    
    for (NSProgress *progress in @[_uploadProgress,_downloadProgress]){
        progress.totalUnitCount = NSURLSessionTransferSizeUnknown;
        progress.cancellable = YES;
        progress.cancellationHandler = ^{
            [weakTask cancel];
        };
        progress.pausable = YES;
        progress.pausingHandler = ^{
            [weakTask suspend];
        };
        
#if AF_CAN_USE_AT_AVAILABLE
        if (@available(iOS 9, macOS 10.11, *))
#else
            if ([progress respondsToSelector:@selector(setResumingHandler:)])
#endif
            {
                if (@available(iOS 9.0, *)) {
                    progress.resumingHandler = ^{
                        [weakTask resume];
                    };
                } else {
                    // Fallback on earlier versions
                }
            }
        
        [progress addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self.downloadProgress removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
    [self.uploadProgress removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
}

#pragma mark - NSProgress Tracking

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isEqual:self.downloadProgress]) {
        if (self.downloadProgressHandler) {
            self.downloadProgressHandler((NSProgress *)object);
        }
    }else if ([object isEqual:self.uploadProgress]) {
        if (self.uploadProgressHandler) {
            self.uploadProgressHandler((NSProgress *)object);
        }
    }
}

@end



@interface CBAPIClient()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>

@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;

@property (readwrite, nonatomic, strong) NSURL *baseURL;

@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableHandlerByTaskIdentifier;

@property (readwrite, nonatomic, strong) NSLock *lock;


@end

@implementation CBAPIClient

#pragma  - mark Setting
+ (instancetype)client {
    return [[[self class] alloc] initWithBaseURL:nil];
}

- (instancetype)init {
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *__nullable)url {
    return [self initWithBaseURL:url sessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *__nullable)configuration {
    return [self initWithBaseURL:nil sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *__nullable)url
           sessionConfiguration:(NSURLSessionConfiguration *__nullable)configuration
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.sessionConfiguration = configuration;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
    
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    self.baseURL = url;
    
    self.requestSerializer = [CBAPIRequestSerializer serializer];
    self.responseSerializer = [CBAPIResponseSerializer serializer];
    
    self.mutableHandlerByTaskIdentifier = [[NSMutableDictionary alloc] init];
    
    self.lock = [[NSLock alloc] init];
    self.lock.name = CBAPIClientLockName;

    return self;
}

#pragma  - mark SendUrl
-(void)sendUrl:(NSString * __nonnull)url
        method:(NSString * __nonnull)method
        params:(NSDictionary * __nonnull)params
    upProgress:(NetworkProgressHandler __nullable)upProgress
  downProgress:(NetworkProgressHandler __nullable)downProgress
       success:(NetworkSuccessHandler __nonnull)success
       failure:(NetworkFailureHandler __nonnull)failure{
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:url relativeToURL:self.baseURL] absoluteString] parameters:params error:&serializationError];
    
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        return;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    __weak typeof(self) weakSelf = self;
    dataTask = [self dataTaskWithRequest:request uploadProgress:upProgress downloadProgress:downProgress completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf.responseSerializer serializeData:data response:response error:error completionHandler:^(NSData * _Nullable r_data, NSURLResponse * _Nullable r_response, NSError * _Nullable r_error) {
            if (error) {
                if (failure) {
                    failure(dataTask, r_error);
                }
            } else {
                if (success) {
                    success(dataTask, r_data);
                }
            }
        }];
    }];
    
    [dataTask resume];
}

-(void)sendUrl:(NSString * __nonnull)url
        method:(NSString * __nonnull)method
        params:(NSDictionary * __nonnull)params
    upProgress:(NetworkProgressHandler __nullable)upProgress
  downProgress:(NetworkProgressHandler __nullable)downProgress
    completion:(NetworkCompletion __nonnull)comp{
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:url relativeToURL:self.baseURL] absoluteString] parameters:params error:&serializationError];
    
    if (serializationError) {
        if (comp) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                comp(serializationError,nil);
            });
        }
        return;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    __weak typeof(self) weakSelf = self;
    dataTask = [self dataTaskWithRequest:request uploadProgress:upProgress downloadProgress:downProgress completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf.responseSerializer serializeData:data response:response error:error completionHandler:^(NSData * _Nullable r_data, NSURLResponse * _Nullable r_response, NSError * _Nullable r_error) {
            if (error) {
                if (comp) {
                    comp(r_error, nil);
                }
            } else {
                if (comp) {
                    comp(nil,r_data);
                }
            }
        }];
    }];
    [dataTask resume];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    __block NSURLSessionDataTask *dataTask = nil;
    cb_api_client_create_task_safely(^{
        dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            completionHandler(data,response,error);
        }];
    });
    
    [self addHandlerForDataTask:dataTask
                 uploadProgress:uploadProgressBlock
               downloadProgress:downloadProgressBlock];
    
    return dataTask;
}

- (CBProgressHandler *)handerForTask:(NSURLSessionTask *)task {
    NSParameterAssert(task);
    
    CBProgressHandler *hander = nil;
    [self.lock lock];
    hander = self.mutableHandlerByTaskIdentifier[@(task.taskIdentifier)];
    [self.lock unlock];
    return hander;
}

- (void)addHandlerForDataTask:(NSURLSessionDataTask *)dataTask
               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
            downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
{
    CBProgressHandler *hander = [[CBProgressHandler alloc] initWithTask:dataTask];
    hander.client = self;

    hander.uploadProgressHandler = uploadProgressBlock;
    hander.downloadProgressHandler = downloadProgressBlock;

    [self.lock lock];
    self.mutableHandlerByTaskIdentifier[@(dataTask.taskIdentifier)] = hander;
    [self.lock unlock];
}

- (void)removeHandlerForTask:(NSURLSessionTask *)task {
    [self.lock lock];
    [self.mutableHandlerByTaskIdentifier removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
}

static void cb_api_client_create_task_safely(dispatch_block_t block) {
    dispatch_sync(api_client_creation_queue(), block);
}

static dispatch_queue_t api_client_creation_queue() {
    static dispatch_queue_t cb_api_client_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cb_api_client_creation_queue = dispatch_queue_create("cb.api.client.creation.queue.name", DISPATCH_QUEUE_SERIAL);
    });
    
    return cb_api_client_creation_queue;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(__unused NSURLSession *)session
          dataTask:(__unused NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    CBProgressHandler * handler = [self handerForTask:dataTask];
    handler.downloadProgress.totalUnitCount = dataTask.countOfBytesExpectedToReceive;
    handler.downloadProgress.completedUnitCount = dataTask.countOfBytesReceived;
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    CBProgressHandler * handler = [self handerForTask:task];
    handler.uploadProgress.totalUnitCount = task.countOfBytesExpectedToSend;
    handler.uploadProgress.completedUnitCount = task.countOfBytesSent;
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [self removeHandlerForTask:task];
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    CBProgressHandler * handler = [self handerForTask:downloadTask];
    if (handler) {
        handler.downloadProgress.totalUnitCount = totalBytesExpectedToWrite;
        handler.downloadProgress.completedUnitCount = totalBytesWritten;
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes{
    CBProgressHandler * handler = [self handerForTask:downloadTask];
    handler.downloadProgress.totalUnitCount = expectedTotalBytes;
    handler.downloadProgress.completedUnitCount = fileOffset;
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    [self removeHandlerForTask:downloadTask];
}

#pragma  - mark SubSendUrl
-(void)getUrl:(NSString * )url
       params:(NSDictionary * )params
      success:(NetworkSuccessHandler)success
      failure:(NetworkFailureHandler)failure{
    [self sendUrl:url method:@"GET" params:params upProgress:nil downProgress:nil success:success failure:failure];
}

-(void)postUrl:(NSString * )url
        params:(NSDictionary * )params
       success:(NetworkSuccessHandler)success
       failure:(NetworkFailureHandler)failure{
    [self sendUrl:url method:@"POST" params:params upProgress:nil downProgress:nil success:success failure:failure];
}

-(void)deleteUrl:(NSString * )url
          params:(NSDictionary * )params
         success:(NetworkSuccessHandler)success
         failure:(NetworkFailureHandler)failure{
    [self sendUrl:url method:@"DELETE" params:params upProgress:nil downProgress:nil success:success failure:failure];
}

-(void)headUrl:(NSString * )url
        params:(NSDictionary * )params
       success:(NetworkSuccessHandler)success
       failure:(NetworkFailureHandler)failure{
    [self sendUrl:url method:@"HEAD" params:params upProgress:nil downProgress:nil success:success failure:failure];
}
-(void)putUrl:(NSString * )url
       params:(NSDictionary * )params
      success:(NetworkSuccessHandler)success
      failure:(NetworkFailureHandler)failure{
    [self sendUrl:url method:@"PUT" params:params upProgress:nil downProgress:nil success:success failure:failure];
}

-(void)patchUrl:(NSString * )url
         params:(NSDictionary * )params
        success:(NetworkSuccessHandler)success
        failure:(NetworkFailureHandler)failure{
    [self sendUrl:url method:@"PATCH" params:params upProgress:nil downProgress:nil success:success failure:failure];
}


#pragma  - mark SubSendUrl completion

-(void)getUrl:(NSString * )url
       params:(NSDictionary * )params
   completion:(NetworkCompletion __nonnull)comp{
    [self sendUrl:url method:@"GET" params:params upProgress:nil downProgress:nil completion:comp];
}


-(void)postUrl:(NSString * )url
        params:(NSDictionary * )params
    completion:(NetworkCompletion __nonnull)comp{
    [self sendUrl:url method:@"POST" params:params upProgress:nil downProgress:nil completion:comp];
}


-(void)deleteUrl:(NSString * )url
          params:(NSDictionary * )params
      completion:(NetworkCompletion __nonnull)comp{
    [self sendUrl:url method:@"DELETE" params:params upProgress:nil downProgress:nil completion:comp];
}


-(void)headUrl:(NSString * )url
        params:(NSDictionary * )params
    completion:(NetworkCompletion __nonnull)comp{
    [self sendUrl:url method:@"HEAD" params:params upProgress:nil downProgress:nil completion:comp];
}


-(void)putUrl:(NSString * )url
       params:(NSDictionary * )params
   completion:(NetworkCompletion __nonnull)comp{
    [self sendUrl:url method:@"PUT" params:params upProgress:nil downProgress:nil completion:comp];
}


-(void)patchUrl:(NSString * )url
         params:(NSDictionary * )params
     completion:(NetworkCompletion __nonnull)comp{
    [self sendUrl:url method:@"PATCH" params:params upProgress:nil downProgress:nil completion:comp];
}

@end

