//
//  AddClinicViewController.m
//  RKPharma
//
//  Created by Shivendra  singh on 09/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "AddClinicViewController.h"
#import "UserManager.h"
#import "JSON.h"
#import "Clinic.h"
#import "ClinicManager.h"
#import "DailyPlan.h"
#import "DailyPlanManager.h"
#import "DejalActivityView.h"
#import "DashboardViewController.h"

NSString *addcliniclocationid_selected = @"";
NSString *addclinicid_selected = @"";
NSString *addclinic_unplanned = @"";
@interface AddClinicViewController ()

@end

@implementation AddClinicViewController

@synthesize date_label,submit_button,clinic_button,location_button,location_picker,back,location_picker_toolbar;
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

- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = location_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, location_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}

-(void)dismissKeyboard
{
    location_picker.hidden = YES;
    clinic_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [back setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1]forState:UIControlStateNormal];
    
    location_array = [[NSMutableArray alloc] init];
    clinic_array = [[NSMutableArray alloc] init];
    
    // To Show Location Picker
    location_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(24,270,250,216)];
    
    // To Show Location Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [location_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:location_picker];
    
    [location_picker setDelegate:self];
    [location_picker setDataSource:self];
    location_picker.hidden=YES;
    
    location_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    
    
    /** picker toolbar code **/
    location_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(location_picker.frame.origin.x, 230,location_picker.frame.size.width,30+14)];
    location_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn.tag = 1;
    [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                     nil]
                           forState:UIControlStateNormal];
    [barItems addObject:doneBtn];
    [location_picker_toolbar setItems:barItems animated:YES];
    [self.view addSubview:location_picker_toolbar];
    location_picker_toolbar.hidden = YES;
    
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    // To Hide Picker when touch outside of textfield
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                                   initWithTarget:self
    //                                   action:@selector(dismissKeyboard)];
    //
    //    [self.view addGestureRecognizer:tap];
    //    [tap setCancelsTouchesInView:NO];
    
    //Create business manager class object
    UserManager *um_business=[[UserManager alloc]init];
    // To Get Location
    NSString *location_response=[um_business GeLocationList];//call businessmanager Location method and handle response
    
    if (location_response.length !=0)
    {
        NSDictionary *location_var =  [location_response JSONValue];
        NSLog(@"dict Location List%@",location_var);
        
        for(NSDictionary *location_dictvar in location_var)
        {
            [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[location_dictvar objectForKey:@"LocationId"],@"LocationId",[location_dictvar objectForKey:@"LocationName"],@"LocationName",nil]];
            
        }
    }
    
    NSDate *currentdateall = [NSDate date];
    NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
    [formatter_date setDateFormat:@"dd-MM-yyyy "];
    //[formatter_date setDateFormat:@"dd"];
    NSString *date_str = [formatter_date stringFromDate:currentdateall];
    date_label.text = date_str;
    
    //    NSMutableArray *entries = [[NSMutableArray alloc] init];
    //    for (NSUInteger i = 1; i <= 50; i++)
    //    {
    //        [entries addObject:[NSString stringWithFormat:@"Row %d", i]];
    //    }
    
    // Create some sample data
	entries = [[NSArray alloc] initWithObjects:@"Row 1", @"Row 2", @"Row 3", @"Row 4", @"Row 5", @"Row 6",@"Row 7", @"Row 8", @"Row 9", @"Row 10", @"Row 11", @"Row 12",@"Row 13", @"Row 14", @"Row 15", @"Row 16", @"Row 17", @"Row 18", @"Row 19", @"Row 20", @"Row 21", @"Row 22", @"Row 23", @"Row 24", @"Row 25", @"Row 26", @"Row 27", @"Row 28", @"Row 29", @"Row 30", @"Row 31", @"Row 32", @"Row 33", @"Row 34", @"Row 35", @"Row 36", @"Row 37", @"Row 38", @"Row 39", @"Row 40", @"Row 41", @"Row 42",@"Row 43", @"Row 44", @"Row 45", @"Row 46", @"Row 47", @"Row 48",@"Row 49", @"Row 50", @"Row 51", @"Row 52", @"Row 53", @"Row 54",@"Row 55", @"Row 56", @"Row 57", @"Row 58", @"Row 59", @"Row 60", @"Row 61", @"Row 62", @"Row 63", @"Row 64", @"Row 65", @"Row 66", @"Row 67", @"Row 68", @"Row 69", @"Row 70", @"Row 71", @"Row 72", @"Row 73", @"Row 74", @"Row 75", @"Row 76", @"Row 77", @"Row 78", @"Row 79", @"Row 80", @"Row 81", @"Row 82", @"Row 83", @"Row 84",@"Row 85", @"Row 86", @"Row 87", @"Row 88", @"Row 89", @"Row 90", @"Row 91", @"Row 92", @"Row 93", @"Row 94", @"Row 95", @"Row 96", @"Row 97", @"Row 98", @"Row 99", @"Row 100", @"Row 101", @"Row 102", @"Row 103", @"Row 104",@"Row 105", @"Row 106", @"Row 107", @"Row 108", @"Row 109", @"Row 110", @"Row 111", @"Row 112", @"Row 113", @"Row 114", @"Row 115", @"Row 116", @"Row 117", @"Row 118", @"Row 119",@"Row 120", @"Row 121", @"Row 122", @"Row 123",@"Row 124", @"Row 125", @"Row 126", @"Row 127", @"Row 128", @"Row 129", @"Row 130", @"Row 131", @"Row 132", @"Row 133", @"Row 134", @"Row 135", @"Row 136", @"Row 137", @"Row 138", @"Row 139", @"Row 140", @"Row 141", @"Row 142", @"Row 143", @"Row 144", @"Row 145", @"Row 146", @"Row 147", @"Row 148", @"Row 149", @"Row 150", nil];
    NSLog(@" Entries Array%@",entries);
    NSLog(@"entry count %d",entries.count);
	selectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in entries)
		[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
    
    NSLog(@" Selection Array%@",selectionStates);
	clinic_picker = [[ALPickerView alloc] initWithFrame:CGRectMake(436, 230, 200, 100)];
	clinic_picker.delegate_ = self;
	[self.view addSubview:clinic_picker];
    clinic_picker.hidden = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    clinic_picker.hidden=YES;
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)done_clicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag ==1)
    {
        location_picker.hidden=YES;
        location_picker_toolbar.hidden = YES;
    }
    else
    {
        clinic_picker.hidden=YES;
    }
    
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


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#pragma mark -
#pragma mark Location Picker View delegate methods

