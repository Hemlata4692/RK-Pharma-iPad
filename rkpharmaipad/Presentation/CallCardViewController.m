//
//  CallCardViewController.m
//  RKPharma
//
//  Created by Shivendra  singh on 13/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "CallCardViewController.h"
#import "DashboardViewController.h"
#import "DejalActivityView.h"
#import "DailyPlan.h"
#import "DailyPlanManager.h"
#import "JSON.h"
#import "UserManager.h"
#import "Clinic.h"
#import "ClinicManager.h"
#import "QuartzCore/QuartzCore.h"
#import "ClinicListViewController.h"
#import "ClinicDetailViewController.h"

NSString *callcardareaid_selected = @"";
NSString *callcardclinicid_selected = @"";
NSString *issuedbycompany_checked = @"1";
@interface CallCardViewController ()

@end

@implementation CallCardViewController
@synthesize date,products,sample,order,remarks,callcard_table,clinic_button,clinic_picker,location_button,location_picker,error,bonus,unofficialbonus,backbutton,search,backarrow,clinicname_label,clinicaddress_label,issuedby_company;
@synthesize location_picker_toolbar,clinic_picker_toolbar;
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

-(void)dismissKeyboard
{
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
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

- (void)CallCardService
{
    //Create domain class object
    DailyPlan *daily_plan=[[DailyPlan alloc]init];
    
    daily_plan.clinic_id = callcardclinicid_selected;
    daily_plan.WebSummary = issuedbycompany_checked;
    
    //Create business manager class object
    DailyPlanManager *plan_business=[[DailyPlanManager alloc]init];
    NSString *response=[plan_business GetCallCardlist:daily_plan];//call businessmanager method and handle response
    NSLog(@" Call Card List response is %@",response);
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Call Card List%@",var);
        
        for(NSDictionary *dictvar in var)
        {
            [callcard_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Date"],@"Date",[dictvar objectForKey:@"Order"],@"Order",[dictvar objectForKey:@"Product"],@"Product",[dictvar objectForKey:@"Remarks"],@"Remarks",[dictvar objectForKey:@"Sample"],@"Sample",[dictvar objectForKey:@"Bonus"],@"Bonus",[dictvar objectForKey:@"UnofficialBonus"],@"UnofficialBonus",[dictvar objectForKey:@"ClinicAssistant"],@"ClinicAssistant",[dictvar objectForKey:@"IsOrdered"],@"IsOrdered",[dictvar objectForKey:@"IsKIV"],@"IsKIV",[dictvar objectForKey:@"IsOrdered"],@"IsOrdered",[dictvar objectForKey:@"Borrowed"],@"Borrowed",[dictvar objectForKey:@"Returned"],@"Returned",nil]];
            
        }
        
        [callcard_table reloadData];
        // Do any additional setup after loading the view.
        
        //NSLog(@"plan count",)
        if(callcard_array.count == 0)
        {
            error.hidden = NO;
            error.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
            self.callcard_table.frame = CGRectMake(10,98,821,0);
        }
        else if(callcard_array.count == 1)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,60);
        }
        else if(callcard_array.count == 2)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,120);
        }
        else if(callcard_array.count == 3)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,180);
        }
        else if(callcard_array.count == 4)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,240);
        }
        else if(callcard_array.count == 5)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,300);
        }
        else if(callcard_array.count == 6)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,360);
        }
        else if(callcard_array.count == 7)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,420);
        }
        else if(callcard_array.count == 8)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,480);
        }
        else if(callcard_array.count == 9)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,540);
        }
        else if(callcard_array.count >= 10)
        {
            self.callcard_table.frame = CGRectMake(10,98,821,600);
        }
        
        if(callcard_array.count > 0)
        {
            error.hidden = YES;
        }
    }
    
}

