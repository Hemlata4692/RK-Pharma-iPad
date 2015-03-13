//
//  CreatePlanViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "CreatePlanViewController.h"
#import "UserManager.h"
#import "JSON.h"
#import "Clinic.h"
#import "ClinicManager.h"
#import "DailyPlan.h"
#import "DailyPlanManager.h"
#import "DejalActivityView.h"
#import "DailyPlanSummaryListViewController.h"
#import "DailyPlanListViewController.h"

NSString *createplanlocationid_selected = @"";
NSString *createplanclinicid_selected = @"";
NSString *createplan_dateselected = @"";
NSString *createplan_unplanned = @"";

@interface CreatePlanViewController (){
    int lastvisited;
}

@end

@implementation CreatePlanViewController
@synthesize date_label,submit_button,clinic_button,location_button,location_picker,selectdate_picker,date_button,back,lastVisited_picker;
@synthesize location_picker_toolbar,clinic_picker_toolbar,selectdate_picker_toolbar,lastVisited_picker_toolbar;
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
    location_picker_toolbar.hidden = YES;
    location_picker.hidden=YES;
    
    lastVisited_picker_toolbar.hidden = YES;
    lastVisited_picker.hidden=YES;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = location_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, location_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
        
    }

     CGRect frame1 = lastVisited_picker.frame;
    CGRect selectorFrame1 = CGRectInset( frame1, 0.0, lastVisited_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame1, touchPoint) )
    {
        
    }
}



-(void)dismissKeyboard
{
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    
       //clinic_picker.hidden = YES;
    selectdate_picker.hidden = YES;
    selectdate_picker_toolbar.hidden = YES;
    
    lastVisited_picker.hidden = YES;
    lastVisited_picker_toolbar.hidden = YES;
}