//Here we are setting the number of rows in the pickerview to the number of objects of the NSArray. You should understand this since we covered it in the tableview tutorial.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return location_array.count;
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

           reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 200, 150);
        
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
    
    //picker view array is the datasource
    [pickerLabel setText:[itemAtIndex objectForKey:@"LocationName"]];
    
    
    return pickerLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // Select Location and save location id in string
    NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
    addcliniclocationid_selected=[itemAtIndex objectForKey:@"LocationId"];
    
    NSString *location_name = @"   ";
    location_name = [location_name stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]];
    
    [location_button setTitle:location_name forState:UIControlStateNormal];
    location_picker.showsSelectionIndicator = YES;
    location_picker.hidden= NO;
    location_picker_toolbar.hidden = NO;
    
    //Create domain class object
    Clinic *clinic=[[Clinic alloc]init];
    
    //set Clinic Name value in domain class
    clinic.location = addcliniclocationid_selected;
    
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    NSString *response=[cm_business GetClinicNameList:clinic];//call businessmanager  method and handle response
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Clinic Name List%@",var);
        [clinic_array removeAllObjects];
        [selectionStates removeAllObjects];
        for(NSDictionary *dictvar in var)
        {
            [clinic_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"ClinicId"],@"ClinicId",[dictvar objectForKey:@"ClinicName"],@"ClinicName",[dictvar objectForKey:@"IsInKIV"],@"IsInKIV",nil]];
        }
        
        [clinic_picker reloadAllComponents];
    }
    
}

