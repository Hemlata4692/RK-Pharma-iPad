//
//  DashboardViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "DashboardViewController.h"
#import "DailyPlanManager.h"
#import "DailyPlan.h"
#import "Announcement.h"
#import "AnnouncementManager.h"
#import "JSON.h"
#import "DejalActivityView.h"
#import "AnnouncementViewController.h"
#import "LeftSidebarViewController.h"
#import "AddClinicViewController.h"
#import "CallSummaryViewController.h"
#import "User.h"
#import "UserManager.h"
#import "CallCardViewController.h"

@interface DashboardViewController (){
    
    int isUpdate;
    int isLocationAlert;
}

@property (strong, nonatomic) IBOutlet UIButton *nearbyClinicOutlet;
@end

@implementation DashboardViewController
@synthesize Todaysplan_table,currentdate_label,currentweek_label,currentyear_label,currentmonth_label,announcementdate_label,announcementtitle_label,announcement_textview,clinicname_label,doctor_label,location_label,phone_label,dashboardusername_label,announcement_button,delete_button,clinichrsfrom1_label,clinichrsfrom2_label,clinichrsto1_label,clinichrsto2_label,fillsummary_button,addclinic_button,sno,clinicname_button;
@synthesize locationManager,purchaserName,dayOff,planDate,clinicAddress;
NSURLConnection *connection_dailyplan,*connection_announcement;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)displayActivityView;
{
    [DejalBezelActivityView activityViewForView:self.view];
}

- (void)removeActivityView;
{
    // Remove the activity view, with animation for the two styles that support it:
    [DejalBezelActivityView removeViewAnimated:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

//Added by rohit modi
- (IBAction)nearbyClinic:(UIButton *)sender {
    
    if (self.nearbyClinicOutlet.selected) {
        
        [self displayActivityView];
        self.nearbyClinicOutlet.selected = NO;
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                            [dailyplan_array removeAllObjects];
                               
                            [self dailyplanservice];
                           
                           [self removeActivityView];
                       });
    }
    else{
   
        self.nearbyClinicOutlet.selected = YES;
        isUpdate = 1;
        //        [self startTrackingBg];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        //        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }

         NSLog(@"%@,%@",myDelegate.delegateLatitude,myDelegate.delegateLongitude);
    }
}
//end
- (void)dailyplanservice
{
    NSDate *currentdateall = [NSDate date];
    NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
    [formatter_date setDateFormat:@"dd-MMM-yyyy "];
    NSString *date_str = [formatter_date stringFromDate:currentdateall];
    
    //Create domain class object
    DailyPlan *dailyplan=[[DailyPlan alloc]init];
    
    dailyplan.plan_date = date_str;
    
    //Create business manager class object
    DailyPlanManager *dm_business=[[DailyPlanManager alloc]init];
    NSString * dailyplan_response;//call businessmanager login method and handle response
    //Added by rohit modi
    if (_nearbyClinicOutlet.selected) {
        NSLog(@"%@,%@",myDelegate.delegateLatitude,myDelegate.delegateLongitude);
        dailyplan_response=[dm_business GetDailyPlan:dailyplan latitude:[NSString stringWithFormat:@"%@", myDelegate.delegateLatitude] longitude:[NSString stringWithFormat:@"%@", myDelegate.delegateLongitude] isLatLong:@"1"];
        
    }
    else{
        dailyplan_response=[dm_business GetDailyPlan:dailyplan latitude:@"" longitude:@"" isLatLong:@"0"];
    }
    //end
    if (dailyplan_response.length !=0) 
    {
        NSDictionary *var_dailyplan =  [dailyplan_response JSONValue];
        NSLog(@"dict Daily Plan%@",var_dailyplan);
        if (_nearbyClinicOutlet.selected) {
            
            myDelegate.isChecked = @"1";
        }
        else{
            myDelegate.isChecked = @"0";
        }
        
        for(NSDictionary *dictvar_dailypan in var_dailyplan)
        {
            if([[dictvar_dailypan objectForKey:@"Summary"] intValue]==0)
            {
                
                businesshours_array = [[NSMutableArray alloc]init];
                //[businesshour_string setString:@""];
                for(NSDictionary *dictbusinessvar in [dictvar_dailypan objectForKey:@"BusinessHours"])
                {
                    [businesshours_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictbusinessvar objectForKey:@"ClinicHrsTo"],@"ClinicHrsTo",[dictbusinessvar objectForKey:@"ClinicHrsFrom"],@"ClinicHrsFrom",nil]];
                }
                
                [dailyplan_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar_dailypan objectForKey:@"ClinicName"],@"clinic_name",[dictvar_dailypan objectForKey:@"DoctorName"],@"doctor_name",[dictvar_dailypan objectForKey:@"Location"],@"location",[dictvar_dailypan objectForKey:@"Phone"],@"phone",[dictvar_dailypan objectForKey:@"PlanId"],@"PlanId",businesshours_array,@"BusinessHours",[dictvar_dailypan objectForKey:@"IsLocked"],@"IsLocked",[dictvar_dailypan objectForKey:@"Summary"],@"Summary",[dictvar_dailypan objectForKey:@"UnPlanned"],@"UnPlanned",date_str,@"plan_date",[dictvar_dailypan objectForKey:@"LocationId"],@"LocationId",[dictvar_dailypan objectForKey:@"ClinicId"],@"ClinicId",[dictvar_dailypan objectForKey:@"ClinicAddress"],@"ClinicAddress",[dictvar_dailypan objectForKey:@"DaysOff"],@"Days_Off",[dictvar_dailypan objectForKey:@"PlanDate"],@"Plan_Date",[dictvar_dailypan objectForKey:@"PurchaserName"],@"Purchaser_Name",nil]];
            }
        }
        [Todaysplan_table reloadData];
        
        NSLog(@" Daily Plan %@",dailyplan_array);
        
        if(dailyplan_array.count == 0)
        {
            self.Todaysplan_table.frame = CGRectMake(10,193,821,0); 
        }
        else if(dailyplan_array.count == 1)
        {
            self.Todaysplan_table.frame = CGRectMake(10,193,821,105+129);
        }
