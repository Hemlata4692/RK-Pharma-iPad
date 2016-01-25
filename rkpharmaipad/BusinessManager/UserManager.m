//
//  UserManager.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "UserManager.h"
#import "WebService.h"

@implementation UserManager

- (NSString*)login:(id)user_object
{
    //Call webservice method of login
    WebService *web=[[WebService alloc]init];
    NSString *abc=[web doLogin:user_object];
    return abc;//get and return webservice response 
}

- (NSString*)GeLocationList
{
    //Call webservice method of Location
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetArea];
    return string;//get and return webservice response 
}

- (NSString*)SendUserLocation:(id)user_object
{
    //Call webservice method of login
    WebService *web=[[WebService alloc]init];
    NSString *abc=[web SendUserLocation:user_object];
    return abc;//get and return webservice response 
}

@end
