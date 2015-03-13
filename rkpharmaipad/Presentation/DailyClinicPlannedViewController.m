//
//  DailyClinicPlannedViewController.m
//  RKPharma
//
//  Created by Shivendra  singh on 29/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "DailyClinicPlannedViewController.h"
#import "JSON.h"
#import "QuartzCore/QuartzCore.h"
#import "DailyPlanManager.h"
#import "DailyPlan.h"
#import "DejalActivityView.h"
#import "CallSummaryViewController.h"
#import "DailyPlanListViewController.h"

@interface DailyClinicPlannedViewController ()

@end

@implementation DailyClinicPlannedViewController
@synthesize date,clinicname,locationname,fillsummary,error_label,back,planned_table;
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

-(IBAction)DailyPlannedService
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                
    //Create domain class object
    DailyPlan *daily_plan=[[DailyPlan alloc]init];
    daily_plan.plan_date = [defaults objectForKey:@"PlanDate"];
    daily_plan.IsVisited = @"0";
    
    //Create business manager class object
    DailyPlanManager *plan_business=[[DailyPlanManager alloc]init];
    NSString *response=[plan_business GetMeetingSummary:daily_plan];//call businessmanager method and handle response
    NSLog(@" Daily Report List response is %@",response);
    
    if (response.length !=0) 
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Daily Report Planned List%@",var);
        for(NSDictionary *dictvar in var)
        {
            [planned_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Clinic"],@"ClinicName",[dictvar objectForKey:@"Location"],@"Location",[dictvar objectForKey:@"PlanId"],@"PlanId",[dictvar objectForKey:@"IsLocked"],@"IsLocked",[dictvar objectForKey:@"Summary"],@"Summary",[dictvar objectForKey:@"UnPlanned"],@"UnPlanned",nil]];
        }
        
        [planned_table reloadData];
        
        if(planned_array.count == 0)
        {
            //error.hidden = NO;
            //error.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
            self.planned_table.frame = CGRectMake(10,82,821,0);
        }
        else if(planned_array.count == 1)
        {
            self.planned_table.frame = CGRectMake(10,82,821,44);
        }
        else if(planned_array.count == 2)
        {
            self.planned_table.frame = CGRectMake(10,82,821,88);
        }
        else if(planned_array.count == 3)
        {
            self.planned_table.frame = CGRectMake(10,82,821,132);
        }
        else if(planned_array.count == 4)
        {
            self.planned_table.frame = CGRectMake(10,82,821,176);
        }
        else if(planned_array.count == 5)
        {
            self.planned_table.frame = CGRectMake(10,82,821,220);
        }
        else if(planned_array.count == 6)
        {
            self.planned_table.frame = CGRectMake(10,82,821,264);
        }
        else if(planned_array.count == 7)
        {
            self.planned_table.frame = CGRectMake(10,82,821,308);
        }
        else if(planned_array.count == 8)
        {
            self.planned_table.frame = CGRectMake(10,82,821,352);
        }
        else if(planned_array.count == 9)
        {
            self.planned_table.frame = CGRectMake(10,82,821,396);
        }
        else if(planned_array.count == 10)
        {
            self.planned_table.frame = CGRectMake(10,82,821,440);
        }
        else if(planned_array.count == 11)
        {
            self.planned_table.frame = CGRectMake(10,82,821,484);
        }
        else if(planned_array.count == 12)
        {
            self.planned_table.frame = CGRectMake(10,82,821,528);
        }
        else if(planned_array.count >= 13)
        {
            self.planned_table.frame = CGRectMake(10,82,821,572);
        }
        
//        if(planned_array.count > 0)
//        {
//            error.hidden = YES;
//        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    planned_table.layer.borderWidth = 1.0;
    planned_table.layer.borderColor = [UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1].CGColor;
    
    [back setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1]forState:UIControlStateNormal];
    
    planned_array = [[NSMutableArray alloc]init];
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.planned_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    date.text = [defaults objectForKey:@"PlanDate"];
    [self DailyPlannedService];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return planned_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    static NSString *CellIdentifier = @"planned_clinic_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[planned_array objectAtIndex:indexPath.row];
    
    clinicname=(UILabel *)[cell viewWithTag:1];
    clinicname.text = [itemAtIndex objectForKey:@"ClinicName"];
    
    
    locationname=(UILabel *)[cell viewWithTag:2];
    locationname.text =[itemAtIndex objectForKey:@"Location"];
    
    fillsummary=(UIButton *)[cell viewWithTag:3];
    [fillsummary addTarget:self action:@selector(call_summary:)forControlEvents:UIControlEventTouchUpInside];
    
    if([[itemAtIndex objectForKey:@"Summary"] intValue]==1 || [[itemAtIndex objectForKey:@"IsLocked"] intValue]==1)
    {
        fillsummary.hidden = YES;
    }
    else 
    {
        fillsummary.hidden = NO;
    }
  
    // To show custom separator
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableseparator_large.png"]];
    [self.planned_table setSeparatorColor:color];
    
    return cell;
}

- (void)call_summary:(UIButton *)sender
{
    
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        //NSIndexPath *indexPath =[planned_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        CGPoint center= sender.center;
        CGPoint rootViewPoint = [sender.superview convertPoint:center toView:planned_table];
        NSIndexPath *indexPath = [planned_table indexPathForRowAtPoint:rootViewPoint];
        NSDictionary *itemAtIndex = (NSDictionary *)[planned_array objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        
        callsummarycontroller = [storyboard instantiateViewControllerWithIdentifier:@"callsummary_screen"];
        callsummarycontroller.view.tag=992;
        callsummarycontroller.view.frame=CGRectMake(0,0, 841, 723);
        callsummarycontroller.title = @"Report";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [callsummarycontroller PassValue:[NSDictionary dictionaryWithObjectsAndKeys:[itemAtIndex objectForKey:@"PlanId"],@"planid",[itemAtIndex objectForKey:@"Location"],@"location",[itemAtIndex objectForKey:@"ClinicName"],@"clinic",[defaults objectForKey:@"PlanDate"],@"plandate", nil]];
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


@end