//        else if(dailyplan_array.count == 2)
//        {
//            self.Todaysplan_table.frame = CGRectMake(10,193,821,210+129);
//        }
//        else if(dailyplan_array.count >= 3)
//        {
//            self.Todaysplan_table.frame = CGRectMake(10,193,821,315+129);
//        }
        //Added by rohit modi
        else if(dailyplan_array.count == 2)
        {
            self.Todaysplan_table.frame = CGRectMake(10,193,821,(105+129)*2);
        }
        else if(dailyplan_array.count >= 3)
        {
            self.Todaysplan_table.frame = CGRectMake(10,193,821,(105+129)*2 + 50);
        }

        //end
        
        
//        else if(dailyplan_array.count == 4)
//        {
//            self.Todaysplan_table.frame = CGRectMake(10,193,821,420+46);
//        }
//        else if(dailyplan_array.count >= 5)
//        {
//            self.Todaysplan_table.frame = CGRectMake(10,193,821,525+46);
//        }
    }
    else{
        
        _nearbyClinicOutlet.selected = !_nearbyClinicOutlet.selected;
    }
}

- (void)GetSingaporeTime
{
    //Create business manager class object
    DailyPlanManager *dp_business=[[DailyPlanManager alloc]init];
    NSString *response=[dp_business GetSingaporeTime];//call businessmanager method
    
    if (response.length !=0) 
    {
        NSDictionary *var =  [response JSONValue];
        
        NSArray* current_sgdate = [[var objectForKey:@"SGT"] componentsSeparatedByString: @" "];
        NSLog(@" SGT Date%@",[current_sgdate objectAtIndex: 0]);
        NSLog(@" SGT time%@",[current_sgdate objectAtIndex: 1]);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
        NSDate *date1=[formatter dateFromString:[var objectForKey:@"SGT"]];
        NSDate *date2=[formatter dateFromString:[NSString stringWithFormat:@"%@ %@",[current_sgdate objectAtIndex: 0],@"10:00 AM"]];
        
        NSLog(@" SGT %@",[var objectForKey:@"SGT"]);
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([date1 compare: date2] ==NSOrderedDescending)
        {
            NSString *Unplanned = @"1";
            NSLog(@"  Unplanned %@",Unplanned);
            [defaults setObject:Unplanned  forKey:@"Unplanned"];
            
            [addclinic_button setTitle:@"     Add Ad-hoc" forState:UIControlStateNormal];
        }
        else 
        {
            NSString *Unplanned = @"0";
            NSLog(@"  Unplanned %@",Unplanned);
            [defaults setObject:Unplanned  forKey:@"Unplanned"];
            [addclinic_button setTitle:@"    Add Clinic" forState:UIControlStateNormal];
        }
         
    }
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    
    //NSLog(@"aaya");
    CLLocationCoordinate2D here = newLocation.coordinate;
    
    myDelegate.delegateLatitude = [NSNumber numberWithDouble:here.latitude];
    myDelegate.delegateLongitude = [NSNumber numberWithDouble:here.longitude];
    
    if (isUpdate == 1) {
        
        isUpdate = 2;
            [self displayActivityView];
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               
                               [dailyplan_array removeAllObjects];
                               
                               [self dailyplanservice];
                               
                               [self removeActivityView];
                           });
