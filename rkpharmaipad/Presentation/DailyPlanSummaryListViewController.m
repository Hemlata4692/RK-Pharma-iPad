//
//  DailyPlanSummaryListViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "DailyPlanSummaryListViewController.h"
#import "DailyPlanManager.h"
#import "DailyPlan.h"
#import "JSON.h"
#import "DejalActivityView.h"
#import "DailyPlanReportViewController.h"
#import "CreatePlanViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "DailyClinicPlannedViewController.h"

NSString *dailyplandatefromstring_selected = @"";
NSString *dailyplandatetostring_selected = @"";
@interface DailyPlanSummaryListViewController ()

@end
@implementation DailyPlanSummaryListViewController
@synthesize plan_table,sno,date,no_of_clinics_planned,no_of_clinics_visited,datefrom_button,datefrom_picker,error_label,dateshow_button,createplan_label,dateshow_label,error,manager_remarks,dateto_button,dateto_picker,areas,createplan_button;
@synthesize datefrom_picker_toolbar,dateto_picker_toolbar;

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
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
}


-(IBAction)PlanSummaryReport
{
    //Create domain class object
    DailyPlan *daily_plan=[[DailyPlan alloc]init];
    
    NSDateFormatter *df_month=[NSDateFormatter new];
    [df_month setDateFormat:@"MMM"];
    
    NSDateFormatter *df=[NSDateFormatter new];
    [df setDateFormat:@"dd-MMM-yyyy"];
    
    NSDate *today=[NSDate date];
    NSCalendar *gregCalendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components=[gregCalendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:today];
    //NSInteger month=[components month];
    NSInteger year=[components year];
    
    NSString *date_month = [df_month stringFromDate:today];
    NSDate *firstDateOfMonth = [df dateFromString:[NSString stringWithFormat:@"01-%@-%d",date_month,year]];
    NSLog(@" First Date of Month %@",[NSString stringWithFormat:@"01-%@-%d",date_month,year]);
    
    //NSDate *curDate = [df dateFromString:@"12-02-2012"];
    //NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:firstDateOfMonth]; // Get necessary date components
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:firstDateOfMonth]; // Get necessary date components
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *tDateMonth = [calendar dateFromComponents:comps];
    NSLog(@" Last Date Month %@", [df stringFromDate:tDateMonth]);
    
    if(![[NSString stringWithFormat:@"%@",dailyplandatefromstring_selected] isEqualToString:@""] || ![[NSString stringWithFormat:@"%@",dailyplandatetostring_selected] isEqualToString:@""])
    {
        daily_plan.StartDate = dailyplandatefromstring_selected;
        daily_plan.EndDate = dailyplandatetostring_selected;
    }
    else
    {
        //daily_plan.plan_date = dailyplandatefromstring_selected;
        daily_plan.StartDate = [NSString stringWithFormat:@"01-%@-%d",date_month,year];
        daily_plan.EndDate = [df stringFromDate:tDateMonth];
    }
    
    
    
    //Create business manager class object
    DailyPlanManager *plan_business=[[DailyPlanManager alloc]init];
    NSString *response=[plan_business GetDailyPlanSummarylist:daily_plan];//call businessmanager method and handle response
    NSLog(@" Plan Summary List response is %@",response);
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Plan Summary List%@",var);
        
        for(NSDictionary *dictvar in var)
        {
            [plan_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"PlanDate"],@"PlanDate",[dictvar objectForKey:@"ClinicsPlanned"],@"ClinicsPlanned",[dictvar objectForKey:@"ClinicsVisited"],@"ClinicsVisited",[dictvar objectForKey:@"ManagerRemark"],@"ManagerRemark",[dictvar objectForKey:@"Locations"],@"Locations",nil]];
            
        }
        
        [plan_table reloadData];
        // Do any additional setup after loading the view.
        
        //NSLog(@"plan count",)
        if(plan_array.count == 0)
        {
            self.plan_table.frame = CGRectMake(10,96,821,0);
        }
        else if(plan_array.count == 1)
        {
            self.plan_table.frame = CGRectMake(10,96,821,33);
        }
        else if(plan_array.count == 2)
        {
            self.plan_table.frame = CGRectMake(10,96,821,66);
        }
        else if(plan_array.count == 3)
        {
            self.plan_table.frame = CGRectMake(10,96,821,99);
        }
        else if(plan_array.count == 4)
        {
            self.plan_table.frame = CGRectMake(10,96,821,132);
        }
        else if(plan_array.count == 5)
        {
            self.plan_table.frame = CGRectMake(10,96,821,165);
        }
        else if(plan_array.count == 6)
        {
            self.plan_table.frame = CGRectMake(10,96,821,198);
        }
        else if(plan_array.count == 7)
        {
            self.plan_table.frame = CGRectMake(10,96,821,231);
        }
        else if(plan_array.count == 8)
        {
            self.plan_table.frame = CGRectMake(10,96,821,264);
        }
        else if(plan_array.count == 9)
        {
            self.plan_table.frame = CGRectMake(10,96,821,297);
        }
        else if(plan_array.count == 10)
        {
            self.plan_table.frame = CGRectMake(10,96,821,330);
        }
        else if(plan_array.count == 11)
        {
            self.plan_table.frame = CGRectMake(10,96,821,363);
        }
        else if(plan_array.count == 12)
        {
            self.plan_table.frame = CGRectMake(10,96,821,396);
        }
        else if(plan_array.count == 13)
        {
            self.plan_table.frame = CGRectMake(10,96,821,429);
        }
        else if(plan_array.count == 14)
        {
            self.plan_table.frame = CGRectMake(10,96,821,462);
        }
        else if(plan_array.count == 15)
        {
            self.plan_table.frame = CGRectMake(10,96,821,495);
        }
        else if(plan_array.count == 16)
        {
            self.plan_table.frame = CGRectMake(10,96,821,528);
        }
        else if(plan_array.count == 17)
        {
            self.plan_table.frame = CGRectMake(10,96,821,561);
        }
        else if(plan_array.count == 18)
        {
            self.plan_table.frame = CGRectMake(10,96,821,594);
        }
        else if(plan_array.count >= 19)
        {
            self.plan_table.frame = CGRectMake(10,96,821,627);
        }
        
        if(plan_array.count == 0)
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        createplan_button.hidden = YES;
        createplan_label.hidden = YES;
    }
    else
    {
        createplan_button.hidden = NO;
        createplan_label.hidden = NO;
    }
    
    plan_array = [[NSMutableArray alloc]init];
    
    plan_table.layer.borderWidth = 1.0;
    plan_table.layer.borderColor = [UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1].CGColor;
    
    dailyplandatefromstring_selected = @"";
    datefrom_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10,80+14,250,150)];
    datefrom_picker.datePickerMode = UIDatePickerModeDate;
    datefrom_picker.date = [NSDate date];
    [datefrom_picker addTarget:self action:@selector(ChangeDateFromLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datefrom_picker];
    datefrom_picker.hidden = YES;
    datefrom_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    dailyplandatetostring_selected = @"";
    dateto_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(151,80+14,250,150)];
    dateto_picker.datePickerMode = UIDatePickerModeDate;
    dateto_picker.date = [NSDate date];
    [dateto_picker addTarget:self action:@selector(ChangeDateToLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dateto_picker];
    dateto_picker.hidden = YES;
    dateto_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    dateto_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(dateto_picker.frame.origin.x, 50,dateto_picker.frame.size.width,30+14)];
    //[location_picker_toolbar sizeToFit];
    dateto_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems4 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems4 addObject:flexSpace4];
    
    UIBarButtonItem *doneBtn4 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn4.tag = 1;
    [doneBtn4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems4 addObject:doneBtn4];
    [dateto_picker_toolbar setItems:barItems4 animated:YES];
    [self.view addSubview:dateto_picker_toolbar];
    /**********************/
    dateto_picker_toolbar.hidden = YES;
    
    datefrom_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(datefrom_picker.frame.origin.x, 50,dateto_picker.frame.size.width,30+14)];
    //[location_picker_toolbar sizeToFit];
    datefrom_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems5 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems5 addObject:flexSpace5];
    
    UIBarButtonItem *doneBtn5 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn5.tag = 2;
    [doneBtn5 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems5 addObject:doneBtn5];
    [datefrom_picker_toolbar setItems:barItems5 animated:YES];
    [self.view addSubview:datefrom_picker_toolbar];
    /**********************/
    datefrom_picker_toolbar.hidden = YES;
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                                   initWithTarget:self
    //                                   action:@selector(dismissKeyboard)];
    //
    //    [self.view addGestureRecognizer:tap];
    //    [tap setCancelsTouchesInView:NO];
    
    createplan_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.plan_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    [self PlanSummaryReport];
    
}
-(IBAction)done_clicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag ==1)
    {
        dateto_picker.hidden=YES;
        dateto_picker_toolbar.hidden = YES;
    }
    else
    {
        datefrom_picker.hidden=YES;
        datefrom_picker_toolbar.hidden = YES;
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [[event allTouches] anyObject];
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
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
    return plan_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
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
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"planlist_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[plan_array objectAtIndex:indexPath.row];
    
    sno=(UILabel *)[cell viewWithTag:1];
    sno.text = [NSString stringWithFormat:@"%d",(plan_array.count + 1) - (indexPath.row+1)];
    
    
    dateshow_label=(UILabel *)[cell viewWithTag:2];
    dateshow_label.text =[itemAtIndex objectForKey:@"PlanDate"];
    
    clinics_planned=(UIButton *)[cell viewWithTag:3];
    NSInteger clinic_planned = [[itemAtIndex objectForKey:@"ClinicsPlanned"] integerValue];
    [clinics_planned setTitle:[NSString stringWithFormat: @"%d", clinic_planned] forState:UIControlStateNormal];
    [clinics_planned addTarget:self action:@selector(clinics_planned:)forControlEvents:UIControlEventTouchUpInside];
    
    //    no_of_clinics_planned=(UILabel *)[cell viewWithTag:3];
    //    NSInteger clinic_planned = [[itemAtIndex objectForKey:@"ClinicsPlanned"] integerValue];
    //    no_of_clinics_planned.text =[NSString stringWithFormat: @"%d", clinic_planned];
    
    //    no_of_clinics_visited=(UILabel *)[cell viewWithTag:4];
    //    NSInteger clinic_visited = [[itemAtIndex objectForKey:@"ClinicsVisited"] integerValue];
    //    no_of_clinics_visited.text =[NSString stringWithFormat:@"%d", clinic_visited];
    
    clinics_visited=(UIButton *)[cell viewWithTag:4];
    NSInteger clinic_visited = [[itemAtIndex objectForKey:@"ClinicsVisited"] integerValue];
    [clinics_visited setTitle:[NSString stringWithFormat: @"%d", clinic_visited] forState:UIControlStateNormal];
    [clinics_visited addTarget:self action:@selector(clinics_visited:)forControlEvents:UIControlEventTouchUpInside];
    
    manager_remarks=(UITextView *)[cell viewWithTag:5];
    manager_remarks.text = [itemAtIndex objectForKey:@"ManagerRemark"];
    
    
    
    areas=(UITextView *)[cell viewWithTag:6];
    areas.text = [itemAtIndex objectForKey:@"Locations"];
    
    if (indexPath.row % 2 == 0)
    {
        manager_remarks.backgroundColor=[UIColor whiteColor];
        areas.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        manager_remarks.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
        areas.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    }
    
    // To show custom separator
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableseparator_large.png"]];
    [self.plan_table setSeparatorColor:color];
    
    //    UIImage *background_first = [UIImage imageNamed:@"tablebg.png"];
    //    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background_first];
    //    cellBackgroundView.image = background_first;
    //    cell.backgroundView = cellBackgroundView;
    
    return cell;
}


