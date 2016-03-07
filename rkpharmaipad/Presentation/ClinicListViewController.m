//
//  ClinicListViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "ClinicListViewController.h"
#import "JSON.h"
#import "ClinicManager.h"
#import "Clinic.h"
#import "UserManager.h"
#import "DejalActivityView.h"
#import "ClinicDetailViewController.h"
#import "DailyPlan.h"
#import "DailyPlanManager.h"

NSString *locationid_selected = @"";
NSString *lastvisited_selected = @"";
NSString *specializationid_selected = @"";
NSString *cliniclist_unplanned = @"";
NSIndexPath* IndexrowCliniclist = 0;
int checkclinicpicker = 0;
int offset = 0;

@interface ClinicListViewController ()
{
    YHCPickerView *objYHCPickerView;
    NSMutableDictionary *dictglobdate,*dictglobFromTime,*dictglobToTime;
    NSDate *globdate,*globFromTime,*globToTime;
}
@end

@implementation ClinicListViewController
@synthesize clinic_table,search_pin_field,search_phone_field,search_clinic_field,search_doctor_field,clinic_name,doctor_name,phone_number,location,pin_code,search_area,location_picker,location_button,error_label,indicator,clinichrsfrom1_label,clinichrsfrom2_label,clinichrsto1_label,clinichrsto2_label,last_visit,sno,sno_label,lastvisited_button,lastvisited_picker,addtotodaysplan,specialization_picker,specialization_button,plandate,location_picker_toolbar,lastvisited_picker_toolbar,specialization_picker_toolbar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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

- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    location_picker.hidden=YES;
    location_picker_toolbar.hidden=YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = location_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, location_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}

- (void)pickerViewTapGestureRecognizedLastVisited:(UITapGestureRecognizer*)gestureRecognizer
{
    lastvisited_picker.hidden=YES;
    lastvisited_picker_toolbar.hidden = YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = lastvisited_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, lastvisited_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}

- (void)pickerViewTapGestureRecognizedSpecialization:(UITapGestureRecognizer*)gestureRecognizer
{
    specialization_picker.hidden=YES;
    specialization_picker_toolbar.hidden = YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = specialization_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, specialization_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}


-(IBAction)done_clicked:(id)sender
{
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
}
-(IBAction)done_clicked2:(id)sender
{
    specialization_picker.hidden=YES;
    specialization_picker_toolbar.hidden = YES;
}
-(IBAction)done_clicked3:(id)sender
{
    lastvisited_picker.hidden=YES;
    lastvisited_picker_toolbar.hidden = YES;
}
-(void)dismissKeyboard
{
    [objYHCPickerView hidePicker];
    checkclinicpicker=0;
    [self.view endEditing:YES];
    location_picker.hidden=YES;
    location_picker_toolbar.hidden=YES;
    lastvisited_picker.hidden=YES;
    lastvisited_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
}

-(IBAction)SpecializationService
{
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    // To Get Location
    NSString *response=[cm_business GetSpecialization];//call businessmanager Location method and handle response
    
    
    NSDictionary *var =  [response JSONValue];
    NSLog(@"dict Specialization List%@",var);
    
    [specialization_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"SpecializationId",@"All",@"SpecializationName",nil]];
    for(NSDictionary *dictvar in var)
    {
        [specialization_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Id"],@"SpecializationId",[dictvar objectForKey:@"Specialization"],@"SpecializationName",nil]];
        
    }
}