- (void) ClinicService
{
    //Create domain class object
    Clinic *clinic=[[Clinic alloc]init];
    
    //set Clinic Name value in domain class
    clinic.location = callcardareaid_selected;
    
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    NSString *response=[cm_business GetClinicNameList:clinic];//call businessmanager login method and handle response
    
    
    NSDictionary *var =  [response JSONValue];
    NSLog(@"dict Clinic Name List%@",var);
    [clinic_array removeAllObjects];
    int i = 1;
    for(NSDictionary *dictvar in var)
    {
        //To Select bydefault first clinic
        if(i==1 && callcardcontroller.view.tag==990)
        {
            callcardclinicid_selected=[dictvar objectForKey:@"ClinicId"];
            NSString *clinic_name = @"   ";
            clinic_name = [clinic_name stringByAppendingString:[dictvar objectForKey:@"ClinicName"]];
            [clinic_button setTitle:[dictvar objectForKey:@"ClinicName"] forState:UIControlStateNormal];
            clinic_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 80);
            [clinic_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
            clinic_picker.showsSelectionIndicator = YES;
        }
        
        [clinic_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"ClinicId"],@"ClinicId",[dictvar objectForKey:@"ClinicName"],@"ClinicName",nil]];
        
        i++;
        
    }
    
    if(clinic_array.count==0)
    {
        callcardclinicid_selected=@"";
        NSString *clinic_name = @"   ";
        clinic_name = [clinic_name stringByAppendingString:@"No Clinic"];
        [clinic_button setTitle:@"No Clinic" forState:UIControlStateNormal];
        clinic_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 80);
        [clinic_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        clinic_picker.showsSelectionIndicator = NO;
    }
    
    [clinic_picker reloadAllComponents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    error.hidden = YES;
    
    issuedbycompany_checked = @"1";
    
    // To initialize array
    location_array = [[NSMutableArray alloc]init];
    clinic_array = [[NSMutableArray alloc]init];
    callcard_array = [[NSMutableArray alloc]init];
    
    callcard_table.layer.borderWidth = 1.0;
    callcard_table.layer.borderColor = [UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1].CGColor;
    
    // To Show Location Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    // To Set Location Picker
    location_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(10,52+30+14,200,100)];
    [location_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:location_picker];
    
    [location_picker setDelegate:self];
    [location_picker setDataSource:self];
    location_picker.hidden=YES;
    location_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    // To Show Clinic Picker View
    UITapGestureRecognizer *gestureRecognizerclinicpicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognizedclinicpicker:)];
    gestureRecognizerclinicpicker.cancelsTouchesInView = NO;
    
    // To Set Clinic Picker
    clinic_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(187,52+30+14,300,100)];
    [clinic_picker addGestureRecognizer:gestureRecognizerclinicpicker];
    [self.view addSubview:clinic_picker];
    
    [clinic_picker setDelegate:self];
    [clinic_picker setDataSource:self];
    clinic_picker.hidden=YES;
    clinic_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    
    /** picker toolbar code **/
    location_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(location_picker.frame.origin.x, 52,location_picker.frame.size.width,30+14)];
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
    clinic_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(clinic_picker.frame.origin.x, 52,clinic_picker.frame.size.width,30+14)];
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
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.callcard_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    
    
    
    
}

-(IBAction)toggleissuedbycompany
{
    checkBoxSelected=!checkBoxSelected;
    if ([issuedbycompany_checked isEqualToString:@"0"])
    {
        [issuedby_company setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
        
        issuedbycompany_checked = @"1";
        NSLog(@"checked");
    }
    else
    {
        [issuedby_company setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        issuedbycompany_checked = @"0";
        NSLog(@"UnChecked");
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"Check Tag   %ld",(long)callcardcontroller.view.tag);
    
    //Create business manager class object
    UserManager *um_business=[[UserManager alloc]init];
    // To Get Location
    NSString *location_response=[um_business GeLocationList];//call businessmanager Location method and handle response
    
    if (location_response.length !=0)
    {
        NSDictionary *location_var =  [location_response JSONValue];
        
        int i = 1;
        [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"LocationId",@"All",@"LocationName",nil]];
        for(NSDictionary *location_dictvar in location_var)
        {
            // To select bydefault first location
            if(i==1 && callcardcontroller.view.tag==990)
            {
                //                callcardareaid_selected = [location_dictvar objectForKey:@"LocationId"];
                //                NSLog(@" Get First Location Id %@",[location_dictvar objectForKey:@"LocationId"]);
                //
                //                NSString *location_name = @"   ";
                //                location_name = [location_name stringByAppendingString:[location_dictvar objectForKey:@"LocationName"]];
                //                [location_button setTitle:location_name forState:UIControlStateNormal];
                //                [location_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
                //                location_picker.showsSelectionIndicator = YES;
            }
            
            [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[location_dictvar objectForKey:@"LocationId"],@"LocationId",[location_dictvar objectForKey:@"LocationName"],@"LocationName",nil]];
            i++;
        }
        
        callcardareaid_selected = @"0";
        NSString *location_name = @"    All";
        [location_button setTitle:location_name forState:UIControlStateNormal];
        [location_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        location_picker.showsSelectionIndicator = YES;
        
        [self ClinicService];
        [self CallCardService];
    }
    
    if(callcardcontroller.view.tag==990)
    {
        backbutton.hidden = YES;
        backarrow.hidden = YES;
        NSLog(@"Hide Backarrow");
        
        clinicname_label.hidden = YES;
        clinicaddress_label.hidden = YES;
        
        clinic_button.hidden = NO;
        location_button.hidden = NO;
        search.hidden = NO;
    }
    else
    {
        backbutton.hidden = NO;
        backarrow.hidden = NO;
        NSLog(@"Show Backarrow");
        
        clinicname_label.hidden = NO;
        clinicaddress_label.hidden = NO;
        
        clinic_button.hidden = YES;
        location_button.hidden = YES;
        search.hidden = YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [[event allTouches] anyObject];
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    [super touchesBegan:touches withEvent:event];
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
    return callcard_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1]];
    }
    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
}