//        }

    }
    [locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    //NSLog(@"aaya");
    CLLocation *newLocation = (CLLocation *)[locations lastObject];
    CLLocationCoordinate2D here = newLocation.coordinate;
    myDelegate.delegateLatitude = [NSNumber numberWithDouble:here.latitude];
    myDelegate.delegateLongitude = [NSNumber numberWithDouble:here.longitude];

    if (isUpdate == 1) {
        
        isUpdate = 2;
        [self displayActivityView];
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           
                           [dailyplan_array removeAllObjects];
                           
                           [self dailyplanservice];
                           
                           [self removeActivityView];
                       });
    }
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
//    
//    [locationManager stopUpdatingLocation];
//    isLocationAlert = 1;
//     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Setting" otherButtonTitles:@"Cancel", nil];
    
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied)
    {
        [locationManager stopUpdatingLocation];
        isLocationAlert = 1;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }

//     UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"Turn on Location Service to allow “RKPharma” to determine your location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Todaysplan_table.frame = CGRectMake(10,193,821,0);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        addclinic_button.hidden = YES;
    }
    else
    {
        addclinic_button.hidden = NO;
    }
    
    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    //    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    
//    NSTimer *timer;
//    
//    timer = [NSTimer scheduledTimerWithTimeInterval: 10
//                                             target: self
//                                           selector: @selector(startTrackingBg)
//                                           userInfo: nil
//                                            repeats: YES];
    
    //[locationManager startUpdatingLocation];
    