-(IBAction)ClinicService
{
    //Create domain class object
    Clinic *clinic=[[Clinic alloc]init];
    
    //set Clinic Name value in domain class
    clinic.location = locationid_selected;
    clinic.specialization_id = specializationid_selected;
    clinic.lastvisited = lastvisited_selected;
    if([search_clinic_field.text length] == 0)
    {
        clinic.clinic_name = @"all";
    }
    else
    {
        clinic.clinic_name = search_clinic_field.text;
    }
    
    if([search_phone_field.text length] == 0)
    {
        clinic.phone_number = @"";
    }
    else
    {
        clinic.phone_number = search_phone_field.text;
    }
    
    //    if([search_pin_field.text length] == 0)
    //    {
    //        clinic.pin_code = @"";
    //    }
    //    else
    //    {
    //        clinic.pin_code = search_pin_field.text;
    //    }
    
    //    if([search_doctor_field.text length] == 0)
    //    {
    //        clinic.doctor_name = @"";
    //    }
    //    else
    //    {
    //        clinic.doctor_name = search_doctor_field.text;
    //    }
    
    
    NSString *offsetstring = [NSString stringWithFormat:@"%d",offset];
    
    clinic.offset = offsetstring;
    
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    NSString *response=[cm_business GetClinicList:clinic];//call businessmanager login method and handle response
    
    
    NSDictionary *var =  [response JSONValue];
    NSLog(@"dict Clinic List%@",var);
    //NSMutableString *businesshour_string = [NSMutableString string];
    for(NSDictionary *dictvar in var)
    {
        businesshours_array = [[NSMutableArray alloc]init];
        //[businesshour_string setString:@""];
        for(NSDictionary *dictbusinessvar in [dictvar objectForKey:@"BusinessHours"])
        {
            [businesshours_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictbusinessvar objectForKey:@"ClinicHrsTo"],@"ClinicHrsTo",[dictbusinessvar objectForKey:@"ClinicHrsFrom"],@"ClinicHrsFrom",nil]];
        }
        
        [clinic_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Address"],@"Address",[dictvar objectForKey:@"ClinicId"],@"ClinicId",[dictvar objectForKey:@"ClinicName"],@"ClinicName",[dictvar objectForKey:@"Location"],@"Location",[dictvar objectForKey:@"PhoneNumber"],@"PhoneNumber",[dictvar objectForKey:@"PinCode"],@"PinCode",[dictvar objectForKey:@"PrimaryDoctor"],@"PrimaryDoctor",businesshours_array,@"BusinessHours",[dictvar objectForKey:@"LastVisited"],@"LastVisited",nil]];
        
        
        
    }
    
    // NSLog(@" Clinic Array %@",clinic_array);
    
    
    [clinic_table reloadData];
    
    if(clinic_array.count == 0)
    {
        self.clinic_table.frame = CGRectMake(10,62,821,0);
    }
    else if(clinic_array.count == 1)
    {
        self.clinic_table.frame = CGRectMake(10,62,821,135);
    }
    else if(clinic_array.count == 2)
    {
        self.clinic_table.frame = CGRectMake(10,62,821,270);
    }
    else if(clinic_array.count == 3)
    {
        self.clinic_table.frame = CGRectMake(10,62,821,405);
    }
    else if(clinic_array.count == 4)
    {
        self.clinic_table.frame = CGRectMake(10,62,821,540);
    }
    else if(clinic_array.count >= 5)
    {
        self.clinic_table.frame = CGRectMake(10,62,821,675);
    }
    
    if(clinic_array.count == 0)
    {
        error_label.text = @"No Record Found !";
    }
    else
    {
        error_label.text = @"";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dictglobdate=[NSMutableDictionary new];
    dictglobFromTime=[NSMutableDictionary new];
    dictglobToTime=[NSMutableDictionary new];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                // code here for when the user allows your app to access the calendar
                //[self performCalendarActivity:eventStore];
            } else {
                // code here for when the user does NOT allow your app to access the calendar
            }
        }];
    } else {
        // code here for iOS < 6.0
        //[self performCalendarActivity:eventStore];
    }

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"DidLoad List");
    locationid_selected = @"";
    lastvisited_selected = @"";
    specializationid_selected = @"";
    offset = 0;
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    
    
    // Initialization of Array
    clinic_array = [[NSMutableArray alloc]init];
    location_array = [[NSMutableArray alloc]init];
    lastvisited_array = [[NSMutableArray alloc]init];
    specialization_array = [[NSMutableArray alloc]init];
    [lastvisited_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Less than 15 days",@"LabelName",@"L15",@"LabelValue" ,nil]];
    [lastvisited_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Less than 30 days",@"LabelName",@"L30",@"LabelValue" ,nil]];
    [lastvisited_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"More than 30 days",@"LabelName",@"M30",@"LabelValue" ,nil]];
    [lastvisited_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"More than 60 days",@"LabelName",@"M60",@"LabelValue" ,nil]];
    [lastvisited_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"More than 90 days",@"LabelName",@"M90",@"LabelValue" ,nil]];
    [lastvisited_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Never",@"LabelName",@"Never",@"LabelValue" ,nil]];
    
    
    
    // To Set Search Error
    error_label.text = @"";
    
    // To Hide Load More indicator
    indicator.hidden = YES;
    
    // To Show Location Picker
    location_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(10,75+14,200,100)];
    location_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(10, 45,200,30+14)];
    //[location_picker_toolbar sizeToFit];
    location_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                     nil]
                           forState:UIControlStateNormal];
    [barItems addObject:doneBtn];
    [location_picker_toolbar setItems:barItems animated:YES];
    [self.view addSubview:location_picker_toolbar];
    /**********************/
    location_picker_toolbar.hidden = YES;
    
    // To Show Location Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [location_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:location_picker];
    
    [location_picker setDelegate:self];
    [location_picker setDataSource:self];
    location_picker.hidden=YES;
    location_picker_toolbar.hidden=YES;
    location_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    // To Show Specialization Picker
    specialization_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(342,75+14,200,100)];
    specialization_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(342, 45,200,30+14)];
    //[location_picker_toolbar sizeToFit];
    specialization_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems2 addObject:flexSpace2];
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked2:)];
    [doneBtn2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems2 addObject:doneBtn2];
    [specialization_picker_toolbar setItems:barItems2 animated:YES];
    [self.view addSubview:specialization_picker_toolbar];
    /**********************/
    specialization_picker_toolbar.hidden = YES;
    
    // To Show Specialization Picker View
    UITapGestureRecognizer *gestureRecognizerspecialization = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognizedSpecialization:)];
    gestureRecognizerspecialization.cancelsTouchesInView = NO;
    
    [specialization_picker addGestureRecognizer:gestureRecognizerspecialization];
    [self.view addSubview:specialization_picker];
    
    [specialization_picker setDelegate:self];
    [specialization_picker setDataSource:self];
    specialization_picker.hidden=YES;
    specialization_picker_toolbar.hidden = YES;
    specialization_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    // To Show Last Visited Picker
    lastvisited_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(619,75+14,200,100)];
    lastvisited_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(619, 45,200,30+14)];
    //[location_picker_toolbar sizeToFit];
    lastvisited_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems3 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems3 addObject:flexSpace3];
    UIBarButtonItem *doneBtn3 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked3:)];
    [doneBtn3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems3 addObject:doneBtn3];
    [lastvisited_picker_toolbar setItems:barItems3 animated:YES];
    [self.view addSubview:lastvisited_picker_toolbar];
    /**********************/
    lastvisited_picker_toolbar.hidden = YES;
    // To Show Last Visited Picker View
    UITapGestureRecognizer *gestureRecognizerLastVisited = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognizedLastVisited:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [lastvisited_picker addGestureRecognizer:gestureRecognizerLastVisited];
    [self.view addSubview:lastvisited_picker];
    
    [lastvisited_picker setDelegate:self];
    [lastvisited_picker setDataSource:self];
    lastvisited_picker.hidden=YES;
    lastvisited_picker_toolbar.hidden = YES;
    lastvisited_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    
    // To Show Left Padding in Search textfields
    UIView *AreapaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    search_area.leftView = AreapaddingView;
    search_area.leftViewMode = UITextFieldViewModeAlways;
    search_area.textColor= [UIColor colorWithRed:(123/255.0) green:(123/255.0) blue:(123/255.0) alpha:1];
    
    UIView *clinicpaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    search_clinic_field.leftView = clinicpaddingView;
    search_clinic_field.leftViewMode = UITextFieldViewModeAlways;
    search_clinic_field.textColor= [UIColor colorWithRed:(123/255.0) green:(123/255.0) blue:(123/255.0) alpha:1];
    
    UIView *clinicrightpaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    search_clinic_field.rightView = clinicrightpaddingView;
    search_clinic_field.rightViewMode = UITextFieldViewModeAlways;
    
    
    
    //    UIView *doctorpaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    //    search_doctor_field.leftView = doctorpaddingView;
    //    search_doctor_field.leftViewMode = UITextFieldViewModeAlways;
    //    search_doctor_field.textColor= [UIColor colorWithRed:(123/255.0) green:(123/255.0) blue:(123/255.0) alpha:1];
    
    UIView *phonepaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    search_phone_field.leftView = phonepaddingView;
    search_phone_field.leftViewMode = UITextFieldViewModeAlways;
    search_phone_field.textColor= [UIColor colorWithRed:(123/255.0) green:(123/255.0) blue:(123/255.0) alpha:1];
    
    //    UIView *pinpaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    //    search_pin_field.leftView = pinpaddingView;
    //    search_pin_field.leftViewMode = UITextFieldViewModeAlways;
    //    search_pin_field.textColor= [UIColor colorWithRed:(123/255.0) green:(123/255.0) blue:(123/255.0) alpha:1];
    
    // To Hide keyboard when touch outside of textfield
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                                   initWithTarget:self
    //                                   action:@selector(dismissKeyboard)];
    //
    //    [self.view addGestureRecognizer:tap];
    //    [tap setCancelsTouchesInView:NO];
    
    //To Hide Extra separators at the footer of tableview
    self.clinic_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    offset = 0;
    [self ClinicService];
    [self SpecializationService];
    
    //Create business manager class object
    UserManager *um_business=[[UserManager alloc]init];
    // To Get Location
    NSString *location_response=[um_business GeLocationList];//call businessmanager Location method and handle response
    
    if (location_response.length !=0)
    {
        NSDictionary *location_var =  [location_response JSONValue];
        NSLog(@"dict Location List%@",location_var);
        
        [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"LocationId",@"All",@"LocationName",nil]];
        for(NSDictionary *location_dictvar in location_var)
        {
            [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[location_dictvar objectForKey:@"LocationId"],@"LocationId",[location_dictvar objectForKey:@"LocationName"],@"LocationName",nil]];
            
        }
    }
    NSLog(@" Location Aray %@",location_array);
    clinicsArray = [[NSMutableArray alloc] init];
    
    //Create domain class object
    Clinic *clinic=[[Clinic alloc]init];
    
    //set Clinic Name value in domain class
    clinic.location = 0;
    
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    //    NSString *response=[cm_business GetClinicNameList:clinic];//call businessmanager  method and handle response
    NSString *response=[cm_business GetAllClinicList];
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict All Clinic Name List%@",var);
        NSString *displayNameString = @"All";
        [clinicsArray addObject:displayNameString];
        for(NSDictionary *dictvar in var)
        {
            //NSString *displayNameString = [locale displayNameForKey:[dictvar objectForKey:@"ClinicId"] value:[dictvar objectForKey:@"ClinicName"]];
            NSString *displayNameString = [dictvar objectForKey:@"ClinicName"];
            [clinicsArray addObject:displayNameString];
        }
        
    }
    
    [location_button setTitle:@"   Select Area" forState:UIControlStateNormal];
    [specialization_button setTitle:@"   Specialization" forState:UIControlStateNormal];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [objYHCPickerView hidePicker];
    //UITouch *touch = [[event allTouches] anyObject];
    UITouch *touch = [[event allTouches] anyObject];
    if ([search_clinic_field isFirstResponder] && [touch view] != search_clinic_field)
    {
        [search_clinic_field resignFirstResponder];
    }
    //    if ([search_doctor_field isFirstResponder] && [touch view] != search_doctor_field)
    //    {
    //        [search_doctor_field resignFirstResponder];
    //    }
    if ([search_phone_field isFirstResponder] && [touch view] != search_phone_field)
    {
        [search_phone_field resignFirstResponder];
    }
    //    if ([search_pin_field isFirstResponder] && [touch view] != search_pin_field)
    //    {
    //        [search_pin_field resignFirstResponder];
    //    }
    
    checkclinicpicker=0;
    [self.view endEditing:YES];
    location_picker.hidden=YES;
    location_picker_toolbar.hidden=YES;
    specialization_picker.hidden= YES;
    specialization_picker_toolbar.hidden = YES;
    lastvisited_picker.hidden=YES;
    lastvisited_picker_toolbar.hidden = YES;
    [super touchesBegan:touches withEvent:event];
}


