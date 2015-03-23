//
//  DailyPlanReportViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "DailyPlanReportViewController.h"
#import "JSON.h"
#import "DailyPlanManager.h"
#import "DailyPlan.h"
#import "DejalActivityView.h"
#import "CallSummaryViewController.h"
#import "DailyPlanListViewController.h"
#import "EditCallSummaryViewController.h"


@interface DailyPlanReportViewController ()

@end

@implementation DailyPlanReportViewController
@synthesize clinicname_label,products,location_label,order,remarks,selected_date,dailyreport_table,plan_date,error,fillsummary_button,back,clinicassistant;

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

-(IBAction)DailyReportService
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
    NSLog(@" SelectEd Report Service %@",selected_date);
    //Create domain class object
    DailyPlan *daily_plan=[[DailyPlan alloc]init];
    
    daily_plan.plan_date = [defaults objectForKey:@"PlanDate"];
    daily_plan.IsVisited = @"1";
    
    //Create business manager class object
    DailyPlanManager *plan_business=[[DailyPlanManager alloc]init];
    NSString *response=[plan_business GetMeetingSummary:daily_plan];//call businessmanager method and handle response
    NSLog(@" Daily Report List response is %@",response);
    
    if (response.length !=0) 
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Daily Report List%@",var);
        for(NSDictionary *dictvar in var)
        {
            
            products_array = [[NSMutableArray alloc]init];
            //[businesshour_string setString:@""];
            for(NSDictionary *dictproductvar in [dictvar objectForKey:@"Products"])
            {
                [products_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictproductvar objectForKey:@"Product"],@"Product",nil]];
            }
            
            NSLog(@" Check %@..%@",dictvar,[dictvar objectForKey:@"Clinic"]);
            [dailyreport_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Clinic"],@"ClinicName",[dictvar objectForKey:@"Location"],@"Location",[dictvar objectForKey:@"OrderInfo"],@"OrderInfo",[dictvar objectForKey:@"Remarks"],@"Remarks",products_array,@"Products",[dictvar objectForKey:@"PlanId"],@"PlanId",[dictvar objectForKey:@"IsLocked"],@"IsLocked",[dictvar objectForKey:@"Summary"],@"Summary",[dictvar objectForKey:@"ClinicAssistant"],@"ClinicAssistant",[dictvar objectForKey:@"SummaryId"],@"SummaryId",nil]];
            
        }
        
        [dailyreport_table reloadData];
        // Do any additional setup after loading the view.
        if(dailyreport_array.count == 0)
        {
            error.hidden = NO;
            error.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
            self.dailyreport_table.frame = CGRectMake(10,82,821,0);
        }
        else if(dailyreport_array.count == 1)
        {
            self.dailyreport_table.frame = CGRectMake(10,82,821,110);
        }
        else if(dailyreport_array.count == 2)
        {
            self.dailyreport_table.frame = CGRectMake(10,82,821,220);
        }
        else if(dailyreport_array.count == 3)
        {
            self.dailyreport_table.frame = CGRectMake(10,82,821,330);
        }
        else if(dailyreport_array.count == 4)
        {
            self.dailyreport_table.frame = CGRectMake(10,82,821,440);
        }
        else if(dailyreport_array.count == 5)
        {
            self.dailyreport_table.frame = CGRectMake(10,82,821,550);
        }
        else if(dailyreport_array.count >= 6)
        {
            self.dailyreport_table.frame = CGRectMake(10,82,821,660);
        }
        
        if(dailyreport_array.count > 0)
        {
            error.hidden = YES;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     	// Do any additional setup after loading the view.
    
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
//    NSDate *planneddate = [dateFormatter dateFromString:@"31-May-2013"];
//    
//    
//    NSDate *todaysDate = [NSDate date];
//    
//    NSTimeInterval lastDiff = [planneddate timeIntervalSinceNow];
//    NSTimeInterval todaysDiff = [todaysDate timeIntervalSinceNow];
//    NSTimeInterval dateDiff = lastDiff - todaysDiff;
//    
//    NSLog(@" Difference : %f",dateDiff);
    
    NSLog(@" CCCCC%@",selected_date);
    [back setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1]forState:UIControlStateNormal];
    
    dailyreport_array = [[NSMutableArray alloc]init];
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.dailyreport_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    plan_date.text = [defaults objectForKey:@"PlanDate"];
    [self DailyReportService];
    
}