//    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(startUpdatingLocation) userInfo:nil repeats:YES];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    dailyplan_array = [[NSMutableArray alloc]init];
    NSDate *currentdateall = [NSDate date];
    NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
    [formatter_date setDateFormat:@"yyyy dd EEEE MMMM MMM"];
    //[formatter_date setDateFormat:@"dd"];
    NSString *date_str = [formatter_date stringFromDate:currentdateall];
    NSLog(@"Current Date %@",date_str);
    
    NSString *dashboard_usernamelabel = @"Welcome, ";
    dashboard_usernamelabel = [dashboard_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
    dashboardusername_label.text = [dashboard_usernamelabel capitalizedString];
    dashboardusername_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    [addclinic_button setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
    
    
    NSArray *date_array = [date_str componentsSeparatedByString:@" "];
    //NSString *current_year = [date_array objectAtIndex:0];
    NSString *current_week = [date_array objectAtIndex:2];
    NSString *current_date = [date_array objectAtIndex:1];
    NSString *current_month = [date_array objectAtIndex:4];
    
    current_month = [current_month stringByAppendingString:@", "];
    current_month = [current_month stringByAppendingString:[date_array objectAtIndex:0]];
    NSLog(@"Current Month %@",current_month);
    
    currentdate_label.text = current_date;
    currentdate_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    currentweek_label.text = current_week;
    currentweek_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    currentmonth_label.text = current_month;
    currentmonth_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    //currentyear_label.text = current_year;
    //currentyear_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    
    responseData_dailyplan = [NSMutableData data];
    responseData_announcement = [NSMutableData data];
    
    //To Hide Extra separators at the footer of tableview
    self.Todaysplan_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    // To Get Daily Plan from Webservice
//    NSString *jsonRequest_dailyplan = @"{\"Date\":\"24-Apr-2013\",\"UserId\":\"8ff72528-684e-44d8-a4b8-7277f83db3db\"}";
//    NSLog(@"Request Daily Plan: %@", jsonRequest_dailyplan);
//    NSURL *url_dailyplan = [NSURL URLWithString:@"http://ranosys.info/rkpservice/RKService.svc/GetDailyPlan"];
//    NSData *postData_dailyplan = [jsonRequest_dailyplan dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength_dailyplan = [NSString stringWithFormat:@"%d", [postData_dailyplan length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url_dailyplan];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength_dailyplan forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData_dailyplan];
//    connection_dailyplan = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    //Create domain class object
    //DailyPlan *dailyplan_domain=[[DailyPlan alloc]init];
    //dailyplan_domain.username=username.text;//set username value in domain class
    //dailyplan_domain.password=password.text;//set password value in domain class
    
       //    Added by rohit modi to dashboard checkbox
    isLocationAlert = 2;
    if ([myDelegate.isChecked isEqualToString:@"0"]) {
        
        _nearbyClinicOutlet.selected = NO;
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [dailyplan_array removeAllObjects];
                           
                           [self dailyplanservice];
                           
                           [self removeActivityView];
                       });

//        [self dailyplanservice];
    }
    else{
        
        isUpdate = 1;
        self.nearbyClinicOutlet.selected = YES;
        //            [self startTrackingBg];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        //        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        NSLog(@"%@,%@",myDelegate.delegateLatitude,myDelegate.delegateLongitude);
//        isUpdate = 1;
//            self.nearbyClinicOutlet.selected = YES;
//            [self startTrackingBg];
//            NSLog(@"%@,%@",myDelegate.delegateLatitude,myDelegate.delegateLongitude);
        
    }

    //Create business manager class object
    AnnouncementManager *am_business=[[AnnouncementManager alloc]init];
    NSString * announcement_response=[am_business GetAnnouncement];//call businessmanager login method and handle response
    
    if (announcement_response.length !=0) 
    {
        NSDictionary *var_announcement =  [announcement_response JSONValue];
        NSLog(@"dict Announcement%@",var_announcement);
        
        for(NSDictionary *dictvar_announcement in var_announcement)
        {
            announcementtitle_label.text = [dictvar_announcement objectForKey:@"Title"];
           // announcementdate_label.text = [dictvar_announcement objectForKey:@"AnnounceDate"];
            announcement_textview.text = [dictvar_announcement objectForKey:@"Announcement"];
            
            if(![[dictvar_announcement objectForKey:@"CreatedBy"] isEqualToString:@""])
            {
            
                NSString *announcement_date = [dictvar_announcement objectForKey:@"AnnounceDate"];
            
                announcement_date = [announcement_date stringByAppendingString:@",  "];
                announcement_date = [announcement_date stringByAppendingString:[dictvar_announcement objectForKey:@"CreatedBy"]];
                announcementdate_label.text = announcement_date;
            }
            else
            {
                announcementdate_label.text = [dictvar_announcement objectForKey:@"AnnounceDate"];
            }
        }
    }
    
    [self GetSingaporeTime];
    
}

-(void)viewWillAppear:(BOOL)animated{

//    isUpdate = 1;
}