//-(void)viewDidLayoutSubviews
//{
//    if ([self.callcard_table respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.callcard_table setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([self.callcard_table respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.callcard_table setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"callcard_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[callcard_array objectAtIndex:indexPath.row];
    
    date=(UILabel *)[cell viewWithTag:1];
    date.text = [itemAtIndex objectForKey:@"Date"];
    
    
    NSLog(@"IS KIV %d",[[itemAtIndex objectForKey:@"IsKIV"] intValue]);
    NSLog(@"IS Order %d",[[itemAtIndex objectForKey:@"IsOrdered"] intValue]);
    
    if([[itemAtIndex objectForKey:@"IsKIV"] intValue]==1 && [[itemAtIndex objectForKey:@"IsOrdered"] intValue]==0)
    {
        date.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    else if([[itemAtIndex objectForKey:@"ClinicAssistant"] intValue]==1)
    {
        date.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(200/255.0) alpha:1];
    }
    else
    {
        date.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    
    
    products=(UILabel *)[cell viewWithTag:2];
    products.text = [itemAtIndex objectForKey:@"Product"];
    
    
    
    if([[itemAtIndex objectForKey:@"IsKIV"] intValue]==1 && [[itemAtIndex objectForKey:@"IsOrdered"] intValue]==0)
    {
        
        products.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    else if([[itemAtIndex objectForKey:@"ClinicAssistant"] intValue]==1)
    {
        products.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(200/255.0) alpha:1];
    }
    else
    {
        products.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    
    sample=(UILabel *)[cell viewWithTag:3];
    sample.text = [itemAtIndex objectForKey:@"Sample"];
    
    order=(UILabel *)[cell viewWithTag:4];
    order.text = [itemAtIndex objectForKey:@"Order"];
    
    remarks=(UITextView *)[cell viewWithTag:5];
    remarks.text = [itemAtIndex objectForKey:@"Remarks"];
    
    
    if (indexPath.row % 2 == 0)
    {
        remarks.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        remarks.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    }
    
    if([[itemAtIndex objectForKey:@"IsKIV"] intValue]==1 && [[itemAtIndex objectForKey:@"IsOrdered"] intValue]==0)
    {
        remarks.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    else if([[itemAtIndex objectForKey:@"ClinicAssistant"] intValue]==1)
    {
        remarks.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(200/255.0) alpha:1];
    }
    else
    {
        remarks.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    
    bonus=(UILabel *)[cell viewWithTag:6];
    bonus.text = [itemAtIndex objectForKey:@"Bonus"];
    
    unofficialbonus=(UILabel *)[cell viewWithTag:7];
    unofficialbonus.text = [itemAtIndex objectForKey:@"UnofficialBonus"];
    
    // To show custom separator
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableseparator_large.png"]];
    [self.callcard_table setSeparatorColor:color];
    //callcard_table.separatorColor = [UIColor lightGrayColor];
    
    //    UIImage *background_first = [UIImage imageNamed:@"tablebg_large.png"];
    //    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background_first];
    //    cellBackgroundView.image = background_first;
    //    cell.backgroundView = cellBackgroundView;
    
    
    
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
        //label size
        if(pickerView==location_picker)
        {
            CGRect frame = CGRectMake(20.0, 0.0, 150, 150);
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            //here you can play with fonts
            [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:13.0]];
        }
        else
        {
            CGRect frame = CGRectMake(20.0, 0.0, 250, 150);
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            //here you can play with fonts
            [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:13.0]];
        }
        
        
        
    }
    if(pickerView==location_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
        
        //picker view array is the datasource
        [pickerLabel setText:[itemAtIndex objectForKey:@"LocationName"]];
    }
    else
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
        callcardareaid_selected=[itemAtIndex objectForKey:@"LocationId"];
        
        NSString *location_name = @"   ";
        location_name = [location_name stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]];
        
        [location_button setTitle:[itemAtIndex objectForKey:@"LocationName"] forState:UIControlStateNormal];
        location_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 40);
        [location_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        location_picker.showsSelectionIndicator = YES;
        location_picker.hidden= NO;
        location_picker_toolbar.hidden = NO;
        [self ClinicService];
    }
    else
    {
        if(clinic_array.count>0)
        {
            NSDictionary *itemAtIndex = (NSDictionary *)[clinic_array objectAtIndex:row];
            callcardclinicid_selected=[itemAtIndex objectForKey:@"ClinicId"];
            
            NSString *clinic_name = @"   ";
            clinic_name = [clinic_name stringByAppendingString:[itemAtIndex objectForKey:@"ClinicName"]];
            
            [clinic_button setTitle:[itemAtIndex objectForKey:@"ClinicName"] forState:UIControlStateNormal];
            clinic_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 80);
            [clinic_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
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
        clinic_picker.hidden = YES;
        clinic_picker_toolbar.hidden = YES;
    }
    else
    {
        location_picker.hidden=YES;
        location_picker_toolbar.hidden = YES;
    }
}