-(void)viewDidAppear:(BOOL)animated
{
//    EKEventStore *eventStore = [[EKEventStore alloc] init];
//    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
//        // iOS 6 and later
//        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            if (granted) {
//                // code here for when the user allows your app to access the calendar
//                //[self performCalendarActivity:eventStore];
//            } else {
//                // code here for when the user does NOT allow your app to access the calendar
//            }
//        }];
//    } else {
//        // code here for iOS < 6.0
//        //[self performCalendarActivity:eventStore];
//    }
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height)
    {
        if(clinic_array.count >= offset && clinic_array.count >= 20)
        {
            indicator.hidden = NO;
            [self.indicator startAnimating];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               offset = offset + 20;
                               [self ClinicService];
                               [self.indicator stopAnimating];
                               indicator.hidden = YES;
                           });
        }
	}
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return clinic_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cliniclist_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[clinic_array objectAtIndex:indexPath.row];
    
    clinic_name=(UILabel *)[cell viewWithTag:1];
    clinic_name.text = [itemAtIndex objectForKey:@"ClinicName"];
    clinic_name.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    doctor_name=(UILabel *)[cell viewWithTag:2];
    doctor_name.text = [itemAtIndex objectForKey:@"PrimaryDoctor"];
    
    phone_number=(UILabel *)[cell viewWithTag:3];
    phone_number.text = [itemAtIndex objectForKey:@"PhoneNumber"];
    
    location=(UILabel *)[cell viewWithTag:4];
    location.text = [itemAtIndex objectForKey:@"Location"];
    
    pin_code=(UILabel *)[cell viewWithTag:5];
    pin_code.text = [itemAtIndex objectForKey:@"PinCode"];
    
    NSMutableString *clinichrsfrom_string = [NSMutableString string];
    NSMutableString *clinichrsto_string = [NSMutableString string];
    for(NSDictionary *dictvar in [itemAtIndex objectForKey:@"BusinessHours"])
    {
        [clinichrsfrom_string appendString:[NSString stringWithFormat:@"%@,",[dictvar objectForKey:@"ClinicHrsFrom"]]];
        [clinichrsto_string appendString:[NSString stringWithFormat:@"%@,",[dictvar objectForKey:@"ClinicHrsTo"]]];
    }
    NSArray *clinichrsto_array = [clinichrsto_string componentsSeparatedByString:@","];
    
    NSArray *clinichrsfrom_array = [clinichrsfrom_string componentsSeparatedByString:@","];
    
    last_visit=(UILabel *)[cell viewWithTag:6];
    last_visit.text = [itemAtIndex objectForKey:@"LastVisited"];
    
    clinichrsfrom1_label=(UILabel *)[cell viewWithTag:7];
    NSLog(@"Clinic HRS TO %d",[[clinichrsto_array objectAtIndex:1] length]);
    if([[clinichrsfrom_array objectAtIndex:0] length]==0)
    {
        clinichrsfrom1_label.text = @"00:00:00";
    }
    else
    {
        clinichrsfrom1_label.text = [clinichrsfrom_array objectAtIndex:0];
    }
    
    
    clinichrsfrom2_label=(UILabel *)[cell viewWithTag:9];
    if([[clinichrsfrom_array objectAtIndex:1] length]==0)
    {
        clinichrsfrom2_label.text = @"00:00:00";
    }
    else
    {
        clinichrsfrom2_label.text = [clinichrsfrom_array objectAtIndex:1];
    }
    
    clinichrsto1_label=(UILabel *)[cell viewWithTag:8];
    if([[clinichrsto_array objectAtIndex:0] length]==0)
    {
        clinichrsto1_label.text = @"00:00:00";
    }
    else
    {
        clinichrsto1_label.text = [clinichrsto_array objectAtIndex:0];
    }
    
    
    clinichrsto2_label=(UILabel *)[cell viewWithTag:10];
    if([[clinichrsto_array objectAtIndex:1] length]==0)
    {
        clinichrsto2_label.text = @"00:00:00";
    }
    else
    {
        clinichrsto2_label.text = [clinichrsto_array objectAtIndex:1];
    }
    
    addtotodaysplan=(UIButton *)[cell viewWithTag:14];
    [addtotodaysplan addTarget:self action:@selector(addtodayplan:)forControlEvents:UIControlEventTouchUpInside];
    addtotodaysplan.enabled=YES;
    
    [dictglobdate setObject:[NSDate date] forKey: [NSNumber numberWithLong:indexPath.row]];
    NSString *ditvalue=@"";
    [dictglobFromTime setObject:ditvalue forKey: [NSNumber numberWithLong:indexPath.row]];
    [dictglobToTime setObject:ditvalue forKey: [NSNumber numberWithLong:indexPath.row]];
    
    
    NSDate *currentdate = [NSDate date];
    NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
    [formatter_date setDateFormat:@"dd-MMM-yyyy"];
    
    plandate=(UIButton *)[cell viewWithTag:15];
    [plandate addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
    [plandate setTitle:[formatter_date stringFromDate:currentdate] forState:UIControlStateNormal];
    
    fromTime=(UIButton *)[cell viewWithTag:101];
    [fromTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
    //[fromTime setTitle:[formatter_date stringFromDate:currentdate] forState:UIControlStateNormal];
    
    toTime=(UIButton *)[cell viewWithTag:102];
    [toTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
   // [toTime setTitle:[formatter_date stringFromDate:currentdate] forState:UIControlStateNormal];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        plandate.hidden = YES;
        fromTime.hidden=YES;
        toTime.hidden=YES;
        addtotodaysplan.hidden = YES;
    }
    else
    {
        plandate.hidden = NO;
        fromTime.hidden=NO;
        toTime.hidden=NO;
        addtotodaysplan.hidden = NO;
    }
    
    
    sno_label=(UILabel *)[cell viewWithTag:12];
    sno_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    NSString *sno_string = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    sno_string = [sno_string stringByAppendingString:@"."];
    sno_label.text = sno_string;
    
    if(indexPath.row == 0)
    {
        UIImage *background_first = [UIImage imageNamed:@"listingbg_top.png"];
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background_first];
        cellBackgroundView.image = background_first;
        cell.backgroundView = cellBackgroundView;
        
    }
    else
    {
        UIImage *background = [UIImage imageNamed:@"listingbg_new.png"];
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
        cellBackgroundView.image = background;
        cell.backgroundView = cellBackgroundView;
    }
    
    cell.accessoryView = [[ UIImageView alloc ]
                          initWithImage:[UIImage imageNamed:@"arrow.png" ]];
    return cell;
}