- (void) startTrackingBg
{
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        // If the status is denied or only granted for when in use, display an alert
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            if (![CLLocationManager locationServicesEnabled]) {
                isLocationAlert = 1;
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"Turn on Location Service to allow “RKPharma” to determine your location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            else{
                 [locationManager startUpdatingLocation];
            }
//            [locationManager requestAlwaysAuthorization];
            
        }
        else if (status == kCLAuthorizationStatusDenied) {
            
//            if (![CLLocationManager locationServicesEnabled]) {
                isLocationAlert = 1;
                 UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
//             UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"Turn on Location Service to allow “RKPharma” to determine your location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
//            }
           
//            [locationManager requestAlwaysAuthorization];
            
        }
        else if (status == kCLAuthorizationStatusNotDetermined) {
//            }
            isLocationAlert = 1;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"Turn on Location Service to allow “RKPharma” to determine your location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

            [locationManager requestAlwaysAuthorization];
        }
        else if (status == kCLAuthorizationStatusRestricted) {
//            }
            isLocationAlert = 1;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"Turn on Location Service to allow “RKPharma” to determine your location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else{
                [locationManager startUpdatingLocation];
        }
   
    }
    NSLog(@"Timer did fire");
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    //    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    // If the status is denied or only granted for when in use, display an alert
    
    if (self.nearbyClinicOutlet.selected) {
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            if (![CLLocationManager locationServicesEnabled]) {
                isLocationAlert = 1;
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
                [alert show];
            }
            else{
                [locationManager startUpdatingLocation];
            }
            //            [locationManager requestAlwaysAuthorization];
            
        }
        else if (status == kCLAuthorizationStatusDenied) {
            
            //            if (![CLLocationManager locationServicesEnabled]) {
            isLocationAlert = 1;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
            [alert show];
            //            }
            
            //            [locationManager requestAlwaysAuthorization];
            
        }
        else if (status == kCLAuthorizationStatusNotDetermined) {
            //            }
            isLocationAlert = 1;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
            [alert show];
            
            [locationManager requestAlwaysAuthorization];
        }
        else if (status == kCLAuthorizationStatusRestricted) {
            //            }
            isLocationAlert = 1;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Turn on Location Service to Allow \"RKPharma\" to Determine Your Location" message:@"Need location for this app" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
        else{
            [locationManager startUpdatingLocation];
        }
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationLandscapeRight;
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return dailyplan_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105+129;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dailyplan_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[dailyplan_array objectAtIndex:indexPath.row];
    
//    clinicname_label=(UILabel *)[cell viewWithTag:1];
//    clinicname_label.text = [itemAtIndex objectForKey:@"clinic_name"];
//    if([[itemAtIndex objectForKey:@"UnPlanned"]intValue]==0)
//    {
//         clinicname_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
//    }
//    else 
//    {
//        clinicname_label.textColor= [UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
//    }
//    //clinicname_label.font = [UIFont fontWithName:@"Arial" size:14];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showcallcard:)];
//    [clinicname_label setUserInteractionEnabled:YES];
//    [clinicname_label addGestureRecognizer:tap];
    clinicname_button=(UIButton *)[cell viewWithTag:1];
    [clinicname_button setTitle:[itemAtIndex objectForKey:@"clinic_name"] forState:UIControlStateNormal];
    if([[itemAtIndex objectForKey:@"UnPlanned"]intValue]==0)
    {
        [clinicname_button setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
    }
    else 
    {
       [clinicname_button setTitleColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];;
    }
    [clinicname_button addTarget:self action:@selector(showcallcard:)forControlEvents:UIControlEventTouchUpInside];
    
    
    doctor_label=(UILabel *)[cell viewWithTag:2];
    doctor_label.text = [itemAtIndex objectForKey:@"doctor_name"];
    
    location_label=(UILabel *)[cell viewWithTag:3];
    location_label.text = [itemAtIndex objectForKey:@"location"];
    
    phone_label=(UILabel *)[cell viewWithTag:4];
    phone_label.text = [itemAtIndex objectForKey:@"phone"];
    
    purchaserName=(UILabel *)[cell viewWithTag:50];
    purchaserName.text = [itemAtIndex objectForKey:@"Purchaser_Name"];
    
    clinicAddress=(UILabel *)[cell viewWithTag:51];
    clinicAddress.text = [itemAtIndex objectForKey:@"ClinicAddress"];
    
    dayOff=(UILabel *)[cell viewWithTag:52];
    dayOff.text = [itemAtIndex objectForKey:@"Days_Off"];
    
    planDate=(UILabel *)[cell viewWithTag:53];
    planDate.text = [itemAtIndex objectForKey:@"Plan_Date"];
    
    
    
    NSMutableString *clinichrsfrom_string = [NSMutableString string];
    NSMutableString *clinichrsto_string = [NSMutableString string];
    for(NSDictionary *dictvar in [itemAtIndex objectForKey:@"BusinessHours"])
    {
        [clinichrsfrom_string appendString:[NSString stringWithFormat:@"%@,",[dictvar objectForKey:@"ClinicHrsFrom"]]];
        [clinichrsto_string appendString:[NSString stringWithFormat:@"%@,",[dictvar objectForKey:@"ClinicHrsTo"]]];
    }
    
    NSArray *clinichrsto_array = [clinichrsto_string componentsSeparatedByString:@","];
    NSArray *clinichrsfrom_array = [clinichrsfrom_string componentsSeparatedByString:@","];
    
    clinichrsfrom1_label=(UILabel *)[cell viewWithTag:9];
    if([[clinichrsfrom_array objectAtIndex:0] length]==0)
    {
        clinichrsfrom1_label.text = @"00:00:00";
    }
    else 
    {
        clinichrsfrom1_label.text = [clinichrsfrom_array objectAtIndex:0];
    }
    
    
    clinichrsfrom2_label=(UILabel *)[cell viewWithTag:7];
    if([[clinichrsfrom_array objectAtIndex:1] length]==0)
    {
        clinichrsfrom2_label.text = @"00:00:00";
    }
    else 
    {
        clinichrsfrom2_label.text = [clinichrsfrom_array objectAtIndex:1];
    }
    
    clinichrsto1_label=(UILabel *)[cell viewWithTag:6];
    if([[clinichrsto_array objectAtIndex:0] length]==0)
    {
        clinichrsto1_label.text = @"00:00:00";
    }
    else 
    {
        clinichrsto1_label.text = [clinichrsto_array objectAtIndex:0];
    }
    
    
    clinichrsto2_label=(UILabel *)[cell viewWithTag:8];
    if([[clinichrsto_array objectAtIndex:1] length]==0)
    {
        clinichrsto2_label.text = @"00:00:00";
    }
    else 
    {
        clinichrsto2_label.text = [clinichrsto_array objectAtIndex:1];
    }
    
    sno=(UILabel *)[cell viewWithTag:10];
    NSString *sno_string = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    sno_string = [sno_string stringByAppendingString:@"."];
    sno.text = sno_string;
    sno.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    UIImage *background = [UIImage imageNamed:@"listingbg_new.png"];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    
    fillsummary_button=(UIButton *)[cell viewWithTag:5];
    [fillsummary_button addTarget:self action:@selector(call_summary:)forControlEvents:UIControlEventTouchUpInside];
    
    if([[itemAtIndex objectForKey:@"Summary"] intValue]==1 || [[itemAtIndex objectForKey:@"IsLocked"] intValue]==1)
    {
        fillsummary_button.hidden = YES;
    }
    
    
    
     NSLog(@"Tag Value %d",[[itemAtIndex objectForKey:@"PlanId"] integerValue]);
    // Added Custom delete button to get tableview indexpath value 
    UIButton *accessory = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessory setImage:[UIImage imageNamed:@"deleteicon.png"] forState:UIControlStateNormal];
    accessory.frame = CGRectMake(0, 0, 33, 33);
    accessory.userInteractionEnabled = YES;
    [accessory addTarget:self action:@selector(delete_dailyplan:) forControlEvents:UIControlEventTouchUpInside];
    accessory.backgroundColor = [UIColor clearColor];
    cell.accessoryView = accessory;
    
    [cell.contentView addSubview:delete_button];
    
    
    return cell;
}

