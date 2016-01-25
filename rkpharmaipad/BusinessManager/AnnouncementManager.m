//
//  AnnouncementManager.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "AnnouncementManager.h"
#import "WebService.h"
#import "JSON.h"

@implementation AnnouncementManager

- (NSString*)GetAnnouncement
{
    //Call webservice method of login
    WebService *announcement_web=[[WebService alloc]init];
    NSString *announcement_string=[announcement_web GetAnnouncement];
    return announcement_string;//get and return webservice response 
}

- (NSString*)GetAllAnnouncement
{
    //Call webservice method of getting one latest announcement
    WebService *announcement_web=[[WebService alloc]init];
    NSString *announcement_string=[announcement_web GetAllAnnouncement];
    return announcement_string;//get and return webservice response
}

@end
