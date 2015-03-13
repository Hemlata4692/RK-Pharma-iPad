//
//  AnnouncementManager.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementManager : NSObject
{
    NSMutableData *responseData;
}
- (NSString*)GetAnnouncement;
-(NSString*)GetAllAnnouncement;
@end