- (void)clinics_planned:(UIButton *)sender
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //NSIndexPath *indexPath =[plan_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
                       CGPoint center= sender.center;
                       CGPoint rootViewPoint = [sender.superview convertPoint:center toView:plan_table];
                       NSIndexPath *indexPath = [plan_table indexPathForRowAtPoint:rootViewPoint];
                       NSDictionary *itemAtIndex = (NSDictionary *)[plan_array objectAtIndex:indexPath.row];
                       
                       NSString *PlanDate = (NSString *)[itemAtIndex objectForKey:@"PlanDate"];
                       //[dailyplanreportcontroller setSelected_date:PlanDate];
                       
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       [defaults setObject:PlanDate  forKey:@"PlanDate"];
                       
                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                       clinicsplannedcontroller = [storyboard instantiateViewControllerWithIdentifier:@"planned_clinic_screen"];
                       clinicsplannedcontroller.view.tag=990;
                       clinicsplannedcontroller.view.frame=CGRectMake(0,0, 841, 723);
                       
                       [clinicsplannedcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [clinicsplannedcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       
                       [self.view addSubview:clinicsplannedcontroller.view];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Report",@"heading", nil]];
                       [self removeActivityView];
                   });
}

- (void)clinics_visited:(UIButton *)sender
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //NSIndexPath *indexPath =[plan_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
                       CGPoint center= sender.center;
                       CGPoint rootViewPoint = [sender.superview convertPoint:center toView:plan_table];
                       NSIndexPath *indexPath = [plan_table indexPathForRowAtPoint:rootViewPoint];
                       
                       NSDictionary *itemAtIndex = (NSDictionary *)[plan_array objectAtIndex:indexPath.row];
                       
                       NSString *PlanDate = (NSString *)[itemAtIndex objectForKey:@"PlanDate"];
                       //[dailyplanreportcontroller setSelected_date:PlanDate];
                       
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       [defaults setObject:PlanDate  forKey:@"PlanDate"];
                       
                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                       dailyplanreportcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dailyreport_screen"];
                       dailyplanreportcontroller.view.tag=990;
                       dailyplanreportcontroller.view.frame=CGRectMake(0,0, 841, 723);
                       
                       [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       
                       [self.view addSubview:dailyplanreportcontroller.view];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Report",@"heading", nil]];
                       [self removeActivityView];
                   });
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *itemAtIndex = (NSDictionary *)[plan_array objectAtIndex:indexPath.row];
//    NSString *PlanDate = (NSString *)[itemAtIndex objectForKey:@"PlanDate"];
//    //[dailyplanreportcontroller setSelected_date:PlanDate];
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:PlanDate  forKey:@"PlanDate"];
//
//    [self displayActivityView];
//    double delayInSeconds = 1.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
//        dailyplanreportcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dailyreport_screen"];
//        dailyplanreportcontroller.view.tag=990;
//        dailyplanreportcontroller.view.frame=CGRectMake(0,0, 810, 740);
//
//        [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 810.0f, 740.0f)]; //notice this is OFF screen!
//        [UIView beginAnimations:@"animateTableView" context:nil];
//        [UIView setAnimationDuration:0.4];
//        [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 810.0f, 740.0f)]; //notice this is ON screen!
//        [UIView commitAnimations];
//
//
//        [self.view addSubview:dailyplanreportcontroller.view];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Report",@"heading", nil]];
//        [self removeActivityView];
//    });
//}