-(IBAction)ChangeDateFromLabel:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *plan_date = @"   ";
    plan_date = [plan_date stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:selectdate_picker.date]]];
    [date_button setTitle:plan_date forState:UIControlStateNormal];
    createplan_dateselected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:selectdate_picker.date]];
    [date_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   [_lastVisited_button setTitle:@"All" forState:UIControlStateNormal];
     lastvisited=0;
   [_lastVisited_button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0)];
    
    location_array = [[NSMutableArray alloc] init];
    clinic_array = [[NSMutableArray alloc] init];
    
    //lastVisited Array
    lastVisited_array = [[NSArray alloc] init];
    lastVisited_array = [[NSArray alloc] initWithObjects:@"All",@"More than 20 days",@"More than 30 days",nil];
    
    // To Show Location Picker
    location_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(45,271+14,250,216)];
    
     // To Show Days Picker
    lastVisited_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(420,156+30+5,250,150)];
    
    // To Show Location Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [location_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:location_picker];
    
    [location_picker setDelegate:self];
    [location_picker setDataSource:self];
    location_picker.hidden=YES;
    location_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    location_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(location_picker.frame.origin.x, 240,location_picker.frame.size.width,30+14)];
    location_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    // To Show lastVisited Picker View
    UITapGestureRecognizer *gestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer1.cancelsTouchesInView = NO;
    
    [lastVisited_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:lastVisited_picker];
    
    [lastVisited_picker setDelegate:self];
    [lastVisited_picker setDataSource:self];
    lastVisited_picker.hidden=YES;
    lastVisited_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    lastVisited_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(lastVisited_picker.frame.origin.x, 147,lastVisited_picker.frame.size.width,30+14)];
    lastVisited_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    
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
    
    
    
    /************** toolbar custmzation - lastVisited Picker*************/
    NSMutableArray *barItems4 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems4 addObject:flexSpace4];
    UIBarButtonItem *doneBtn4 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn4.tag = 4;
    [doneBtn4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                     nil]
                           forState:UIControlStateNormal];
    [barItems4 addObject:doneBtn4];
    
    [lastVisited_picker_toolbar setItems:barItems4 animated:YES];
    [self.view addSubview:lastVisited_picker_toolbar];
    lastVisited_picker_toolbar.hidden = YES;

    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    // To Show Date Selector
    selectdate_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(45,156+30+14,250,150)];
    selectdate_picker.datePickerMode = UIDatePickerModeDate;
    selectdate_picker.date = [NSDate date];
    [selectdate_picker addTarget:self action:@selector(ChangeDateFromLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:selectdate_picker];
    selectdate_picker.hidden = YES;
    selectdate_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    selectdate_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(selectdate_picker.frame.origin.x, 156,selectdate_picker.frame.size.width,30+14)];
    selectdate_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    /************** toolbar custmzation *************/
    NSMutableArray *barItems3 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems3 addObject:flexSpace3];
    UIBarButtonItem *doneBtn3= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn3.tag = 3;
    [doneBtn3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems3 addObject:doneBtn3];
    [selectdate_picker_toolbar setItems:barItems3 animated:YES];
    [self.view addSubview:selectdate_picker_toolbar];
    selectdate_picker_toolbar.hidden = YES;
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
    [formatter_date setDateFormat:@"dd-MM-yyyy"];
    //[formatter_date setDateFormat:@"dd"];
    NSString *date_str = [formatter_date stringFromDate:currentdateall];
    date_label.text = date_str;
    
    // Create some sample data
    entries = [[NSArray alloc] initWithObjects:@"Row 1", @"Row 2", @"Row 3", @"Row 4", @"Row 5", @"Row 6",@"Row 7", @"Row 8", @"Row 9", @"Row 10", @"Row 11", @"Row 12",@"Row 13", @"Row 14", @"Row 15", @"Row 16", @"Row 17", @"Row 18", @"Row 19", @"Row 20", @"Row 21", @"Row 22", @"Row 23", @"Row 24", @"Row 25", @"Row 26", @"Row 27", @"Row 28", @"Row 29", @"Row 30", @"Row 31", @"Row 32", @"Row 33", @"Row 34", @"Row 35", @"Row 36", @"Row 37", @"Row 38", @"Row 39", @"Row 40", @"Row 41", @"Row 42",@"Row 43", @"Row 44", @"Row 45", @"Row 46", @"Row 47", @"Row 48",@"Row 49", @"Row 50", @"Row 51", @"Row 52", @"Row 53", @"Row 54",@"Row 55", @"Row 56", @"Row 57", @"Row 58", @"Row 59", @"Row 60", @"Row 61", @"Row 62", @"Row 63", @"Row 64", @"Row 65", @"Row 66", @"Row 67", @"Row 68", @"Row 69", @"Row 70", @"Row 71", @"Row 72", @"Row 73", @"Row 74", @"Row 75", @"Row 76", @"Row 77", @"Row 78", @"Row 79", @"Row 80", @"Row 81", @"Row 82", @"Row 83", @"Row 84",@"Row 85", @"Row 86", @"Row 87", @"Row 88", @"Row 89", @"Row 90", @"Row 91", @"Row 92", @"Row 93", @"Row 94", @"Row 95", @"Row 96", @"Row 97", @"Row 98", @"Row 99", @"Row 100", @"Row 101", @"Row 102", @"Row 103", @"Row 104",@"Row 105", @"Row 106", @"Row 107", @"Row 108", @"Row 109", @"Row 110", @"Row 111", @"Row 112", @"Row 113", @"Row 114", @"Row 115", @"Row 116", @"Row 117", @"Row 118", @"Row 119",@"Row 120", @"Row 121", @"Row 122", @"Row 123",@"Row 124", @"Row 125", @"Row 126", @"Row 127", @"Row 128", @"Row 129", @"Row 130", @"Row 131", @"Row 132", @"Row 133", @"Row 134", @"Row 135", @"Row 136", @"Row 137", @"Row 138", @"Row 139", @"Row 140", @"Row 141", @"Row 142", @"Row 143", @"Row 144", @"Row 145", @"Row 146", @"Row 147", @"Row 148", @"Row 149", @"Row 150", nil];
    NSLog(@"entry count %d",entries.count);
    selectionStates = [[NSMutableDictionary alloc] init];
    for (NSString *key in entries)
        [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
    
    clinic_picker = [[ALPickerView alloc] initWithFrame:CGRectMake(420, 271+14, 200, 100)];
    clinic_picker.delegate_ = self;
    [self.view addSubview:clinic_picker];
    clinic_picker.hidden = YES;
    clinic_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    clinic_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(clinic_picker.frame.origin.x, 241,clinic_picker.frame.size.width,30+14)];
    clinic_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems2 addObject:flexSpace2];
    UIBarButtonItem *doneBtn2= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn2.tag = 2;
    [doneBtn2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems2 addObject:doneBtn2];
    [clinic_picker_toolbar setItems:barItems2 animated:YES];
    [self.view addSubview:clinic_picker_toolbar];
    clinic_picker_toolbar.hidden = YES;
    
    self.selectdate_picker.minimumDate = [NSDate date];
}
-(IBAction)done_clicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag ==1)
    {
        location_picker.hidden=YES;
        location_picker_toolbar.hidden = YES;
    }
    else  if(btn.tag ==2)
    {
        clinic_picker.hidden=YES;
        clinic_picker_toolbar.hidden = YES;
    }
    else  if(btn.tag ==4)
    {
        lastVisited_picker.hidden=YES;
        lastVisited_picker_toolbar.hidden = YES;
    }

    else
    {
        selectdate_picker.hidden=YES;
        selectdate_picker_toolbar.hidden = YES;
    }
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    clinic_picker.hidden=YES;
    clinic_picker_toolbar.hidden = YES;
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    
    lastVisited_picker.hidden=YES;
    lastVisited_picker_toolbar.hidden = YES;
    
    selectdate_picker.hidden=YES;
    selectdate_picker_toolbar.hidden = YES;
    [super touchesBegan:touches withEvent:event];
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
    //return location_array.count;
    
    if(pickerView==location_picker)
    {
        return location_array.count;
    }
    else if(pickerView==lastVisited_picker)
    {
        return lastVisited_array.count;
    }
    return 1;
}


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
            CGRect frame = CGRectMake(20.0, 0.0, 200, 150);
            
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            //here you can play with fonts
            [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        }
        else
        {
            //label size
            CGRect frame = CGRectMake(20.0, 0.0, 200, 150);
            
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
    else if(pickerView==lastVisited_picker)
    {
        [pickerLabel setText:[lastVisited_array objectAtIndex:row]];
    }
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // Select Location and save location id in string
    if(pickerView==location_picker)
    {
    NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
    createplanlocationid_selected=[itemAtIndex objectForKey:@"LocationId"];
    
    NSString *location_name = @"   ";
    location_name = [location_name stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]];
    
    [location_button setTitle:location_name forState:UIControlStateNormal];
    location_picker.showsSelectionIndicator = YES;
    location_picker.hidden= NO;
    location_picker_toolbar.hidden = NO;
    
    //Create domain class object
    Clinic *clinic=[[Clinic alloc]init];
    
    //set Clinic Name value in domain class
    clinic.location = createplanlocationid_selected;
    clinic.LastVisited=[NSString stringWithFormat:@"%d",lastvisited];
    
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
            [clinic_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"ClinicId"],@"ClinicId",[dictvar objectForKey:@"ClinicName"],@"ClinicName",nil]];
        }
        
        [clinic_picker reloadAllComponents];
    }
    }
    
    else if(pickerView==lastVisited_picker){
    [_lastVisited_button setTitle:[lastVisited_array objectAtIndex:row] forState:UIControlStateNormal];
    [_lastVisited_button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0)];
    lastVisited_picker.showsSelectionIndicator = YES;
    lastVisited_picker.hidden= NO;
    lastVisited_picker_toolbar.hidden = NO;
       // NSLog(@"%ld",(long)row);
        
        if (row==0) {
            lastvisited=0;
            [NSString stringWithFormat:@"%d",0];
        }
        else if (row==1){
            lastvisited=20;
            [NSString stringWithFormat:@"%d",1];
        }
        else{
            lastvisited=30;
            [NSString stringWithFormat:@"%d",2];
        }
        
        
        
        NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
        
        NSString *location_name = @"   ";
        location_name = [location_name stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]];
        
        
        
        //Create domain class object
        Clinic *clinic=[[Clinic alloc]init];
        
        //set Clinic Name value in domain class
        clinic.location = createplanlocationid_selected;
        clinic.LastVisited=[NSString stringWithFormat:@"%d",lastvisited];
        
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
                [clinic_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"ClinicId"],@"ClinicId",[dictvar objectForKey:@"ClinicName"],@"ClinicName",nil]];
            }
            
            [clinic_picker reloadAllComponents];
        }
    }

    

}