- (void)HideDateLabel
{
    [toolbar removeFromSuperview];
    [DatePicker removeFromSuperview];
    
    UITableViewCell *cell = [clinic_table cellForRowAtIndexPath:IndexrowCliniclist];
    
    
    globFromTime=nil;
    globToTime=nil;
    NSString *ditvalue=@"";
    [dictglobdate setObject:ditvalue forKey: [NSNumber numberWithLong:IndexrowCliniclist.row]];
    [dictglobdate setObject:ditvalue forKey: [NSNumber numberWithLong:IndexrowCliniclist.row]];
    fromTime=(UIButton *)[cell viewWithTag:101];
    //[fromTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
    [fromTime setTitle:@"Start Time" forState:UIControlStateNormal];
    toTime=(UIButton *)[cell viewWithTag:102];
    
//    addtotodaysplan=(UIButton *)[cell viewWithTag:14];
//    addtotodaysplan.enabled=YES;
    //[fromTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
    [toTime setTitle:@"End Time" forState:UIControlStateNormal];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateto_string = @"";
    
    

    if ([DatePicker.date isEqualToDate:[NSDate date]]) {
        globdate=[NSDate date];
    }
    else{
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Extract date components into components1
    NSDateComponents *components1 = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                         fromDate:DatePicker.date];
    
    // Extract time components into components2
    NSDateComponents *components2 = [gregorianCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                                         fromDate:DatePicker.date];
    
    // Combine date and time into components3
    NSDateComponents *components3 = [[NSDateComponents alloc] init];
    
    [components3 setYear:components1.year];
    [components3 setMonth:components1.month];
    [components3 setDay:components1.day];
    
    [components3 setHour:0];
    [components3 setMinute:0];
    [components3 setSecond:0];
    
    // Generate a new NSDate from components3.
    NSDate *combinedDate = [gregorianCalendar dateFromComponents:components3];
    globdate=combinedDate;
    }
    
    [dictglobdate setObject:globdate forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    
    
    
    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:DatePicker.date]]];
    NSLog(@"DatePicker%@",dateto_string);
    
    //UITableViewCell *cell = [clinic_table cellForRowAtIndexPath:IndexrowCliniclist];
    // UITextField *textField = (UITextField *)[cell viewWithTag:1];
    
    plandate=(UIButton *)[cell viewWithTag:15];
    //[plandate addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
    [plandate setTitle:dateto_string forState:UIControlStateNormal];
    
    
}

- (void)HideFromTimeLabel
{
    [fromTimeToolbar removeFromSuperview];
    [fromTimePicker removeFromSuperview];
    
    UITableViewCell *cell = [clinic_table cellForRowAtIndexPath:IndexrowCliniclist];
    fromTime=(UIButton *)[cell viewWithTag:101];
    toTime=(UIButton *)[cell viewWithTag:102];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"hh:mm a"];
    NSString *dateto_string = @"";
    
    [dictglobFromTime setObject:fromTimePicker.date forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    globFromTime=[dictglobFromTime objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:fromTimePicker.date]]];
    NSLog(@"DatePicker%@",dateto_string);
    
        // UITextField *textField = (UITextField *)[cell viewWithTag:1];
