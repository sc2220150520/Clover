//
//  KWHTTPClient.h
//  AFNetworking
//
//  Created by lixingdong on 2017/10/16.
//

#import <Foundation/Foundation.h>
#import "LDNetworking.h"

NS_ASSUME_NONNULL_BEGIN

extern  NSString * const kLDKWNetworkingOriginalErrorKey;

@interface KWHTTPClient : NSObject

/**
 Access the singleton `LotteryHTTPClient` instance.
 
 @return The singleton `LotteryHTTPClient` instance.
 */
+ (instancetype)sharedInstance;


/**
 Configure the request common query component, user agent and server hosts which should be evaluated against the pinned SSL certificates.
 
 @param interfaceHeader The common query components for the request.
 @param userAgent       The user agent for the request.
 @param sslHosts        The server hosts which should be evaluated against the pinned SSL certificates.
 */
- (void)configClientWithInterfaceHeader:(nullable NSString *)interfaceHeader
                              userAgent:(nullable NSString *)userAgent
                               sslHosts:(nullable NSSet<NSString *> *)sslHosts;


/**
 Creates and an `LDBaseAPI` object with the specified HTTP method and URL string, then send the request.
 
 @param method          The HTTP method for the request, such as `GET`, `POST`, `PUT`, or `DELETE`.
 @param path            The URL string used to create the request URL.
 @param parameters      The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @param contentType     The automatical serializer type for responses sent from the server.
 @param completionBlock A block object to be executed when the request finishes. This block has no return value and takes three arguments: the request object, the response object created by that serializer, and the error that occurred, if any.
 @return An `LDBaseAPI` object.
 */
- (LDBaseAPI *)sendRequestWithMethod:(LDRequestMethodType)method
                                path:(NSString *)path
                          parameters:(nullable NSDictionary *)parameters
                         contentType:(LDResponseSerializerType)contentType
                     completionBlock:(nullable void (^)(LDBaseAPI *api, id _Nullable responseObject, NSError * _Nullable error))completionBlock;


/**
 Creates and an `LDBaseAPI` object with the specified HTTP method and URL string, then send the request.
 
 @param method      The HTTP method for the request, such as `GET`, `POST`, `PUT`, or `DELETE`.
 @param path        The URL string used to create the request URL.
 @param parameters  The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @param contentType The automatical serializer type for responses sent from the server.
 @param success     A block object to be executed when the request finishes successfully. This block has no return value and takes two arguments: the request object, and the response object created by the client response serializer.
 @param failure     A block object to be executed when the request finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 @return An `LDBaseAPI` object.
 */
- (LDBaseAPI *)sendRequestWithMethod:(LDRequestMethodType)method
                                path:(NSString *)path
                          parameters:(nullable NSDictionary *)parameters
                         contentType:(LDResponseSerializerType)contentType
                             success:(nullable void (^)(LDBaseAPI *api, id _Nullable responseObject))success
                             failure:(nullable void (^)(LDBaseAPI *api, NSError * _Nullable error))failure;


/**
 Creates and run an `LDBaseAPI` with a encypted `POST` request.
 
 @param path            The URL string used to create the request URL.
 @param parameters      The parameters to be either set as the request HTTP body.
 @param isURLEncoding   The request parameters will be URL encoded or not.
 @param timeStamp       The timestamp used to encpyt the request parameters.
 @param contentType     The automatical serializer type for responses sent from the server.
 @param completionBlock A block object to be executed when the request finishes. This block has no return value and takes three arguments: the request object, the response object created by that serializer, and the error that occurred, if any.
 @return An `LDBaseAPI` object.
 */
- (LDBaseAPI *)sendEncyptPostRequestWithPath:(NSString *)path
                                  parameters:(nullable NSDictionary *)parameters
                               isURLEncoding:(BOOL)isURLEncoding
                                   timeStamp:(nullable NSString *)timeStamp
                                 contentType:(LDResponseSerializerType)contentType
                             completionBlock:(nullable void (^)(LDBaseAPI *api, id _Nullable responseObject, NSError * _Nullable error))completionBlock;


/**
 Creates and run an `LDBaseAPI` with a encypted `POST` request.
 
 @param path          The URL string used to create the request URL.
 @param parameters    The parameters to be either set as the request HTTP body.
 @param isURLEncoding The request parameters will be URL encoded or not.
 @param timeStamp     The timestamp used to encpyt the request parameters.
 @param contentType   The automatical serializer type for responses sent from the server.
 @param success       A block object to be executed when the request finishes successfully. This block has no return value and takes two arguments: the request object, and the response object created by the client response serializer.
 @param failure       A block object to be executed when the request finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 @return An `LDBaseAPI` object.
 */
- (LDBaseAPI *)sendEncyptPostRequestWithPath:(NSString *)path
                                  parameters:(nullable NSDictionary *)parameters
                               isURLEncoding:(BOOL)isURLEncoding
                                   timeStamp:(nullable NSString *)timeStamp
                                 contentType:(LDResponseSerializerType)contentType
                                     success:(nullable void (^)(LDBaseAPI *api, id _Nullable responseObject))success
                                     failure:(nullable void (^)(LDBaseAPI *api, NSError * _Nullable error))failure;


/**
 Creates and runs an `LDBaseAPI` with a multipart `POST` request.
 
 @param path            The URL string used to create the request URL.
 @param parameters      The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @param contentType     The automatical serializer type for responses sent from the server.
 @param block           A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `LDMultipartFormData` protocol.
 @param completionBlock A block object to be executed when the request finishes. This block has no return value and takes three arguments: the request object, the response object created by that serializer, and the error that occurred, if any.
 @return An `LDBaseAPI` object.
 */
- (LDBaseAPI *)multipartHTTPRequestWithPath:(NSString *)path
                                 parameters:(nullable NSDictionary *)parameters
                                contentType:(LDResponseSerializerType)contentType
                  constructingBodyWithBlock:(nullable void (^)(id<LDMultipartFormData>))block
                            completionBlock:(nullable void (^)(LDBaseAPI *api, id _Nullable responseObject, NSError * _Nullable error))completionBlock;


/**
 Creates and runs an `LDBaseAPI` with a multipart `POST` request.
 
 @param path        The URL string used to create the request URL.
 @param parameters  The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @param contentType The automatical serializer type for responses sent from the server.
 @param block       A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `LDMultipartFormData` protocol.
 @param success     A block object to be executed when the request finishes successfully. This block has no return value and takes two arguments: the request object, and the response object created by the client response serializer.
 @param failure     A block object to be executed when the request finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 @return An `LDBaseAPI` object.
 */
- (LDBaseAPI *)multipartHTTPRequestWithPath:(NSString *)path
                                 parameters:(nullable NSDictionary *)parameters
                                contentType:(LDResponseSerializerType)contentType
                  constructingBodyWithBlock:(void (^)(id<LDMultipartFormData>))block
                                    success:(nullable void (^)(LDBaseAPI *api, id _Nullable responseObject))success
                                    failure:(nullable void (^)(LDBaseAPI *api, NSError * _Nullable error))failure;

@end

NS_ASSUME_NONNULL_END
