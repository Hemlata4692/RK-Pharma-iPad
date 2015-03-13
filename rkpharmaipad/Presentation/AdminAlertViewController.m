//
//  AdminAlertViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "AdminAlertViewController.h"
#import "JSON.h"
#import "Alert.h"
#import "AlertManager.h"
#import "UserManager.h"
#import "ClinicManager.h"
#import "Clinic.h"
#import "DejalActivityView.h"

NSString *areaid_selected = @"";
NSString *clinicid_selected = @"";
@interface AdminAlertViewController ()

@end

@implementation AdminAlertViewController
@synthesize alert_table,reminder_label,clinic_label,location_label,date_label,status_label,admin_remarks,location_picker,location_button,clinic_picker,clinic_button,reminder,error,sno,addreminder_button;
@synthesize location_picker_toolbar,clinic_picker_toolbar;
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


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden = YES;
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

- (void)pickerViewTapGestureRecognizedclinicpicker:(UITapGestureRecognizer*)gestureRecognizerclinicpicker
{
    clinic_picker.hidden=YES;
    clinic_picker_toolbar.hidden = YES;
    CGPoint touchPoint = [gestureRecognizerclinicpicker locationInView:gestureRecognizerclinicpicker.view.superview];
    
    CGRect frame = clinic_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, clinic_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
        
    }
}

- (void)ShowRemindersService
{
    //Create business manager class object
    AlertManager *am_business=[[AlertManager alloc]init];
    NSString *response=[am_business GetReminderList];//call businessmanager login method and handle response
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Reminder List%@",var);
        
        for(NSDictionary *dictvar in var)
        {
            [alert_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"AdminRemarks"],@"AdminRemarks",[dictvar objectForKey:@"AlertDate"],@"AlertDate",[dictvar objectForKey:@"Clinic"],@"Clinic",[dictvar objectForKey:@"Location"],@"Location",[dictvar objectForKey:@"Reminder"],@"Reminder",[dictvar objectForKey:@"Status"],@"Status",[dictvar objectForKey:@"Username"],@"Username",[dictvar objectForKey:@"CanDelete"],@"CanDelete",[dictvar objectForKey:@"Id"],@"Id",nil]];
            
        }
        [alert_table reloadData];
        
        // To Show table height according to data
        if(alert_array.count == 0)
        {
            self.alert_table.frame = CGRectMake(10,315,821,0);
        }
        else if(alert_array.count == 1)
        {
            self.alert_table.frame = CGRectMake(10,315,821,100);
        }
        else if(alert_array.count == 2)
        {
            self.alert_table.frame = CGRectMake(10,315,821,200);
        }
        else if(alert_array.count == 3)
        {
            self.alert_table.frame = CGRectMake(10,315,821,300);
        }
        else if(alert_array.count >= 4)
        {
            self.alert_table.frame = CGRectMake(10,315,821,400);
        }
        
        if(alert_array.count == 0)
        {
            error.text = @"No Record Found !";
            error.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        }
        else
        {
            error.text = @"";
        }
    }
}