//    addtotodaysplan=(UIButton *)[cell viewWithTag:14];
//    addtotodaysplan.enabled=NO;
    
    
    globdate=[dictglobdate objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d,yyyy"];
    NSString *CheckdateString = [dateFormat stringFromDate:globdate];
    
    //[fromTime setTitle:[formatter_date stringFromDate:currentdate] forState:UIControlStateNormal];
    [dateFormat setDateFormat:@"hh:mm a"];
    NSString *CheckFromTime = [dateFormat stringFromDate:globFromTime];
    
    [dateFormat setDateFormat:@"hh:mm a"];
    
    
    NSString *check=[dictglobToTime objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    if ([check isKindOfClass:[NSString class]]) {
        globToTime=nil;
    }
    else
        globToTime=[dictglobToTime objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    
    NSString *CheckTOTime = [dateFormat stringFromDate:globToTime];
    // NSString *CheckdateString = [dateFormat stringFromDate:today];
    [dateFormat setDateFormat:@"MMM d,yyyy hh:mm a"];
    
    NSString *startdate1= [NSString stringWithFormat:@"%@ %@",CheckdateString,CheckFromTime];
    NSString *enddate1= [NSString stringWithFormat:@"%@ %@",CheckdateString,CheckTOTime];
    
    NSDate *startDate = [dateFormat dateFromString:startdate1];
    NSDate *endDate = [dateFormat dateFromString:enddate1];

    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:30*60];
    NSLog(@"%f",[newDate timeIntervalSinceDate:[NSDate date]]);

    NSLog(@"%f",[startDate timeIntervalSinceDate:[NSDate date]]);
     NSLog(@"%f",[newDate timeIntervalSinceDate:[NSDate date]]);
    if (![toTime.currentTitle isEqualToString:@"End Time"]) {
        
        if ([startDate timeIntervalSinceDate:[NSDate date]]>=[newDate timeIntervalSinceDate:[NSDate date]]) {
            
            
            if ([endDate timeIntervalSinceDate:startDate]>=0.000000) {
                fromTime=(UIButton *)[cell viewWithTag:101];
                //[fromTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
                [fromTime setTitle:dateto_string forState:UIControlStateNormal];
                toTime=(UIButton *)[cell viewWithTag:102];
//                if (!([fromTime.currentTitle isEqualToString:@"Start Time"] || [toTime.currentTitle isEqualToString:@"End Time"])) {
//                    addtotodaysplan=(UIButton *)[cell viewWithTag:14];
//                    addtotodaysplan.enabled=YES;
//                }
            }
            else{
                globFromTime=nil;
                check=@"";
                [dictglobFromTime setObject:check forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
                [fromTime setTitle:@"Start Time" forState:UIControlStateNormal];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please set accurate time." delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
                [alert show];
                
            }
        }
        else{
            globFromTime=nil;
            check=@"";
            [dictglobFromTime setObject:check forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
            [fromTime setTitle:@"Start Time" forState:UIControlStateNormal];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There must be atleast half an hour difference between current time and plan time. " delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [alert show];
            
        }
    }
    else{
        if ([startDate timeIntervalSinceDate:[NSDate date]]>=[newDate timeIntervalSinceDate:[NSDate date]]) {
            fromTime=(UIButton *)[cell viewWithTag:101];
//            addtotodaysplan=(UIButton *)[cell viewWithTag:14];
//            addtotodaysplan.enabled=NO;

            //[fromTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
            [fromTime setTitle:dateto_string forState:UIControlStateNormal];
        }
        else{
            globFromTime=nil;
            check=@"";
            [dictglobFromTime setObject:check forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
            [fromTime setTitle:@"Start Time" forState:UIControlStateNormal];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There must be atleast half an hour difference between current time and plan time. " delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [alert show];
            
        }
    }
    
}

- (void)HideToTimeLabel
{
    [toTimeToolbar removeFromSuperview];
    [toTimePicker removeFromSuperview];
    UITableViewCell *cell = [clinic_table cellForRowAtIndexPath:IndexrowCliniclist];
    fromTime=(UIButton *)[cell viewWithTag:101];
    toTime=(UIButton *)[cell viewWithTag:102];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"hh:mm a"];
    NSString *dateto_string = @"";
    
    [dictglobToTime setObject:toTimePicker.date forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    globToTime=[dictglobToTime objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];

    
    
    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:toTimePicker.date]]];
    NSLog(@"DatePicker%@",dateto_string);
    
    
    // UITextField *textField = (UITextField *)[cell viewWithTag:1];
//    addtotodaysplan=(UIButton *)[cell viewWithTag:14];
//    addtotodaysplan.enabled=NO;
    
    // UITextField *textField = (UITextField *)[cell viewWithTag:1];
    
    
    
    globdate=[dictglobdate objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d,yyyy"];
    NSString *CheckdateString = [dateFormat stringFromDate:globdate];
    
    //[fromTime setTitle:[formatter_date stringFromDate:currentdate] forState:UIControlStateNormal];
    [dateFormat setDateFormat:@"hh:mm a"];
    
    
    NSString *check=[dictglobFromTime objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
    if ([check isKindOfClass:[NSString class]]) {
        globFromTime=nil;
    }
    else
        globFromTime=[dictglobFromTime objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];

    NSString *CheckFromTime = [dateFormat stringFromDate:globFromTime];
    
    [dateFormat setDateFormat:@"hh:mm a"];
    NSString *CheckTOTime = [dateFormat stringFromDate:globToTime];
    // NSString *CheckdateString = [dateFormat stringFromDate:today];
    [dateFormat setDateFormat:@"MMM d,yyyy hh:mm a"];
    
    NSString *startdate1= [NSString stringWithFormat:@"%@ %@",CheckdateString,CheckFromTime];
    NSString *enddate1= [NSString stringWithFormat:@"%@ %@",CheckdateString,CheckTOTime];
    
    NSDate *startDate = [dateFormat dateFromString:startdate1];
    NSDate *endDate = [dateFormat dateFromString:enddate1];
    
    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:30*60];
    NSLog(@"%f",[newDate timeIntervalSinceDate:[NSDate date]]);
    
    NSLog(@"%f",[endDate timeIntervalSinceDate:startDate]);
    if (![fromTime.currentTitle isEqualToString:@"Start Time"]) {
        
        if ([endDate timeIntervalSinceDate:[NSDate date]]>=[newDate timeIntervalSinceDate:[NSDate date]]) {
            if ([endDate timeIntervalSinceDate:startDate]>=0.000000) {
                toTime=(UIButton *)[cell viewWithTag:102];
                //[toTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
                [toTime setTitle:dateto_string forState:UIControlStateNormal];
               
            }
            else{
                globToTime=nil;
                check=@"";
                [dictglobToTime setObject:check forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
                [toTime setTitle:@"End Time" forState:UIControlStateNormal];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please set accurate time." delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
                [alert show];
                
            }
        }
        else{
            globToTime=nil;
            check=@"";
            [dictglobToTime setObject:check forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];           [toTime setTitle:@"End Time" forState:UIControlStateNormal];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There must be atleast half an hour difference between current time and event time. " delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [alert show];
            
        }
    }
    else{
        if ([endDate timeIntervalSinceDate:[NSDate date]]>=[newDate timeIntervalSinceDate:[NSDate date]]) {
            toTime=(UIButton *)[cell viewWithTag:102];
           

            //[toTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
            [toTime setTitle:dateto_string forState:UIControlStateNormal];
        }
        else{
            globToTime=nil;
            check=@"";
            [dictglobToTime setObject:check forKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
            [toTime setTitle:@"End Time" forState:UIControlStateNormal];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There must be atleast half an hour difference between current time and event time. " delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [alert show];
            
        }
        
    }
    
    
    
}

- (IBAction)SelectDateLabel:(id)sender
{
    NSLog(@"Check Date label");
}


- (void)selectplandate:(UIButton *)sender
{
    //NSIndexPath *indexPath =[clinic_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:clinic_table];
    NSIndexPath *indexPath = [clinic_table indexPathForRowAtPoint:rootViewPoint];
    
    IndexrowCliniclist = indexPath;
    
    NSLog(@" SELCT PLAB DAYTE %d",indexPath.row);
    if (sender.tag==15) {
        [toolbar removeFromSuperview];
        [DatePicker removeFromSuperview];
        
        
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(500, 250, 250, 50)];
        toolbar.barStyle=UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(HideDateLabel)];
        [toolbar setItems:[NSArray arrayWithObject:doneButton]];
        toolbar.tag = 1;
        [self.view addSubview:toolbar];
        
        // To create datepickers
        DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(500,300,250,150)];
        DatePicker.datePickerMode = UIDatePickerModeDate;
        DatePicker.date = [NSDate date];
        [DatePicker addTarget:self action:@selector(SelectDateLabel:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:DatePicker];
        DatePicker.hidden = NO;
        DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        DatePicker.minimumDate = [NSDate date];
    }
    else if (sender.tag==101){
        [fromTimeToolbar removeFromSuperview];
        [fromTimePicker removeFromSuperview];
        
        fromTimeToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(500, 250, 250, 50)];
        fromTimeToolbar.barStyle=UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(HideFromTimeLabel)];
        [fromTimeToolbar setItems:[NSArray arrayWithObject:doneButton]];
        fromTimeToolbar.tag = 103;
        [self.view addSubview:fromTimeToolbar];
        
        
        fromTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(500,300,250,150)];
        fromTimePicker.datePickerMode = UIDatePickerModeTime;
        
            globdate=[dictglobdate objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
        
        
        fromTimePicker.date = globdate;
        [fromTimePicker addTarget:self action:@selector(SelectDateLabel:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:fromTimePicker];
        fromTimePicker.hidden = NO;
        fromTimePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        fromTimePicker.minimumDate = globdate;
        
        // To create datepickers
        }
    else if(sender.tag==102){
        [toTimeToolbar removeFromSuperview];
        [toTimePicker removeFromSuperview];
        
        
        toTimeToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(500, 250, 250, 50)];
        toTimeToolbar.barStyle=UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(HideToTimeLabel)];
        [toTimeToolbar setItems:[NSArray arrayWithObject:doneButton]];
        toTimeToolbar.tag = 104;
        [self.view addSubview:toTimeToolbar];
        
        // To create toTimePickers
        toTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(500,300,250,150)];
        toTimePicker.datePickerMode = UIDatePickerModeTime;
        
        globdate=[dictglobdate objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
        
        toTimePicker.date = globdate;
        [toTimePicker addTarget:self action:@selector(SelectDateLabel:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:toTimePicker];
        toTimePicker.hidden = NO;
        toTimePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        toTimePicker.minimumDate = globdate;
    }
        
    
}



