//
//  UserManager.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject
{
    NSMutableData *responseData;
}
- (NSString*)login:(id)user_object;
- (NSString*)GeLocationList;
- (NSString*)SendUserLocation:(id)user_object;
@end
