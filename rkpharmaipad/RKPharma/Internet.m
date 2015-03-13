//
//  Internet.m
//  RKPharma
//
//  Created by shiv vaishnav on 16/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "Internet.h"

@implementation Internet
{
    Reachability *reachability;
}
-(BOOL) start 
{
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) 
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Not connected to internet" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        return YES;
    }
    else {
        return NO;
    }
    
}

@end