- (void)announcement_btn_clicked
{
    
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *top_usernamelabel = @"Welcome, ";
        top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
        
        
        LeftSidebarViewController *lftsbr=[[LeftSidebarViewController alloc]init];
        lftsbr.topheading_label.text = [top_usernamelabel capitalizedString];
        
        
        //lftsbr.topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        lftsbr.topheading_label.text = @"Admin Alerts";
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        announcementlistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"announcement_screen"];
        announcementlistcontroller.view.tag=990;
        announcementlistcontroller.view.frame=CGRectMake(0,0, 841, 723);
        
        [announcementlistcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [announcementlistcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        
        
        [self.view addSubview:announcementlistcontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Announcements",@"heading", nil]];
        [self removeActivityView];
    });
}

- (void)call_summary:(UIButton *)sender
{
    
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        
//        NSIndexPath *indexPath =[Todaysplan_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        
        CGPoint center= sender.center;
        CGPoint rootViewPoint = [sender.superview convertPoint:center toView:Todaysplan_table];
        NSIndexPath *indexPath = [Todaysplan_table indexPathForRowAtPoint:rootViewPoint];
        
        NSDictionary *itemAtIndex = (NSDictionary *)[dailyplan_array objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        
        callsummarycontroller = [storyboard instantiateViewControllerWithIdentifier:@"callsummary_screen"];
        callsummarycontroller.view.tag=991;
        callsummarycontroller.view.frame=CGRectMake(0,0, 841, 723);
        NSLog(@" PLANNNNNED DATE %@",[itemAtIndex objectForKey:@"plan_date"]);
        [callsummarycontroller PassValue:[NSDictionary dictionaryWithObjectsAndKeys:[itemAtIndex objectForKey:@"PlanId"],@"planid",[itemAtIndex objectForKey:@"location"],@"location",[itemAtIndex objectForKey:@"clinic_name"],@"clinic",[itemAtIndex objectForKey:@"plan_date"],@"plandate", nil]];
        [callsummarycontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [callsummarycontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        [self.view addSubview:callsummarycontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Call Summary",@"heading", nil]];
        [self removeActivityView];
    });
}

- (void)showcallcard:(UIButton *)sender
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        
//        UITableViewCell *clickedCell = (UITableViewCell *)[[[sender superview] superview]superview];
//        NSIndexPath *indexPath = [Todaysplan_table indexPathForCell:clickedCell];
//        NSLog(@"index=%d",indexPath.row);
        
        CGPoint center= sender.center;
        CGPoint rootViewPoint = [sender.superview convertPoint:center toView:Todaysplan_table];
        NSIndexPath *indexPath = [Todaysplan_table indexPathForRowAtPoint:rootViewPoint];
        
        //NSIndexPath *indexPath =[Todaysplan_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        NSDictionary *itemAtIndex = (NSDictionary *)[dailyplan_array objectAtIndex:indexPath.row];
        
        
        
        NSLog(@" Show Plan ID :%@",[itemAtIndex objectForKey:@"PlanId"]);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        
        callcardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"callcard_screen"];
        callcardcontroller.view.tag=991;
        callcardcontroller.view.frame=CGRectMake(0,0, 841, 723);
        [callcardcontroller PassValue:[NSDictionary dictionaryWithObjectsAndKeys:[itemAtIndex objectForKey:@"ClinicId"],@"clinicid",[itemAtIndex objectForKey:@"LocationId"],@"locationid",[itemAtIndex objectForKey:@"clinic_name"],@"clinic_name",[itemAtIndex objectForKey:@"ClinicAddress"],@"clinic_address", nil]];
        [callcardcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [callcardcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        [self.view addSubview:callcardcontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Call Card",@"heading", nil]];
        [self removeActivityView];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (isLocationAlert == 1) {
        
        isLocationAlert = 2;
        if (buttonIndex == 0)
        {
            
            self.nearbyClinicOutlet.selected = NO;
            myDelegate.isChecked = @"0";
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
        else if (buttonIndex == 1)
        {
            
            self.nearbyClinicOutlet.selected = NO;
            if ([myDelegate.isChecked isEqualToString:@"1"]) {
                myDelegate.isChecked = @"0";
                [self displayActivityView];
                //        self.nearbyClinicOutlet.selected = NO;
                double delayInSeconds = 0.3;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               
                               {
                                   [dailyplan_array removeAllObjects];
                                   
                                   [self dailyplanservice];
                                   
                                   [self removeActivityView];
                               });
                
            }
            
            //                self.nearbyClinicOutlet.selected = NO;
            //        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
            //        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //        [[UIApplication sharedApplication] openURL:url];
            //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];
            //               [defaults setObject:@"0" forKey:@"IsChecked"];
            //        if ([myDelegate.isChecked isEqualToString:@"1"]) {
            //            myDelegate.isChecked = @"0";
            //            [self displayActivityView];
            //            //        self.nearbyClinicOutlet.selected = NO;
            //            double delayInSeconds = 0.3;
            //            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
            //                           {
            //                               [dailyplan_array removeAllObjects];
            //
            //                               [self dailyplanservice];
            //
            //                               [self removeActivityView];
            //                           });
        }
        
        
    }
    else{
        if (buttonIndex == 0)
        {
            NSLog(@"Cancel Button Pressed");
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"Delete Button Pressed %d",alertView.tag);
            [self displayActivityView];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               DailyPlan *dailyplan=[[DailyPlan alloc]init];
                               NSString *planid = [NSString stringWithFormat:@"%d",alertView.tag];
                               dailyplan.plan_id = planid;
                               //Create business manager class object
                               DailyPlanManager *dm_business=[[DailyPlanManager alloc]init];
                               NSString * dailyplan_response=[dm_business DeleteDailyPlan:dailyplan];//call businessmanager login method and handle response
                               
                               if (dailyplan_response.length !=0) 
                               {
                                   NSDictionary *var_dailyplan =  [dailyplan_response JSONValue];
                                   NSLog(@"dict Delete Daily Plan%@",var_dailyplan);
                                   [dailyplan_array removeAllObjects];
                                   
                                   [self dailyplanservice];
                               }
                               [self removeActivityView];
                           });
        }
    }
}


