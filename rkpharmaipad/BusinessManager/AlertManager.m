//
//  AlertManager.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "AlertManager.h"
#import "WebService.h"

@implementation AlertManager

- (NSString*)GetReminderList
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetReminder];
    return string;//get and return webservice response 
}

- (NSString*)AddReminder:(id)reminder_object
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web AddReminder:reminder_object];
    return string;//get and return webservice response 
}

- (NSString*)DeleteReminder:(id)reminderid_object
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web DeleteReminder:reminderid_object];
    return string;//get and return webservice response 
}


@end