- (void) viewDidAppear:(BOOL)animated
{
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
    return dailyreport_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
    static NSString *CellIdentifier = @"dailyreport_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[dailyreport_array objectAtIndex:indexPath.row];
    
    clinicname_label=(UILabel *)[cell viewWithTag:1];
    clinicname_label.text = [itemAtIndex objectForKey:@"ClinicName"];
    
    location_label=(UILabel *)[cell viewWithTag:2];
    location_label.text = [itemAtIndex objectForKey:@"Location"];
    
    order=(UILabel *)[cell viewWithTag:4];
    order.text = [itemAtIndex objectForKey:@"OrderInfo"];
    
    remarks=(UILabel *)[cell viewWithTag:5];
    remarks.text = [itemAtIndex objectForKey:@"Remarks"];
    
    NSMutableString *product_string = [NSMutableString string];
    for(NSDictionary *dictvar in [itemAtIndex objectForKey:@"Products"])
    {
        [product_string appendString:[NSString stringWithFormat:@"%@\n",[dictvar objectForKey:@"Product"]]];
    }
    
    NSLog(@" P String%@",product_string);
    
    products=(UITextView *)[cell viewWithTag:3];
    products.text = product_string;
    
    if (indexPath.row % 2 == 0) 
    {
        products.backgroundColor=[UIColor whiteColor];    }
    else 
    {
        products.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    }
    
    
    fillsummary_button=(UIButton *)[cell viewWithTag:6];
    [fillsummary_button addTarget:self action:@selector(editcall_summary:)forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if([[itemAtIndex objectForKey:@"IsLocked"] intValue]==1)
    {
        fillsummary_button.hidden = YES;
    }
    else if([[itemAtIndex objectForKey:@"Summary"] intValue]==1)
    {
        fillsummary_button.hidden = NO;
    }
    
    if([[itemAtIndex objectForKey:@"ClinicAssistant"] intValue]==1)
    {
        clinicassistant=(UILabel *)[cell viewWithTag:7];
        clinicassistant.hidden = NO;
    }
    else 
    {
        clinicassistant=(UILabel *)[cell viewWithTag:7];
        clinicassistant.hidden = YES;

    }
    
    
    // To show custom separator
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableseparator_large.png"]];
    [self.dailyreport_table setSeparatorColor:color];
    

  
    
    UIImage *background_first = [UIImage imageNamed:@"tablebg_large.png"];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background_first];
    cellBackgroundView.image = background_first;
    cell.backgroundView = cellBackgroundView;
    
    
    
    return cell;
}

- (void)editcall_summary:(UIButton *)sender
{
    
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        //NSIndexPath *indexPath =[dailyreport_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        CGPoint center= sender.center;
        CGPoint rootViewPoint = [sender.superview convertPoint:center toView:dailyreport_table];
        NSIndexPath *indexPath = [dailyreport_table indexPathForRowAtPoint:rootViewPoint];
        
        NSDictionary *itemAtIndex = (NSDictionary *)[dailyreport_array objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        
        editcallsummarycontroller = [storyboard instantiateViewControllerWithIdentifier:@"editcallsummary_screen"];
        editcallsummarycontroller.view.tag=990;
        editcallsummarycontroller.view.frame=CGRectMake(0,0, 841, 723);
        editcallsummarycontroller.title = @"Report";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [editcallsummarycontroller PassValue:[NSDictionary dictionaryWithObjectsAndKeys:[itemAtIndex objectForKey:@"PlanId"],@"planid",[itemAtIndex objectForKey:@"Location"],@"location",[itemAtIndex objectForKey:@"ClinicName"],@"clinic",[defaults objectForKey:@"PlanDate"],@"plandate",[itemAtIndex objectForKey:@"SummaryId"],@"summaryid", nil]];
        [editcallsummarycontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [editcallsummarycontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        [self.view addSubview:editcallsummarycontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Edit Call Summary",@"heading", nil]];
        [self removeActivityView];
    });
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



@end
