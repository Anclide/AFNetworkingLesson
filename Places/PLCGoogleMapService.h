//
//  PLCGoogleMapService.h
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^PLCSuccessBlock)(id);
typedef void(^PLCFailureBlock)(NSError *);

@interface PLCGoogleMapService : NSObject

- (void)getPlaceswithSearchRequest:(NSString*)searchRequest
                           success:(PLCSuccessBlock)successBlock
                           failure:(PLCFailureBlock)failure;

- (void)getPhotoOfPlaceWithPhotoReference:(NSString *)photoReference
                                  success:(PLCSuccessBlock)succeed
                                  failure:(PLCFailureBlock)failure;


@end