- (void)addtodayplan:(UIButton *)sender
{
    NSLog(@"Today's Plan");
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:clinic_table];
    NSIndexPath *indexPath = [clinic_table indexPathForRowAtPoint:rootViewPoint];
    IndexrowCliniclist = indexPath;
    UITableViewCell *maincell = [clinic_table cellForRowAtIndexPath:IndexrowCliniclist];
    fromTime=(UIButton *)[maincell viewWithTag:101];
    toTime=(UIButton *)[maincell viewWithTag:102];
    
    if (([toTime.currentTitle isEqualToString:@"End Time"] && [fromTime.currentTitle isEqualToString:@"Start Time"]) || (![toTime.currentTitle isEqualToString:@"End Time"] && ![fromTime.currentTitle isEqualToString:@"Start Time"]))
    
    {
    //NSLog(@"idarray %@..",IdArray);
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //Create business manager class object
                       
                      // NSLog(@"Selected date = %@",date);
                       
                       
                       
                       
                       DailyPlanManager *dp_business=[[DailyPlanManager alloc]init];
                       NSString *response_sgt=[dp_business GetSingaporeTime];//call businessmanager method
                       
                       if (response_sgt.length !=0)
                       {
                           NSDictionary *var_sgt =  [response_sgt JSONValue];
                           
                           NSArray* current_sgdate = [[var_sgt objectForKey:@"SGT"] componentsSeparatedByString: @" "];
                           NSLog(@" SGT Date%@",[current_sgdate objectAtIndex: 0]);
                           NSLog(@" SGT time%@",[current_sgdate objectAtIndex: 1]);
                           
                           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                           [formatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
                           NSDate *date1=[formatter dateFromString:[var_sgt objectForKey:@"SGT"]];
                           NSDate *date2=[formatter dateFromString:[NSString stringWithFormat:@"%@ %@",[current_sgdate objectAtIndex: 0],@"10:00 AM"]];
                           
                           NSLog(@" SGT %@",[var_sgt objectForKey:@"SGT"]);
                           if ([date1 compare: date2] ==NSOrderedDescending)
                           {
                               cliniclist_unplanned = @"1";
                           }
                           else
                           {
                               cliniclist_unplanned = @"0";
                           }
                           
                       }
                       
                      
                       
                       //NSIndexPath *indexPath =[clinic_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
                       NSDictionary *itemAtIndex = (NSDictionary *)[clinic_array objectAtIndex:indexPath.row];
                       
                       //NSDate *currentdateall = [NSDate date];
                       NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
                       [formatter_date setDateFormat:@"dd-MMM-yyyy"];
                       
                       //NSString *date_str = [formatter_date stringFromDate:currentdateall];
                       IndexrowCliniclist = indexPath;
                       UITableViewCell *cell = [clinic_table cellForRowAtIndexPath:IndexrowCliniclist];
                       // UITextField *textField = (UITextField *)[cell viewWithTag:1];
                       
                       plandate=(UIButton *)[cell viewWithTag:15];
                       NSLog(@" PLAN DATE %@",plandate.currentTitle);
                       //Create domain class object
                       DailyPlan *addclinic=[[DailyPlan alloc]init];
                       
                       addclinic.clinic_id = [itemAtIndex objectForKey:@"ClinicId"];
                       addclinic.plan_date = plandate.currentTitle;
                       addclinic.unplanned = cliniclist_unplanned;
                       addclinic.KIVclinic_id = @"";
                       
                       //Create business manager class object
                       DailyPlanManager *dpm_business=[[DailyPlanManager alloc]init];
                       NSString *response=[dpm_business AddClinics:addclinic] ;//call businessmanager  method and handle response
                       if (response.length !=0)
                       {
                           NSDictionary *var =  [response JSONValue];
                           NSLog(@"dict Clinic Name List%@",var);
                           
                           NSLog(@" RESSPONSSE %@",[var objectForKey:@"IsSuccess"]);
                           [self removeActivityView];
                           if([[var objectForKey:@"IsSuccess"] intValue]==1)
                           {
                               fromTime=(UIButton *)[cell viewWithTag:101];
                               
                               toTime=(UIButton *)[cell viewWithTag:102];
                               if ([toTime.currentTitle isEqualToString:@"End Time"] && [fromTime.currentTitle isEqualToString:@"Start Time"]) {
                                   
                               }
                               else{
                               
                               UITableViewCell *cell1 = [clinic_table cellForRowAtIndexPath:IndexrowCliniclist];
                               // UITextField *textField = (UITextField *)[cell viewWithTag:1];
                               
                               clinic_name=(UILabel *)[cell1 viewWithTag:1];
                               // clinic_name.text = [itemAtIndex objectForKey:@"ClinicName"];
                               
                               plandate=(UIButton *)[cell1 viewWithTag:15];
                               NSLog(@" PLAN DATE %@",plandate.currentTitle);
                               
                               
                                globdate=[dictglobdate objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
                               
                               
                               NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                               [dateFormat setDateFormat:@"MMM d,yyyy"];
                               NSString *CheckdateString = [dateFormat stringFromDate:globdate];
                               
                               
                               //[fromTime setTitle:[formatter_date stringFromDate:currentdate] forState:UIControlStateNormal];
                               fromTime=(UIButton *)[cell1 viewWithTag:101];
                               [dateFormat setDateFormat:@"hh:mm a"];
                                globFromTime=[dictglobFromTime objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
                               NSString *CheckFromTime = [dateFormat stringFromDate:globFromTime];
                               
                               toTime=(UIButton *)[cell1 viewWithTag:102];
                               [dateFormat setDateFormat:@"hh:mm a"];
                                globToTime=[dictglobToTime objectForKey:[NSNumber numberWithLong:IndexrowCliniclist.row]];
                               NSString *CheckTOTime = [dateFormat stringFromDate:globToTime];
                               // NSString *CheckdateString = [dateFormat stringFromDate:today];
                               [dateFormat setDateFormat:@"MMM d,yyyy hh:mm a"];
                               
                               NSString *startdate1= [NSString stringWithFormat:@"%@ %@",CheckdateString,CheckFromTime];
                               NSString *enddate1= [NSString stringWithFormat:@"%@ %@",CheckdateString,CheckTOTime];
                               
                               NSDate *startDate = [dateFormat dateFromString:startdate1];
                               NSDate *endDate = [dateFormat dateFromString:enddate1];
                               NSLog(@"%f",[endDate timeIntervalSinceDate:startDate]);
                               NSTimeInterval interval = 60* -30;
                               EKEventStore *eventDB = [[EKEventStore alloc] init];
                               EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
                               
                               myEvent.title     = @"Meeting reminder";
                               myEvent.startDate = startDate;
                               myEvent.endDate   = endDate;
                               myEvent.allDay = NO;
                               myEvent.notes = [NSString stringWithFormat:@"You have a plan added for %@",clinic_name.text];
                               
                               [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
                               EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval];
                               [myEvent addAlarm:alarm];
                               NSError *err;
                               NSTimeInterval notiInterval =[startDate timeIntervalSinceDate:[NSDate date]] -30*60;
                               NSLog(@"%f",[startDate timeIntervalSinceDate:[NSDate date]]);
                               
                               UILocalNotification *notification = [[UILocalNotification alloc] init];
                               notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:notiInterval];
                               notification.alertBody = @"Meeting in 30 minutes!";
                               notification.timeZone = [NSTimeZone defaultTimeZone];
                               notification.soundName = UILocalNotificationDefaultSoundName;
                               //                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               //                       int checkInc=(int)[defaults integerForKey:@"incrementNotify"] ;
                               //                       checkInc= checkInc+1;
                               
                               notification.applicationIconBadgeNumber = -1;
                               //
                               //                       [defaults setInteger:checkInc forKey:@"incrementNotify"];
                               
                               [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                               
                               [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
                               globdate=nil;
                               globFromTime=nil;
                               globToTime=nil;
                                   [dictglobdate setObject:[NSDate date] forKey: [NSNumber numberWithLong:indexPath.row]];
                                   NSString *ditvalue=@"";
                                   [dictglobFromTime setObject:ditvalue forKey: [NSNumber numberWithLong:indexPath.row]];
                                   [dictglobToTime setObject:ditvalue forKey: [NSNumber numberWithLong:indexPath.row]];
                               //[toTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
                               [fromTime setTitle:@"Start Time" forState:UIControlStateNormal];
                               [toTime setTitle:@"End Time" forState:UIControlStateNormal];
                               }
                               // NSString* str = [[NSString alloc] initWithFormat:@"%@", myEvent.eventIdentifier];
                               //  [arrayofEventId addObject:str];
                               //                       if (err == noErr) {
                               //                           UIAlertView *alert = [[UIAlertView alloc]
                               //                                                 initWithTitle:@"Event Created"
                               //                                                 message:@"Yay!?"
                               //                                                 delegate:nil
                               //                                                 cancelButtonTitle:@"Okay"
                               //                                                 otherButtonTitles:nil];
                               //                           [alert show];
                               //                           
                               //                           
                               //                       }
                               

                               
                               
                               UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Plan Added Succesfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                               [alert show];
                           }
                           else
                           {
                               globdate=nil;
                               globFromTime=nil;
                               globToTime=nil;
                               [dictglobdate setObject:[NSDate date] forKey: [NSNumber numberWithLong:indexPath.row]];
                               NSString *ditvalue=@"";
                               [dictglobFromTime setObject:ditvalue forKey: [NSNumber numberWithLong:indexPath.row]];
                               [dictglobToTime setObject:ditvalue forKey: [NSNumber numberWithLong:indexPath.row]];
                               //[toTime addTarget:self action:@selector(selectplandate:)forControlEvents:UIControlEventTouchUpInside];
                               [fromTime setTitle:@"Start Time" forState:UIControlStateNormal];
                               [toTime setTitle:@"End Time" forState:UIControlStateNormal];
                           }
                       }
                   });
}
    else{
        
        if ([toTime.currentTitle isEqualToString:@"End Time"] ) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please set end time of plan." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([fromTime.currentTitle isEqualToString:@"Start Time"]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please set start time of plan." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }


       
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[clinic_array objectAtIndex:indexPath.row];
    NSString *clinicid_string = (NSString *)[itemAtIndex objectForKey:@"ClinicId"];
    NSString *clinicname_string = (NSString *)[itemAtIndex objectForKey:@"ClinicName"];
    NSLog(@" Clinic String: %@",clinicid_string);
    [clinicdetailviewcontroller setClinic_id:clinicid_string];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:clinicid_string  forKey:@"ClinicId"];
    [defaults setObject:clinicname_string  forKey:@"ClinicName"];
    
    
    [self dismissKeyboard];
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       
                       //[clinicdetailviewcontroller.view removeFromSuperview];
                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                       clinicdetailviewcontroller  = [storyboard instantiateViewControllerWithIdentifier:@"clinicdetail_screen"];
                       clinicdetailviewcontroller.view.tag=990;
                       clinicdetailviewcontroller.view.frame=CGRectMake(0,0, 841, 723);
                       
                       
                       
                       [clinicdetailviewcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [clinicdetailviewcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       [self.view addSubview:clinicdetailviewcontroller.view];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[itemAtIndex objectForKey:@"ClinicName"],@"heading", nil]];
                       [self removeActivityView];
                       
                   });
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Here we are setting the number of rows in the pickerview to the number of objects of the NSArray. You should understand this since we covered it in the tableview tutorial.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView==location_picker)
    {
        return location_array.count;
    }
    else if(pickerView==specialization_picker)
    {
        return specialization_array.count;
    }
    else
    {
        return lastvisited_array.count;
    }
    
}