-(IBAction)ChangeDateFromLabel:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *plan_date = @"   ";
    plan_date = [plan_date stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:datefrom_picker.date]]];
    [datefrom_button setTitle:plan_date forState:UIControlStateNormal];
    dailyplandatefromstring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:datefrom_picker.date]];
    [datefrom_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}

-(IBAction)ChangeDateToLabel:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *plan_date = @"   ";
    plan_date = [plan_date stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:dateto_picker.date]]];
    [dateto_button setTitle:plan_date forState:UIControlStateNormal];
    dailyplandatetostring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:dateto_picker.date]];
    [dateto_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}

-(IBAction)ResetPlan
{
    datefrom_picker_toolbar.hidden = YES;
    datefrom_picker.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       dailyplandatefromstring_selected = @"";
                       dailyplandatetostring_selected = @"";
                       [plan_array removeAllObjects];
                       [datefrom_button setTitle:@"  Date From" forState:UIControlStateNormal];
                       [datefrom_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       
                       [dateto_button setTitle:@"  Date To" forState:UIControlStateNormal];
                       [dateto_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       
                       [self PlanSummaryReport];
                       
                       [self removeActivityView];
                   });
}

-(IBAction)SearchPlan
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [plan_array removeAllObjects];
                       [self PlanSummaryReport];
                       
                       [self removeActivityView];
                   });
}