#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView
{
    return clinic_array.count;
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row
{
    NSDictionary *itemAtIndex = (NSDictionary *)[clinic_array objectAtIndex:row];
    return  [itemAtIndex objectForKey:@"ClinicName"];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row
{
    return [[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row
{
    // Check whether all rows are checked or only one
    if (row == -1)
        for (id key in [selectionStates allKeys])
            [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
    else
        [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[entries objectAtIndex:row]];
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row
{
    // Check whether all rows are unchecked or only one
    if (row == -1)
        for (id key in [selectionStates allKeys])
            [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
    else
        [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[entries objectAtIndex:row]];
}

-(IBAction)Submit:(id)sender
{
    clinic_picker.hidden=YES;
    clinic_picker_toolbar.hidden = YES;
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    
    lastVisited_picker.hidden=YES;
    lastVisited_picker_toolbar.hidden = YES;

    selectdate_picker.hidden=YES;
    selectdate_picker_toolbar.hidden = YES;
    if(clinic_array.count>0 && [createplan_dateselected length]>0)
    {
        NSMutableArray *IdArray=[NSMutableArray new];
        NSMutableString *clinicid_string = [NSMutableString string];
        for (int i = 0; i< clinic_array.count; i++)
        {
            if ([[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue] == 1)
            {
                [IdArray addObject:[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]];
                //NSLog(@"Clinic ID %@",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]);
                [clinicid_string appendString:[NSString stringWithFormat:@"%@,",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]]];
            }
        }
        NSLog(@"Main String %@",clinicid_string);
        //NSLog(@"Main String Space %@",[clinicid_string substringToIndex:[clinicid_string length] - 1]);
        if(IdArray.count>0)
        {
            //NSLog(@"idarray %@..",IdArray);
            [self displayActivityView];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               
                               
                               
                               DailyPlanManager *dp_business=[[DailyPlanManager alloc]init];
                               NSString *response_sgt=[dp_business GetSingaporeTime];//call businessmanager method
                               
                               NSDictionary *var_sgt =  [response_sgt JSONValue];
                               
                               NSArray* current_sgdate = [[var_sgt objectForKey:@"SGT"] componentsSeparatedByString: @" "];
                               NSLog(@" SGT Date%@",[current_sgdate objectAtIndex: 0]);
                               NSLog(@" SGT time%@",[current_sgdate objectAtIndex: 1]);
                               
                               NSDateFormatter* df = [[NSDateFormatter alloc] init];
                               [df setDateFormat:@"dd-MMM-yyyy"];
                               NSDate* enteredDate = [df dateFromString:[NSString stringWithFormat:@"%@",[df stringFromDate:selectdate_picker.date]]];
                               NSDate * today = [df dateFromString:[current_sgdate objectAtIndex: 0]];
                               
                               if ([today compare: enteredDate] == NSOrderedAscending)
                               {
                                   NSLog(@" Future Date ");
                                   createplan_unplanned = @"0";
                               }
                               else if([today compare: enteredDate] == NSOrderedSame)
                               {
                                   NSLog(@" Current Date ");
                                   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                   [formatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
                                   NSDate *date1=[formatter dateFromString:[var_sgt objectForKey:@"SGT"]];
                                   NSDate *date2=[formatter dateFromString:[NSString stringWithFormat:@"%@ %@",[current_sgdate objectAtIndex: 0],@"10:00 AM"]];
                                   
                                   NSLog(@" SGT %@",[var_sgt objectForKey:@"SGT"]);
                                   if ([date1 compare: date2] ==NSOrderedDescending)
                                   {
                                       createplan_unplanned = @"1";
                                   }
                                   else
                                   {
                                       createplan_unplanned = @"0";
                                   }
                                   
                               }
                               else
                               {
                                   createplan_unplanned = @"1";
                               }
                               
                               NSLog(@" CREATE PLAN UNPLANNED %@",createplan_unplanned);
                               
                               
                               
                               
                               //Create business manager class object
                               //                DailyPlanManager *dp_business=[[DailyPlanManager alloc]init];
                               //                NSString *response=[dp_business GetSingaporeTime];//call businessmanager method
                               //
                               //                if (response.length !=0)
                               //                {
                               //                    NSDictionary *var =  [response JSONValue];
                               //                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                               //                    [formatter setDateFormat:@"hh:mm a"];
                               //                    NSDate *date1=[formatter dateFromString:[var objectForKey:@"SGT"]];
                               //                    NSDate *date2=[formatter dateFromString:@"10:00 AM"];
                               //
                               //                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               //                    if ([date1 compare: date2] ==NSOrderedDescending)
                               //                    {
                               //                        createplan_unplanned = @"1";
                               //                    }
                               //                    else
                               //                    {
                               //                        createplan_unplanned = @"0";
                               //                    }
                               //                }
                               
                               
                               
                               //Create domain class object
                               DailyPlan *addclinic=[[DailyPlan alloc]init];
                               
                               addclinic.clinic_id = [clinicid_string substringToIndex:[clinicid_string length] - 1];
                               addclinic.plan_date = createplan_dateselected;
                               addclinic.unplanned = createplan_unplanned;
                               addclinic.KIVclinic_id = @"";
                               //Create business manager class object
                               DailyPlanManager *dpm_business=[[DailyPlanManager alloc]init];
                               NSString *response=[dpm_business AddClinics:addclinic] ;//call businessmanager  method and handle response
                               if (response.length !=0)
                               {
                                   NSDictionary *var =  [response JSONValue];
                                   NSLog(@"dict Clinic Name List%@",var);
                                   
                                   if([[var objectForKey:@"IsSuccess"] intValue]==1)
                                   {
                                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                       dailyplansummarylist = [storyboard instantiateViewControllerWithIdentifier:@"daily_plan_summary_report_list"];
                                       dailyplansummarylist.view.tag=990;
                                       dailyplansummarylist.view.frame=CGRectMake(0,0, 841, 723);
                                       
                                       [dailyplansummarylist.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                                       [UIView beginAnimations:@"animateTableView" context:nil];
                                       [UIView setAnimationDuration:0.4];
                                       [dailyplansummarylist.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                                       [UIView commitAnimations];
                                       
                                       
                                       [self.view addSubview:dailyplansummarylist.view];
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
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select atleast one clinic." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please fill in required fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(IBAction)Get_Location
{
    selectdate_picker.hidden=YES;
    selectdate_picker_toolbar.hidden = YES;
    
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    
    lastVisited_picker.hidden=YES;
    lastVisited_picker_toolbar.hidden = YES;

    if([location_picker isHidden])
    {
        location_picker.hidden=NO;
        location_picker_toolbar.hidden = NO;
    }
    else
    {
        location_picker_toolbar.hidden = YES;
        location_picker.hidden=YES;
    }
}

-(IBAction)Get_Clinic
{
    selectdate_picker.hidden=YES;
    selectdate_picker_toolbar.hidden = YES;
    
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    
    lastVisited_picker.hidden=YES;
    lastVisited_picker_toolbar.hidden = YES;

    
    if(clinic_array.count>0)
    {
        if([clinic_picker isHidden])
        {
            clinic_picker.hidden=NO;
            clinic_picker_toolbar.hidden = NO;
        }
        else
        {
            clinic_picker.hidden=YES;
            clinic_picker_toolbar.hidden = YES;
        }
    }
    else
    {
        
        if(![[NSString stringWithFormat:@"%@",createplanlocationid_selected] isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"This location has no clinic. Please select another." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select location first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}

-(IBAction)GetDate
{
    selectdate_picker.hidden=YES;
    selectdate_picker_toolbar.hidden = YES;
    
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    
    lastVisited_picker.hidden=YES;
    lastVisited_picker_toolbar.hidden = YES;
    
    
    if([selectdate_picker isHidden])
    {
        selectdate_picker.hidden=NO;
        selectdate_picker_toolbar.hidden = NO;
    }
    else
    {
        selectdate_picker.hidden=YES;
        selectdate_picker_toolbar.hidden = YES;
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
                       dailyplanlistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"daily_plan_summary_report_list"];
                       dailyplanlistcontroller.view.tag=990;
                       dailyplanlistcontroller.view.frame=CGRectMake(0,0, 841, 723);
                       
                       [dailyplanlistcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [dailyplanlistcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       
                       [self.view addSubview:dailyplanlistcontroller.view];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Plan",@"heading", nil]];
                       [self removeActivityView];
                   });
}

- (IBAction)Get_lastVisited:(id)sender {
   // [location_button setTitle:nil forState:UIControlStateNormal];
    
    selectdate_picker.hidden=YES;
    selectdate_picker_toolbar.hidden = YES;
    
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    
    lastVisited_picker.hidden=YES;
    lastVisited_picker_toolbar.hidden = YES;
   
    
    if([lastVisited_picker isHidden])
    {
        lastVisited_picker.hidden=NO;
        lastVisited_picker_toolbar.hidden = NO;
    }
    else
    {
        lastVisited_picker_toolbar.hidden = YES;
        lastVisited_picker.hidden=YES;
    }

}

@end