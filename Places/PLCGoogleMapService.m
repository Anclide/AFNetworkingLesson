//
//  PLCGoogleMapService.m
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "PLCGoogleMapService.h"
#import <AFNetworking.h>
#import "PLCLocationHelper.h"
#import "PLCPlaceMapper.h"
#import "ResultTableViewCell.h"

NSString *const PLCGoogleBaseURL = @"https://maps.googleapis.com/maps/api/place/";
NSString *const PLCGoogleAPIKey = @"AIzaSyBhpEhL8vvERVuY9ynrHuElB7kEKdWyiHI";

@interface PLCGoogleMapService()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *imageRequestManager;

@end


@implementation PLCGoogleMapService

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:PLCGoogleBaseURL];
        _requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _imageRequestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _imageRequestManager.responseSerializer = [AFImageResponseSerializer serializer];
    }
    return self;
}


- (void)getPlaceswithSearchRequest:(NSString*)searchRequest
                           success:(PLCSuccessBlock)successBlock
                           failure:(PLCFailureBlock)failure {
    
    NSDictionary *params = @{
                             @"key": PLCGoogleAPIKey,
                             @"query": searchRequest,
                             @"radius": @(1000)
                             };
    
    void(^success)(AFHTTPRequestOperation *, id) =
    ^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *placesModels = [NSMutableArray new];
        
        NSString *staus = responseObject[@"status"];
        NSLog(@"%@", staus);
        if (![staus isEqualToString:@"OK"]) {
            if (failure) {
                NSString *errorMessage = responseObject[@"error_message"];
                NSDictionary *dict = @{@"localizedDescription": errorMessage};
                NSError *error = [NSError errorWithDomain:@"PLCErrorDomain" code:-1 userInfo:dict];
                failure(error);
            }
        } else {
        
        NSArray *results = responseObject[@"results"];
        if (results.count == 0) {
            if (successBlock) {
                successBlock(@[]);
            }
        }
        for (NSDictionary *placeDict in results) {
            [placesModels addObject:[PLCPlaceMapper placeWithDictionary:placeDict]];
        }
        if (successBlock) {
            successBlock([placesModels copy]);
            }
            
        }
        
        
    };
    
    void(^fail)(id, NSError *) = ^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self.requestManager GET:@"https://maps.googleapis.com/maps/api/place/textsearch/json"
                  parameters:params
                     success:success
                     failure:fail];
    });
   
}

- (void)getPhotoOfPlaceWithPhotoReference:(NSString *)photoReference
                                  success:(PLCSuccessBlock)succeed
                                  failure:(PLCFailureBlock)failure {
    
    NSDictionary *photoParams = @{
                             @"key": PLCGoogleAPIKey,
                             @"maxheight": @(98),
                             @"photoreference":photoReference
                             };
    
    void(^success)(AFHTTPRequestOperation *, id) =
    ^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        UIImage *placeImage = (UIImage *)responseObject;
        
        if (succeed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                succeed(placeImage);
            });
        }
        
    };
    
    void(^fail)(id, NSError *) = ^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    };
    //Попытался решить ошибку с _BSMachError - не знаю, будет ли работать с этим, т.к. превысил количество запросов в день
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self.imageRequestManager GET:@"https://maps.googleapis.com/maps/api/place/photo"
                  parameters:photoParams
                     success:success
                     failure:fail];
    });
}

@end
