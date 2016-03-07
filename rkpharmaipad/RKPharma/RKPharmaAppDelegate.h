//
//  RKPharmaAppDelegate.h
//  RKPharma
//
//  Created by Shivendra  singh on 23/04/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RKPharmaAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    UIBackgroundTaskIdentifier bgTask;
    CLLocationManager *locationManager;
    NSTimer *timer;
}
@property(nonatomic,retain) NSDictionary *SampleDictionary;
@property(nonatomic,retain) NSString *SampleId;
@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain) NSNumber *delegateLatitude;
@property(nonatomic,retain) NSNumber *delegateLongitude;
@property(nonatomic,retain) NSString *isChecked;
@end