//Here we are setting the values of the NSArray to the pickerview's rows. This is pretty much identical to the way you load a table view.
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//    NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
//    NSString *location_name=[itemAtIndex objectForKey:@"LocationName"];
//    return location_name;
//
//}

- (UIView *)pickerView:(UIPickerView *)pickerView

            viewForRow:(NSInteger)row

          forComponent:(NSInteger)component

           reusingView:(UIView *)view
{
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil)
    {
        if(pickerView==location_picker)
        {
            //label size
            CGRect frame = CGRectMake(20.0, 0.0, 150, 150);
            
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            //here you can play with fonts
            [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        }
        else
        {
            //label size
            CGRect frame = CGRectMake(20.0, 0.0, 150, 150);
            
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            //here you can play with fonts
            [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        }
        
    }
    
    if(pickerView==location_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
        
        //picker view array is the datasource
        [pickerLabel setText:[itemAtIndex objectForKey:@"LocationName"]];
    }
    else if(pickerView==specialization_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[specialization_array objectAtIndex:row];
        
        //picker view array is the datasource
        [pickerLabel setText:[itemAtIndex objectForKey:@"SpecializationName"]];
    }
    else
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[lastvisited_array objectAtIndex:row];
        
        //picker view array is the datasource
        [pickerLabel setText:[itemAtIndex objectForKey:@"LabelName"]];
    }
    
    return pickerLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView==location_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
        locationid_selected=[itemAtIndex objectForKey:@"LocationId"];
        
        NSString *location_name = @"   ";
        location_name = [location_name stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]];
        [location_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        
        [location_button setTitle:[itemAtIndex objectForKey:@"LocationName"] forState:UIControlStateNormal];
        location_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        location_picker.showsSelectionIndicator = YES;
        location_picker.hidden= NO;
        location_picker_toolbar.hidden=NO;
    }
    else if(pickerView==specialization_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[specialization_array objectAtIndex:row];
        specializationid_selected=[itemAtIndex objectForKey:@"SpecializationId"];
        
        NSString *specialization_name = @"   ";
        specialization_name = [specialization_name stringByAppendingString:[itemAtIndex objectForKey:@"SpecializationName"]];
        [specialization_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        
        [specialization_button setTitle:[itemAtIndex objectForKey:@"SpecializationName"] forState:UIControlStateNormal];
        specialization_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        specialization_picker.showsSelectionIndicator = YES;
        specialization_picker.hidden= NO;
        specialization_picker_toolbar.hidden = NO;
    }
    else
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[lastvisited_array objectAtIndex:row];
        lastvisited_selected=[itemAtIndex objectForKey:@"LabelValue"];
        
        NSString *lastvisited_name = @"   ";
        lastvisited_name = [lastvisited_name stringByAppendingString:[itemAtIndex objectForKey:@"LabelName"]];
        [lastvisited_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        
        [lastvisited_button setTitle:[itemAtIndex objectForKey:@"LabelName"] forState:UIControlStateNormal];
        lastvisited_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        lastvisited_picker.showsSelectionIndicator = YES;
        lastvisited_picker.hidden= NO;
        lastvisited_picker_toolbar.hidden = NO;
    }
}