-(IBAction)SearchCallcard
{
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [callcard_array removeAllObjects];
                       [self CallCardService];
                       
                       [self removeActivityView];
                   });
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
-(IBAction)GetClinics
{
    if(clinic_array.count>0)
    {
        
        if([clinic_picker isHidden])
        {
            clinic_picker.hidden=NO;
            clinic_picker_toolbar.hidden = NO;
            location_picker.hidden=YES;
            location_picker_toolbar.hidden = YES;
            
        }
        else
        {
            clinic_picker.hidden=YES;
            clinic_picker_toolbar.hidden = YES;
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"This location has no clinic" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)PassValue:(NSDictionary *)dict
{
    callcardclinicid_selected=[dict objectForKey:@"clinicid"];
    //callcardareaid_selected = [dict objectForKey:@"locationid"];
    NSLog(@"Call Card Clinic ID : %@",callcardclinicid_selected);
    //NSLog(@"Call Card Location ID : %@",callcardareaid_selected);
    NSLog(@"Call Card Clinic Namne : %@",[dict objectForKey:@"clinic_name"]);
    NSLog(@"Call Card Clinic Address : %@",[dict objectForKey:@"clinic_address"]);
    
    clinicname_label.text = [dict objectForKey:@"clinic_name"];
    clinicaddress_label.text = [dict objectForKey:@"clinic_address"];
}

-(IBAction)backbtn_clicked
{
    
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       if(callcardcontroller.view.tag==992)
                       {
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                           clinicdetailcontroller = [storyboard instantiateViewControllerWithIdentifier:@"clinicdetail_screen"];
                           clinicdetailcontroller.view.tag=990;
                           clinicdetailcontroller.view.frame=CGRectMake(0,0, 841, 723);
                           
                           [clinicdetailcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                           [UIView beginAnimations:@"animateTableView" context:nil];
                           [UIView setAnimationDuration:0.4];
                           [clinicdetailcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                           [UIView commitAnimations];
                           
                           
                           [self.view addSubview:clinicdetailcontroller.view];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:clinicname_label.text,@"heading", nil]];
                           [self removeActivityView];
                       }
                       else
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
                       }
                       
                   });
}

@end