- (void)delete_dailyplan:(UIButton *)sender
{
    
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:Todaysplan_table];
    NSIndexPath *indexPath = [Todaysplan_table indexPathForRowAtPoint:rootViewPoint];
    //NSIndexPath *indexPath = [Todaysplan_table indexPathForCell:(UITableViewCell *)[sender superview]];
    
    NSDictionary *itemAtIndex = (NSDictionary *)[dailyplan_array objectAtIndex:indexPath.row];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to delete this plan?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alert.tag = [[itemAtIndex objectForKey:@"PlanId"] intValue];
    [alert show];
    
//    [self displayActivityView];
//    double delayInSeconds = 1.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//    {
//        NSIndexPath *indexPath = [Todaysplan_table indexPathForCell:(UITableViewCell *)[sender superview]];
//        NSLog(@" Index Path %d",indexPath.row);
//        
//        NSDictionary *itemAtIndex = (NSDictionary *)[dailyplan_array objectAtIndex:indexPath.row];
//        NSLog(@"Plan Id :%@",[itemAtIndex objectForKey:@"PlanId"]);
//        //Create domain class object
//        DailyPlan *dailyplan=[[DailyPlan alloc]init];
//        dailyplan.plan_id = [itemAtIndex objectForKey:@"PlanId"];
//        //Create business manager class object
//        DailyPlanManager *dm_business=[[DailyPlanManager alloc]init];
//        NSString * dailyplan_response=[dm_business DeleteDailyPlan:dailyplan];//call businessmanager login method and handle response
//        
//        if (dailyplan_response.length !=0) 
//        {
//            NSDictionary *var_dailyplan =  [dailyplan_response JSONValue];
//            NSLog(@"dict Delete Daily Plan%@",var_dailyplan);
//            [dailyplan_array removeAllObjects];
//            [self dailyplanservice];
//        }
//        [self removeActivityView];
//    });
}

- (void)addclinic_btn_clicked
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *top_usernamelabel = @"Welcome, ";
        top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
        
        
        LeftSidebarViewController *lftsbr=[[LeftSidebarViewController alloc]init];
        lftsbr.topheading_label.text = top_usernamelabel;
        
        
        //lftsbr.topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        lftsbr.topheading_label.text = @"Add Clinic";
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        addcliniccontroller = [storyboard instantiateViewControllerWithIdentifier:@"addclinic_screen"];
        addcliniccontroller.view.tag=990;
        addcliniccontroller.view.frame=CGRectMake(0,0, 841, 723);
        
        [addcliniccontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [addcliniccontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        
        
        [self.view addSubview:addcliniccontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Add Clinic",@"heading", nil]];
        [self removeActivityView];
    });
}

@end