-(IBAction)Get_Location
{
    [objYHCPickerView hidePicker];
    checkclinicpicker=0;
    if([location_picker isHidden])
    {
        location_picker.hidden=NO;
        location_picker_toolbar.hidden = NO;
    }
    else
    {
        location_picker.hidden=YES;
        location_picker_toolbar.hidden = YES;
    }
}

-(IBAction)Get_specialization
{
    [objYHCPickerView hidePicker];
    checkclinicpicker=0;
    if([specialization_picker isHidden])
    {
        specialization_picker.hidden=NO;
        specialization_picker_toolbar.hidden = NO;
    }
    else
    {
        specialization_picker.hidden=YES;
        specialization_picker_toolbar.hidden = YES;
    }
}

-(IBAction)Get_LastVisited
{
    [objYHCPickerView hidePicker];
    checkclinicpicker=0;
    if([lastvisited_picker isHidden])
    {
        lastvisited_picker.hidden=NO;
        lastvisited_picker_toolbar.hidden = NO;
    }
    else
    {
        lastvisited_picker.hidden=YES;
        lastvisited_picker_toolbar.hidden = YES;
    }
}

-(IBAction)ResetClinic
{
    [self dismissKeyboard];
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [clinic_array removeAllObjects];
                       locationid_selected = @"";
                       lastvisited_selected = @"";
                       search_clinic_field.text = @"";
                       specializationid_selected = @"";
                       //search_doctor_field.text = @"";
                       search_phone_field.text = @"";
                       //search_pin_field.text = @"";
                       [location_button setTitle:@"   Select Area" forState:UIControlStateNormal];
                       
                       [location_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       
                       [specialization_button setTitle:@"   Specialization" forState:UIControlStateNormal];
                       
                       [specialization_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       
                       [lastvisited_button setTitle:@"   Last Visited" forState:UIControlStateNormal];
                       
                       [lastvisited_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       
                       search_clinic_field.textColor= [UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1];
                       //search_doctor_field.textColor= [UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1];
                       search_phone_field.textColor= [UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1];
                       //search_pin_field.textColor= [UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1];
                       
                       offset = 0;
                       // TO Reset TableView Scroll to Top
                       [clinic_table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                       [self ClinicService];
                       
                       location_picker.showsSelectionIndicator = NO;
                       specialization_picker.showsSelectionIndicator = NO;
                       
                       [self removeActivityView];
                   });
}

-(IBAction)SearchClinic
{
    [self dismissKeyboard];
    [self displayActivityView];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [clinic_array removeAllObjects];
                       offset = 0;
                       // TO Reset TableView Scroll to Top
                       [clinic_table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                       [self ClinicService];
                       if(clinic_array.count == 0)
                       {
                           error_label.text = @"No Record Found !";
                       }
                       else
                       {
                           error_label.text = @"";
                       }
                       
                       
                       [self removeActivityView];
                   });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Text Return");
    return NO;
}

-(void)selectedRow:(int)row withString:(NSString *)text
{
    
    NSLog(@"Index Path %d",row);
    //lblIndex.text = [NSString stringWithFormat:@"%d",row];
    //lblText.text = text;
    NSLog(@"Clinic Name %@",text);
    search_clinic_field.text = text;
    
    checkclinicpicker=0;
    [self.view endEditing:YES];
    [objYHCPickerView removeFromSuperview];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"Text Begin Edi");
    //search_doctor_field.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    search_phone_field.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    //search_pin_field.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    search_clinic_field.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    location_picker.hidden= YES;
    location_picker_toolbar.hidden=YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
    lastvisited_picker.hidden=YES;
    lastvisited_picker_toolbar.hidden = YES;
    if(checkclinicpicker == 0)
    {
        if(textField==search_clinic_field )
        {
            [self.view endEditing:YES];
            checkclinicpicker=1;
            objYHCPickerView = [[YHCPickerView alloc] initWithFrame:CGRectMake(search_clinic_field.frame.origin.x, search_clinic_field.frame.origin.y+search_clinic_field.frame.size.height, 320, 216) withNSArray:clinicsArray];
            [self.view addSubview:objYHCPickerView];
            [objYHCPickerView showPicker];
            objYHCPickerView.delegate = self;
            return NO;
        }
        else
        {
            checkclinicpicker=0;
            [self.view endEditing:YES];
            [objYHCPickerView removeFromSuperview];
        }
    }
    else
    {
        if(textField==search_clinic_field )
        {
            checkclinicpicker=0;
            [self.view endEditing:YES];
            [objYHCPickerView removeFromSuperview];
            return NO;
        }
        else
        {
            checkclinicpicker=0;
            [self.view endEditing:YES];
            [objYHCPickerView removeFromSuperview];
        }
    }
    
    return TRUE;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"DID BEgin");
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"DID End");
}



@end