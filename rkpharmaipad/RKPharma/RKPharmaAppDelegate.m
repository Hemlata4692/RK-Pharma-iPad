//  RKPharma Final
//  RKPharmaAppDelegate.m
//  RKPharma
//
//  Created by Shivendra  singh on 23/04/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "RKPharmaAppDelegate.h"
#import "DashboardViewController.h"
#import "User.h"
#import "UserManager.h"

@implementation RKPharmaAppDelegate

@synthesize window = _window;
@synthesize SampleDictionary,SampleId;
NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // 2
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    
    // 3
    [GAI sharedInstance].dispatchInterval = 5;
    
    // 4
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-55350878-1"];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    //[locationManager startUpdatingLocation];
    
//    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0 )
//    {
//        [locationManager requestWhenInUseAuthorization];
//    }
    
    [self startTrackingBg];
    timer = [NSTimer scheduledTimerWithTimeInterval: 300
                                             target: self
                                           selector: @selector(startTrackingBg)
                                           userInfo: nil
                                            repeats: YES];
    [timer fire];
    SampleDictionary = [NSDictionary new];
//      NSString *main_url=@"http://192.168.1.148/rkp/RKService.svc/";
    //   NSString *main_url=@"http://ranosys.info/rkpservice/RKService.svc/";
    NSString *main_url=@"http://rkpharma.com/rkpservice/rkservice.svc/";
    //NSString *main_url= @"http://rkpharma.com/email_issue/RKService.svc/";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setInteger:0 forKey:@"incrementNotify"];
    application.applicationIconBadgeNumber = 0;
    
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Recieved Notification %@",localNotif);
    }
    
    [defaults setObject:main_url forKey:@"main_url"];
    if ([[defaults valueForKey:@"UserId"] length] != 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        DashboardViewController *rvc = [storyboard instantiateViewControllerWithIdentifier:@"leftsidebar_screen"];
        self.window.rootViewController = rvc;
    }
    
//     UIApplication *app = [UIApplication sharedApplication];
//    if ([app respondsToSelector:@selector(registerUserNotificationSettings:)])
//    {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//        [app registerUserNotificationSettings:settings];
//        [app registerForRemoteNotifications];
//    }

    
   
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [timer invalidate];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[self findCurrentLocation];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(startTrackingBg) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
   
}

- (void) startTrackingBg
{
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        // If the status is denied or only granted for when in use, display an alert
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        } else if (status == kCLAuthorizationStatusNotDetermined) {
            [locationManager requestAlwaysAuthorization];
        }
    }

    [locationManager startUpdatingLocation];
    NSLog(@"Timer did fire");
}


- (void) changeAccuracy {
    
}
-(void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location updating1111");
    //NSLog(@"aaya");
    CLLocationCoordinate2D here = newLocation.coordinate;
    CLLocationCoordinate2D oldhere = oldLocation.coordinate;
    //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%f %f",here.latitude,here.longitude] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //    [alert show];
    NSLog(@"%f %f ", here.latitude, here.longitude);
    NSLog(@"%f %f ", oldhere.latitude, oldhere.longitude);
    //Create domain class object
    User *user=[[User alloc]init];
    
    NSString *latitude_string =[NSString stringWithFormat: @"%.2f", here.latitude];
    NSString *longitude_string =[NSString stringWithFormat: @"%.2f", here.longitude];
    
    NSString *oldlatitude_string =[NSString stringWithFormat: @"%.2f", oldhere.latitude];
    NSString *oldlongitude_string =[NSString stringWithFormat: @"%.2f", oldhere.longitude];
    
    

    
    
    if([oldlatitude_string isEqualToString:latitude_string] && [oldlongitude_string isEqualToString:longitude_string])
    {
        NSLog(@"Same");
        //[locationManager stopUpdatingLocation];
    }
    else
    {
        user.latitude = latitude_string;
        user.longitude = longitude_string;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         if ([[defaults valueForKey:@"UserId"] length] != 0)
         {
        //Create business manager class object
        UserManager *um_business=[[UserManager alloc]init];
        [um_business SendUserLocation:user];//call businessmanager login method and handle response
        [locationManager stopUpdatingLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"location updating2222");
    //NSLog(@"aaya");
    CLLocation *newLocation = (CLLocation *)[locations lastObject];
    CLLocationCoordinate2D here = newLocation.coordinate;
    //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%f %f",here.latitude,here.longitude] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //    [alert show];
    NSLog(@"%f %f ", here.latitude, here.longitude);
    //Create domain class object
    User *user=[[User alloc]init];
    
    NSString *latitude_string =[NSString stringWithFormat: @"%.2f", here.latitude];
    NSString *longitude_string =[NSString stringWithFormat: @"%.2f", here.longitude];
    
    
    
    user.latitude = latitude_string;
    user.longitude = longitude_string;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     if ([[defaults valueForKey:@"UserId"] length] != 0)
     {
    //Create business manager class object
    UserManager *um_business=[[UserManager alloc]init];
    [um_business SendUserLocation:user];//call businessmanager login method and handle response
     }
    [locationManager stopUpdatingLocation];
}





- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startTrackingBg];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   // NSString *main_url=@"http://192.168.1.53/rkp/RKService.svc/";
     NSString *main_url=@"http://ranosys.info/rkpservice/RKService.svc/";
//   NSString *main_url=@"http://rkpharma.com/rkpservice/rkservice.svc/";
    //NSString *main_url= @"http://rkpharma.com/email_issue/RKService.svc/";
    
//    [defaults setInteger:0 forKey:@"incrementNotify"];
     application.applicationIconBadgeNumber = 0;
    [defaults setObject:main_url forKey:@"main_url"];
    if ([[defaults valueForKey:@"UserId"] length] != 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        DashboardViewController *rvc = [storyboard instantiateViewControllerWithIdentifier:@"leftsidebar_screen"];
        self.window.rootViewController = rvc;
    }
    
//    
//    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"Meeting reminder"    message:@"Meeting in 30 minutes!"
//    delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    
//    [notificationAlert show];
    // NSLog(@"didReceiveLocalNotification");
    // NSLog(@"Recieved Notification %@",notification);
}
@end