- (void)ShowclinicService
{
    //Create domain class object
    Clinic *clinic=[[Clinic alloc]init];
    
    //set Clinic Name value in domain class
    clinic.location = areaid_selected;
    
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    NSString *response=[cm_business GetClinicNameList:clinic];//call businessmanager login method and handle response
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Clinic Name List%@",var);
        [clinic_array removeAllObjects];
        int i = 1;
        for(NSDictionary *dictvar in var)
        {
            //To Select bydefault first clinic
            if(i==1)
            {
                clinicid_selected =[dictvar objectForKey:@"ClinicId"];
                //                NSString *clinic_name = @"   ";
                //                clinic_name = [clinic_name stringByAppendingString:[dictvar objectForKey:@"ClinicName"]];
                [clinic_button setTitle:[dictvar objectForKey:@"ClinicName"] forState:UIControlStateNormal];
                clinic_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
                clinic_picker.showsSelectionIndicator = YES;
            }
            [clinic_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"ClinicId"],@"ClinicId",[dictvar objectForKey:@"ClinicName"],@"ClinicName",nil]];
            i++;
            
        }
        
        
        if(clinic_array.count==0)
        {
            clinicid_selected=@"";
            //            NSString *clinic_name = @"   ";
            //            clinic_name = [clinic_name stringByAppendingString:@"No Clinic"];
            [clinic_button setTitle:@"No Clinic" forState:UIControlStateNormal];
            clinic_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
            clinic_picker.showsSelectionIndicator = NO;
        }
        [clinic_picker reloadAllComponents];
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        addreminder_button.hidden = YES;
    }
    else
    {
        addreminder_button.hidden = NO;
    }
    
    // To initialize array
    location_array = [[NSMutableArray alloc]init];
    clinic_array = [[NSMutableArray alloc]init];
    
    
    // To Show Location Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    // To Set Location Picker
    location_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(40,150+14,200,100)];
    location_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(location_picker.frame.origin.x, 120,location_picker.frame.size.width,44)];
    [location_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:location_picker];
    
    [location_picker setDelegate:self];
    [location_picker setDataSource:self];
    location_picker.hidden=YES;
    location_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
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
    // To Show Clinic Picker View
    UITapGestureRecognizer *gestureRecognizerclinicpicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognizedclinicpicker:)];
    gestureRecognizerclinicpicker.cancelsTouchesInView = NO;
    
    // To Set Clinic Picker
    clinic_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(444,150+14,300,100)];
    [clinic_picker addGestureRecognizer:gestureRecognizerclinicpicker];
    [self.view addSubview:clinic_picker];
    
    [clinic_picker setDelegate:self];
    [clinic_picker setDataSource:self];
    clinic_picker.hidden=YES;
    clinic_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    clinic_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(clinic_picker.frame.origin.x, 120,clinic_picker.frame.size.width,30+14)];
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
    
    // To set the view background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    alert_array = [[NSMutableArray alloc]init];
    
    self.alert_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    
    [self ShowRemindersService];
    
    
    //    // To Hide keyboard when touch outside of textfield
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
        
        for(NSDictionary *location_dictvar in location_var)
        {
            [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[location_dictvar objectForKey:@"LocationId"],@"LocationId",[location_dictvar objectForKey:@"LocationName"],@"LocationName",nil]];
            
        }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"Should Begin");
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden = YES;
    return YES;
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
        clinic_picker_toolbar.hidden = YES;
    }
    
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden = YES;
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [[event allTouches] anyObject];
    UITouch *touch = [[event allTouches] anyObject];
    if ([reminder isFirstResponder] && [touch view] != reminder)
    {
        [reminder resignFirstResponder];
    }
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden = YES;
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationLandscapeRight;
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return alert_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"alert_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[alert_array objectAtIndex:indexPath.row];
    
    reminder_label=(UILabel *)[cell viewWithTag:1];
    reminder_label.text = [itemAtIndex objectForKey:@"Reminder"];
    
    clinic_label=(UILabel *)[cell viewWithTag:2];
    clinic_label.text = [itemAtIndex objectForKey:@"Clinic"];
    
    admin_remarks=(UILabel *)[cell viewWithTag:3];
    admin_remarks.text = [itemAtIndex objectForKey:@"AdminRemarks"];
    
    date_label=(UILabel *)[cell viewWithTag:4];
    date_label.text = [itemAtIndex objectForKey:@"AlertDate"];
    
    status_label=(UILabel *)[cell viewWithTag:5];
    status_label.text = [itemAtIndex objectForKey:@"Status"];
    
    if([[itemAtIndex objectForKey:@"Status"] isEqualToString:@"Unread"])
    {
        status_label.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    else if([[itemAtIndex objectForKey:@"Status"] isEqualToString:@"Done"])
    {
        status_label.textColor= [UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(0/255.0) alpha:1];
    }
    else
    {
        status_label.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(200/255.0) alpha:1];
    }
    
    if([[itemAtIndex objectForKey:@"Status"] intValue] == 1)
    {
        // Added Custom delete button to get tableview indexpath value
        UIButton *accessory = [UIButton buttonWithType:UIButtonTypeCustom];
        [accessory setImage:[UIImage imageNamed:@"deleteicon.png"] forState:UIControlStateNormal];
        accessory.frame = CGRectMake(0, 0, 33, 33);
        accessory.userInteractionEnabled = YES;
        [accessory addTarget:self action:@selector(delete_reminder:) forControlEvents:UIControlEventTouchUpInside];
        accessory.backgroundColor = [UIColor clearColor];
        cell.accessoryView = accessory;
    }
    
    
    UIImage *background = [UIImage imageNamed:@"listingbg_new.png"];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    sno=(UILabel *)[cell viewWithTag:6];
    NSString *sno_string = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    sno_string = [sno_string stringByAppendingString:@"."];
    sno.text = sno_string;
    
    
    return cell;
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
    else
    {
        return clinic_array.count;
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

           reusingView:(UIView *)view {
    
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
            CGRect frame = CGRectMake(20.0, 0.0, 250, 150);
            
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
    else if(pickerView==clinic_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[clinic_array objectAtIndex:row];
        
        //picker view array is the datasource
        [pickerLabel setText:[itemAtIndex objectForKey:@"ClinicName"]];
    }
    
    return pickerLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView==location_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
        areaid_selected=[itemAtIndex objectForKey:@"LocationId"];
        
        //        NSString *location_name = @"   ";
        //        location_name = [location_name stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]];
        
        [location_button setTitle:[itemAtIndex objectForKey:@"LocationName"] forState:UIControlStateNormal];
        location_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        location_picker.showsSelectionIndicator = YES;
        location_picker.hidden= NO;
        location_picker_toolbar.hidden = NO;
        [self ShowclinicService];
        
    }
    else
    {
        if(clinic_array.count>0)
        {
            NSDictionary *itemAtIndex = (NSDictionary *)[clinic_array objectAtIndex:row];
            clinicid_selected=[itemAtIndex objectForKey:@"ClinicId"];
            
            //            NSString *clinic_name = @"   ";
            //            clinic_name = [clinic_name stringByAppendingString:[itemAtIndex objectForKey:@"ClinicName"]];
            
            [clinic_button setTitle:[itemAtIndex objectForKey:@"ClinicName"] forState:UIControlStateNormal];
            clinic_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
            
            clinic_picker.showsSelectionIndicator = YES;
            clinic_picker.hidden= NO;
            clinic_picker_toolbar.hidden = NO;
        }
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
    if(clinic_array.count>0 && ![[NSString stringWithFormat:@"%@",areaid_selected] isEqualToString:@""])
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
        if(![[NSString stringWithFormat:@"%@",areaid_selected] isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"This location doesn't have any clinic." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select area first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    }
}

-(IBAction)AddReminder
{
    [reminder resignFirstResponder];
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden = YES;
    
    if ((reminder.text == (id)[NSNull null] || reminder.text.length == 0 ) ||(clinicid_selected == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",clinicid_selected] isEqualToString:@""] ))
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please fill in all the fields to add alerts." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           NSDate *currentdateall = [NSDate date];
                           NSDateFormatter *formatter_date = [[NSDateFormatter alloc]init];
                           [formatter_date setDateFormat:@"dd-MMM-yyyy H:mm"];
                           NSString *date_str = [formatter_date stringFromDate:currentdateall];
                           
                           //Create domain class object
                           Alert *alert=[[Alert alloc]init];
                           
                           //set Add Reminder value in domain class
                           alert.location_string = areaid_selected;
                           alert.clinic_string = clinicid_selected;
                           alert.remarks_string = [reminder.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                           alert.current_datetime = date_str;
                           
                           //Create business manager class object
                           AlertManager *cm_business=[[AlertManager alloc]init];
                           NSString *response=[cm_business AddReminder:alert];//call businessmanager method and handle response
                           
                           if (response.length !=0)
                           {
                               NSDictionary *var =  [response JSONValue];
                               NSLog(@"dict Add Reminder Result %@",var);
                               //[alert_table reloadData];
                               reminder.text = @"";
                               areaid_selected = @"";
                               clinicid_selected = @"";
                               [clinic_button setTitle:@"" forState:UIControlStateNormal];
                               [location_button setTitle:@"" forState:UIControlStateNormal];
                               
                               [clinic_array removeAllObjects];
                               [alert_array removeAllObjects];
                               
                               [location_picker reloadAllComponents];
                               [clinic_picker reloadAllComponents];
                               location_picker.showsSelectionIndicator = NO;
                               //[self viewDidLoad];
                               [self ShowRemindersService];
                           }
                           [self removeActivityView];
                       });
    }
    
}

- (void)delete_reminder:(UIButton *)sender
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //NSIndexPath *indexPath = [alert_table indexPathForCell:(UITableViewCell *)[sender superview]];
                       CGPoint center= sender.center;
                       CGPoint rootViewPoint = [sender.superview convertPoint:center toView:alert_table];
                       NSIndexPath *indexPath = [alert_table indexPathForRowAtPoint:rootViewPoint];
                       
                       NSDictionary *itemAtIndex = (NSDictionary *)[alert_array objectAtIndex:indexPath.row];
                       //Create domain class object
                       Alert *alert=[[Alert alloc]init];
                       alert.reminder_id = [itemAtIndex objectForKey:@"Id"];
                       
                       //Create business manager class object
                       AlertManager *am_business=[[AlertManager alloc]init];
                       NSString *response=[am_business DeleteReminder:alert];//call businessmanager login method and handle response
                       
                       if (response.length !=0) 
                       {
                           NSDictionary *var =  [response JSONValue];
                           NSLog(@"dict Reminder List%@",var);
                           
                           [alert_array removeAllObjects];
                           [self ShowRemindersService];
                       }
                       [self removeActivityView];
                   });
}

@end