#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
	//return [entries count];
    return clinic_array.count;
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
    //NSLog(@" Text %@",[entries objectAtIndex:row]);
	//return [entries objectAtIndex:row];
    NSDictionary *itemAtIndex = (NSDictionary *)[clinic_array objectAtIndex:row];
    return  [itemAtIndex objectForKey:@"ClinicName"];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
    NSLog([[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue] ? @"Yes" : @"No");
    //NSLog(@" Selection State %d",[[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue]);
	return [[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
	// Check whether all rows are checked or only one
	if (row == -1)
		for (id key in [selectionStates allKeys])
			[selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
	else
		[selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[entries objectAtIndex:row]];
    
    //    NSMutableIndexSet *indexSet=[NSMutableIndexSet new];
    //    NSArray *allValues=[selectionStates allValues];
    //    for (int i = 0; i< allValues.count; i++) {
    //        if ([[allValues objectAtIndex:i] intValue] == 1) {
    //            [indexSet addIndex:i];
    //        }
    //    }
    //    NSArray *allKeys=[selectionStates allKeys];
    //   NSArray *ButtonArray= [allKeys objectsAtIndexes:indexSet];
    //    NSMutableString *buttonTitle=[NSMutableString new];
    //    for (int i = 0; i<ButtonArray.count; i++) {
    //        [buttonTitle appendFormat:@"%@,",[ButtonArray objectAtIndex:i]];
    //    }
    //    NSString *clinicbutton_space = @"   ";
    //    clinicbutton_space = [clinicbutton_space stringByAppendingString:[buttonTitle substringToIndex:[buttonTitle length] - 1]];
    //    NSLog(@"selected rows %@",[buttonTitle substringToIndex:[buttonTitle length] - 1]);
    //    //[buttonTitle substringToIndex:[buttonTitle length] - 1];
    //    [clinic_button setTitle:clinicbutton_space forState:UIControlStateNormal];
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
	// Check whether all rows are unchecked or only one
	if (row == -1)
		for (id key in [selectionStates allKeys])
			[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	else
		[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[entries objectAtIndex:row]];
    
    //    NSMutableIndexSet *indexSet=[NSMutableIndexSet new];
    //    NSArray *allValues=[selectionStates allValues];
    //    for (int i = 0; i< allValues.count; i++) {
    //        if ([[allValues objectAtIndex:i] intValue] == 1) {
    //            [indexSet addIndex:i];
    //        }
    //    }
    //    NSArray *allKeys=[selectionStates allKeys];
    //    NSArray *ButtonArray= [allKeys objectsAtIndexes:indexSet];
    //    NSMutableString *buttonTitle=[NSMutableString new];
    //    for (int i = 0; i<ButtonArray.count; i++) {
    //        [buttonTitle appendFormat:@"%@,",[ButtonArray objectAtIndex:i]];
    //    }
    //    NSString *clinicbutton_space = @"   ";
    //    if([buttonTitle length] >0)
    //    {
    //        clinicbutton_space = [clinicbutton_space stringByAppendingString:[buttonTitle substringToIndex:[buttonTitle length] - 1]];
    //    NSLog(@"selected rows %@",[buttonTitle substringToIndex:[buttonTitle length] - 1]);
    //    }
    //    //[buttonTitle substringToIndex:[buttonTitle length] - 1];
    //    [clinic_button setTitle:clinicbutton_space forState:UIControlStateNormal];
}

-(IBAction)Submit:(id)sender
{
    clinic_picker.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    if(clinic_array.count>0)
    {
        NSMutableArray *IdArray=[NSMutableArray new];
        NSMutableString *clinicid_string = [NSMutableString string];
        NSMutableString *kivclinicid_string = [NSMutableString string];
        NSMutableString *kivclinicname_string = [NSMutableString string];
        NSLog(@"Selection States %d",selectionStates.count);
        NSLog(@"Selection States %@",selectionStates);
        NSInteger checkKIV = 0;
        for (int i = 0; i< clinic_array.count; i++)
        {
            NSLog(@"Check Row String %d",[[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue]);
            if ([[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue] == 1)
            {
                [IdArray addObject:[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]];
                //NSLog(@"Clinic ID %@",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]);
                [clinicid_string appendString:[NSString stringWithFormat:@"%@,",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]]];
            }
            
            if([[[clinic_array objectAtIndex:i] objectForKey:@"IsInKIV"] intValue]==1 && [[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue] == 0)
            {
                checkKIV = 1;
                [kivclinicid_string appendString:[NSString stringWithFormat:@"%@,",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]]];
                [kivclinicname_string appendString:[NSString stringWithFormat:@"%@\n",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicName"]]];
            }
        }
        
        NSLog(@"Main String %@",clinicid_string);
        NSLog(@"KIV String %@",kivclinicid_string);
        NSLog(@"LENGTH KIV STRING %d",[kivclinicid_string length]);
        
        
        
        
        
        //NSLog(@"Main String Space %@",[clinicid_string substringToIndex:[clinicid_string length] - 1]);
        if(IdArray.count>0)
        {
            if([kivclinicid_string length]>0)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Below Clinics has KIV Products. Would you like to continue with this submission? \n%@",kivclinicname_string] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
                alert.tag = 1;
                [alert show];
            }
            else
            {
                //NSLog(@"idarray %@..",IdArray);
                [self displayActivityView];
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               {
                                   //Create business manager class object
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
                                           addclinic_unplanned = @"1";
                                       }
                                       else
                                       {
                                           addclinic_unplanned = @"0";
                                       }
                                       
                                   }
                                   
                                   
                                   NSDate *currentdateall = [NSDate date];
                                   NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
                                   [formatter_date setDateFormat:@"dd-MMM-yyyy "];
                                   NSString *date_str = [formatter_date stringFromDate:currentdateall];
                                   
                                   //Create domain class object
                                   DailyPlan *addclinic=[[DailyPlan alloc]init];
                                   addclinic.clinic_id = [clinicid_string substringToIndex:[clinicid_string length] - 1];
                                   addclinic.plan_date = date_str;
                                   addclinic.unplanned = addclinic_unplanned;
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
                                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                           dashboardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_screen"];
                                           dashboardcontroller.view.tag=990;
                                           dashboardcontroller.view.frame=CGRectMake(0,0, 841, 723);
                                           
                                           [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                                           [UIView beginAnimations:@"animateTableView" context:nil];
                                           [UIView setAnimationDuration:0.4];
                                           [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                                           [UIView commitAnimations];
                                           
                                           
                                           [self.view addSubview:dashboardcontroller.view];
                                       }
                                       else
                                       {
                                           //                        if([[var objectForKey:@"OldDate"] intValue]==1)
                                           //                        {
                                           //                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Failed: You have selected past date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                           //                            [alert show];
                                           //                        }
                                           if([[var objectForKey:@"PlansAvailable"] intValue])
                                           {
                                               NSString *message = @"Failed: You cannot add more than 20 clinics.\nClinics Available: ";
                                               NSString *availableclinics = [NSString stringWithFormat:@"%@",[var objectForKey:@"PlansAvailable"]];
                                               message = [message stringByAppendingString:availableclinics];
                                               UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                               [alert show];
                                           }
                                       }
                                   }
                                   
                               });
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select atleast one clinic." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please fill in required fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
    
}

-(IBAction)Get_Location
{
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

-(IBAction)Get_Clinic
{
    if(clinic_array.count>0)
    {
        if([clinic_picker isHidden])
        {
            clinic_picker.hidden=NO;
        }
        else
        {
            clinic_picker.hidden=YES;
        }
    }
    else
    {
        NSLog(@" LOCATION ID : %@",addcliniclocationid_selected);
        if(![[NSString stringWithFormat:@"%@",addcliniclocationid_selected] isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"This location has no clinic. Please select another." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select location first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}

-(IBAction)backbtn_clicked
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                       dashboardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_screen"];
                       dashboardcontroller.view.tag=990;
                       dashboardcontroller.view.frame=CGRectMake(0,0, 841, 723);
                       
                       [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       
                       [self.view addSubview:dashboardcontroller.view];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Dashboard",@"heading", nil]];
                       
                       [self removeActivityView];
                   });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)
    {
        NSLog(@"Cancel Button Pressed");
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"Submit Button Pressed %d",alertView.tag);
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           NSMutableArray *IdArray=[NSMutableArray new];
                           NSMutableString *clinicid_string = [NSMutableString string];
                           NSMutableString *kivclinicid_string = [NSMutableString string];
                           NSLog(@"Selection States %d",selectionStates.count);
                           NSLog(@"Selection States %@",selectionStates);
                           NSInteger checkKIV = 0;
                           for (int i = 0; i< clinic_array.count; i++)
                           {
                               NSLog(@"Check Row String %d",[[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue]);
                               if ([[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue] == 1)
                               {
                                   [IdArray addObject:[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]];
                                   //NSLog(@"Clinic ID %@",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]);
                                   [clinicid_string appendString:[NSString stringWithFormat:@"%@,",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]]];
                               }
                               
                               if([[[clinic_array objectAtIndex:i] objectForKey:@"IsInKIV"] intValue]==1 && [[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue] == 0)
                               {
                                   checkKIV = 1;
                                   [kivclinicid_string appendString:[NSString stringWithFormat:@"%@,",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]]];
                                   
                               }
                               
                               
                           }
                           
                           //Create business manager class object
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
                                   addclinic_unplanned = @"1";
                               }
                               else
                               {
                                   addclinic_unplanned = @"0";
                               }
                               
                           }
                           
                           
                           NSDate *currentdateall = [NSDate date];
                           NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
                           [formatter_date setDateFormat:@"dd-MMM-yyyy "];
                           NSString *date_str = [formatter_date stringFromDate:currentdateall];
                           
                           //Create domain class object
                           DailyPlan *addclinic=[[DailyPlan alloc]init];
                           
                           addclinic.clinic_id = [clinicid_string substringToIndex:[clinicid_string length] - 1];
                           addclinic.plan_date = date_str;
                           addclinic.unplanned = addclinic_unplanned;
                           addclinic.KIVclinic_id = [kivclinicid_string substringToIndex:[kivclinicid_string length] - 1];
                           //addclinic.kiv_clinics = [kivclinicid_string substringToIndex:[clinicid_string length] - 1];
                           
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
                                   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                   dashboardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_screen"];
                                   dashboardcontroller.view.tag=990;
                                   dashboardcontroller.view.frame=CGRectMake(0,0, 841, 723);
                                   
                                   [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                                   [UIView beginAnimations:@"animateTableView" context:nil];
                                   [UIView setAnimationDuration:0.4];
                                   [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                                   [UIView commitAnimations];
                                   
                                   
                                   [self.view addSubview:dashboardcontroller.view];
                               }
                               else
                               {
                                   //                        if([[var objectForKey:@"OldDate"] intValue]==1)
                                   //                        {
                                   //                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Failed: You have selected past date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                   //                            [alert show];
                                   //                        }
                                   if([[var objectForKey:@"PlansAvailable"] intValue])
                                   {
                                       NSString *message = @"Failed: You cannot add more than 20 clinics.\nClinics Available: ";
                                       NSString *availableclinics = [NSString stringWithFormat:@"%@",[var objectForKey:@"PlansAvailable"]];
                                       message = [message stringByAppendingString:availableclinics];
                                       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                       [alert show];
                                   }
                               }
                           }
                           
                           
                           [self removeActivityView];
                       });
    }
}

@end