-(IBAction)GetDateFrom
{
    if([datefrom_picker isHidden])
    {
        datefrom_picker.hidden=NO;
        datefrom_picker_toolbar.hidden = NO;
        dateto_picker.hidden=YES;
        dateto_picker_toolbar.hidden = YES;
    }
    else
    {
        datefrom_picker.hidden=YES;
        datefrom_picker_toolbar.hidden = YES;
    }
}

-(IBAction)GetDateTo
{
    if([dateto_picker isHidden])
    {
        datefrom_picker.hidden=YES;
        datefrom_picker_toolbar.hidden = YES;
        dateto_picker.hidden=NO;
        dateto_picker_toolbar.hidden = NO;
    }
    else
    {
        dateto_picker.hidden=YES;
        dateto_picker_toolbar.hidden = YES;
    }
}

- (void)Checkdailyreport:(UIButton *)sender
{
    //NSIndexPath *indexPath =[plan_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:plan_table];
    NSIndexPath *indexPath = [plan_table indexPathForRowAtPoint:rootViewPoint];
    
    NSDictionary *itemAtIndex = (NSDictionary *)[plan_array objectAtIndex:indexPath.row];
    
    NSString *PlanDate = (NSString *)[itemAtIndex objectForKey:@"PlanDate"];
    //[dailyplanreportcontroller setSelected_date:PlanDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:PlanDate  forKey:@"PlanDate"];
    
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                       dailyplanreportcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dailyreport_screen"];
                       dailyplanreportcontroller.view.tag=990;
                       dailyplanreportcontroller.view.frame=CGRectMake(0,0, 841, 723);
                       
                       [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       
                       [self.view addSubview:dailyplanreportcontroller.view];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Report",@"heading", nil]];
                       [self removeActivityView];
                   });
}

- (void)createplan_btn_clicked
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                       createplancontroller = [storyboard instantiateViewControllerWithIdentifier:@"createplan_screen"];
                       createplancontroller.view.tag=990;
                       createplancontroller.view.frame=CGRectMake(0,0, 841, 723);
                       
                       [createplancontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [createplancontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       
                       [self.view addSubview:createplancontroller.view];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Create Plan",@"heading", nil]];
                       [self removeActivityView];
                   });
}


@end
