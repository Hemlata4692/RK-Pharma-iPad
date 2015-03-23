//
//  LeftSidebarViewController.m
//  RKPharma
//
//  Created by Shivendra  singh on 29/04/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "LeftSidebarViewController.h"
#import "ClinicListViewController.h"
#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "DejalActivityView.h"
#import "OrderListViewController.h"
#import "AdminAlertViewController.h"
#import "ProductListViewController.h"
#import "PriceCalculatorViewController.h"
#import "DailyPlanSummaryListViewController.h"
#import "CallCardViewController.h"
#import "KIVViewController.h"
#import "SampleRequestListViewController.h"
#import "GlobalVariable.h"

@interface LeftSidebarViewController ()

@end

@implementation LeftSidebarViewController
@synthesize sidebar_label,sidebar_image,sidebar_table,topheading_label,topusername_label;
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

-(void)ChangeLabelText:(NSNotification *)title
{
    NSString *opass_value=[title.userInfo objectForKey:@"heading"];
    topheading_label.text=opass_value;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    sidebar_array=[[NSMutableArray alloc]init];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"dashboardicon.png",@"image",@"Dashboard",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"clinicsicon.png",@"image",@"Clinics",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"productsicon.png",@"image",@"Products",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ordersicon.png",@"image",@"Orders",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"remindersicon.png",@"image",@"Rep's Alert",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"dailyplanicon.png",@"image",@"Daily Plan",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"callcardicon.png",@"image",@"Call Card",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"kivicon.png",@"image",@"KIV",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"sample-request.png",@"image",@"Samples",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"calculatoricon.png",@"image",@"Price Calculator",@"labelname" ,nil]];
    [sidebar_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"logouticon.png",@"image",@"Logout",@"labelname" ,nil]];
    //To Change the tabkleview background image
    sidebar_table.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftpanelbg.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.sidebar_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"blue-strip.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forBarMetrics:UIBarMetricsDefault];
    
    //UITableViewCell *cell = [self.sidebar_table cellForRowAtIndexPath:0];
    [sidebar_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    
    
    [dashboardcontroller.view removeFromSuperview];
    [clinicslistcontroller.view removeFromSuperview];
    [orderlistcontroller.view removeFromSuperview];
    [adminalertcontroller.view removeFromSuperview];
    [productslistcontroller.view removeFromSuperview];
    [pricecalculatorcontroller.view removeFromSuperview];
    [dailyplansummarylistcontroller.view removeFromSuperview];
    [callcardcontroller.view removeFromSuperview];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    dashboardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_screen"];
    dashboardcontroller.view.tag=990;
    dashboardcontroller.view.frame=CGRectMake(183,45, 841, 723);
    [self.view addSubview:dashboardcontroller.view];
    
    topusername_label.text = @"";
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        // code here
        [sidebar_table setSeparatorInset:UIEdgeInsetsZero];
        [topusername_label setFrame:CGRectMake(799, 19, 208, 21)];
        [topheading_label setFrame:CGRectMake(236, 19, 555, 21)];
    }
    else
    {
        [topusername_label setFrame:CGRectMake(799, 12, 208, 21)];
        [topheading_label setFrame:CGRectMake(236, 12, 555, 21)];
    }
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeLabelText:) name:@"send_video" object:nil];
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
    return sidebar_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    // Create a bitmap context.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"left_sidebar_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    sidebar_label=(UILabel *)[cell viewWithTag:2];
    sidebar_label.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    sidebar_label.font = [UIFont fontWithName:@"arial" size:14];
    cell.backgroundColor=[UIColor clearColor];
    NSDictionary *itemAtIndex = (NSDictionary *)[sidebar_array objectAtIndex:indexPath.row];
    sidebar_label.text=[itemAtIndex objectForKey:@"labelname"];
    
    sidebar_image = (UIImageView *)[cell viewWithTag:1];
    sidebar_image.image = [UIImage imageNamed:[itemAtIndex objectForKey:@"image"]];
    
    // To show custom separator
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashedline.png"]];
    //UIColor *color = [UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"dashedline.png"] scaledToSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)]];
    
    cell.backgroundColor = [UIColor clearColor];
    //sidebar_table.backgroundView = nil;
    
    [self.sidebar_table setSeparatorColor:color];
    
    
    //cell.backgroundColor = [UIColor clearColor];
    
    
    
    cell.selectedBackgroundView = [ [UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectedbg_new1.png"] ];
    
    //cell.selectedBackgroundView = [ [UIImageView alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"selectedbg.png"] scaledToSize:CGSizeMake(100, 25)] ];
    
    
    
    return cell;
}

-(void)viewDidLayoutSubviews
{
    if ([self.sidebar_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.sidebar_table setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.sidebar_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.sidebar_table setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];
    
    if(indexPath.row==0)
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            topusername_label.text = @"";
            [dashboardcontroller.view removeFromSuperview];
            [clinicslistcontroller.view removeFromSuperview];
            [orderlistcontroller.view removeFromSuperview];
            [adminalertcontroller.view removeFromSuperview];
            [productslistcontroller.view removeFromSuperview];
            [pricecalculatorcontroller.view removeFromSuperview];
            [dailyplansummarylistcontroller.view removeFromSuperview];
            [callcardcontroller.view removeFromSuperview];
            [KIVcontroller.view removeFromSuperview];
            [SampleRequestController.view removeFromSuperview];
            
            topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            topheading_label.text = @"Dashboard";
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            dashboardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_screen"];
            dashboardcontroller.view.tag=990;
            dashboardcontroller.view.frame=CGRectMake(183,45, 841, 723);

        
            [self.view addSubview:dashboardcontroller.view];
            [self removeActivityView];
        });
        
    }
    else if(indexPath.row==1)
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *top_usernamelabel = @"Welcome, ";
            top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
            topusername_label.text = [top_usernamelabel capitalizedString];
            
            
        
            [dashboardcontroller.view removeFromSuperview];
            [clinicslistcontroller.view removeFromSuperview];
            [orderlistcontroller.view removeFromSuperview];
            [adminalertcontroller.view removeFromSuperview];
            [productslistcontroller.view removeFromSuperview];
            [pricecalculatorcontroller.view removeFromSuperview];
            [dailyplansummarylistcontroller.view removeFromSuperview];
            [callcardcontroller.view removeFromSuperview];
            [KIVcontroller.view removeFromSuperview];
            [SampleRequestController.view removeFromSuperview];
            
            topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            topheading_label.text = @"Clinics";
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            clinicslistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"clinics_screen"];
            clinicslistcontroller.view.tag=990; 
            clinicslistcontroller.view.frame=CGRectMake(183,45, 841, 723);
        
        
            [self.view addSubview:clinicslistcontroller.view];
            [self removeActivityView];
        });    
        
    }
    // This will open Products list view
    else if(indexPath.row==2)
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *top_usernamelabel = @"Welcome, ";
            top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
            topusername_label.text = [top_usernamelabel capitalizedString];
            
            [dashboardcontroller.view removeFromSuperview];
            [clinicslistcontroller.view removeFromSuperview];
            [orderlistcontroller.view removeFromSuperview];
            [adminalertcontroller.view removeFromSuperview];
            [productslistcontroller.view removeFromSuperview];
            [pricecalculatorcontroller.view removeFromSuperview];
            [dailyplansummarylistcontroller.view removeFromSuperview];
            [callcardcontroller.view removeFromSuperview];
            [KIVcontroller.view removeFromSuperview];
            [SampleRequestController.view removeFromSuperview];
            
            topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            topheading_label.text = @"Products";
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            productslistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"products_screen"];
            productslistcontroller.view.tag=990;
            productslistcontroller.view.frame=CGRectMake(183,45, 841, 723);
            
            
            [self.view addSubview:productslistcontroller.view];
            [self removeActivityView];
        });  
    }
    else if(indexPath.row==3)
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
         {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *top_usernamelabel = @"Welcome, ";
            top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
            topusername_label.text = [top_usernamelabel capitalizedString];
                           
             [dashboardcontroller.view removeFromSuperview];
             [clinicslistcontroller.view removeFromSuperview];
             [orderlistcontroller.view removeFromSuperview];
             [adminalertcontroller.view removeFromSuperview];
             [productslistcontroller.view removeFromSuperview];
             [pricecalculatorcontroller.view removeFromSuperview];
             [dailyplansummarylistcontroller.view removeFromSuperview];
             [callcardcontroller.view removeFromSuperview];
             [KIVcontroller.view removeFromSuperview];
             [SampleRequestController.view removeFromSuperview];
             
             topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
             topheading_label.text = @"Orders";
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
             orderlistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"neworder_screen"];
             orderlistcontroller.view.tag=990; 
             orderlistcontroller.view.frame=CGRectMake(183,45, 841, 754);
             
             
             [self.view addSubview:orderlistcontroller.view];
             [self removeActivityView];
                           
        });    
        
    }
    else if(indexPath.row==4)
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSString *top_usernamelabel = @"Welcome, ";
             top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
             topusername_label.text = [top_usernamelabel capitalizedString];
             
             [dashboardcontroller.view removeFromSuperview];
             [clinicslistcontroller.view removeFromSuperview];
             [orderlistcontroller.view removeFromSuperview];
             [adminalertcontroller.view removeFromSuperview];
             [productslistcontroller.view removeFromSuperview];
             [pricecalculatorcontroller.view removeFromSuperview];
             [dailyplansummarylistcontroller.view removeFromSuperview];
             [callcardcontroller.view removeFromSuperview];
             [KIVcontroller.view removeFromSuperview];
             [SampleRequestController.view removeFromSuperview];
             
             topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
             topheading_label.text = @"Rep's Alert";
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
             adminalertcontroller = [storyboard instantiateViewControllerWithIdentifier:@"alert_screen"];
             adminalertcontroller.view.tag=990; 
             adminalertcontroller.view.frame=CGRectMake(183,45, 841, 723);
             
             
             [self.view addSubview:adminalertcontroller.view];
             [self removeActivityView];
         }); 
        
    }
    else if(indexPath.row==5)
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *top_usernamelabel = @"Welcome, ";
            top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
            topusername_label.text = [top_usernamelabel capitalizedString];
            
            [dashboardcontroller.view removeFromSuperview];
            [clinicslistcontroller.view removeFromSuperview];
            [orderlistcontroller.view removeFromSuperview];
            [adminalertcontroller.view removeFromSuperview];
            [productslistcontroller.view removeFromSuperview];
            [pricecalculatorcontroller.view removeFromSuperview];
            [dailyplansummarylistcontroller.view removeFromSuperview];
            [callcardcontroller.view removeFromSuperview];
            [KIVcontroller.view removeFromSuperview];
            [SampleRequestController.view removeFromSuperview];
            
            topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            topheading_label.text = @"Daily Plan";
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            dailyplansummarylistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"daily_plan_summary_report_list"];
            dailyplansummarylistcontroller.view.tag=990;
            dailyplansummarylistcontroller.view.frame=CGRectMake(183,45, 841, 723);
            
            
            [self.view addSubview:dailyplansummarylistcontroller.view];
            [self removeActivityView];
        }); 
        
    }
    else if(indexPath.row==6)
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *top_usernamelabel = @"Welcome, ";
            top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
            topusername_label.text = [top_usernamelabel capitalizedString];
            
            [dashboardcontroller.view removeFromSuperview];
            [clinicslistcontroller.view removeFromSuperview];
            [orderlistcontroller.view removeFromSuperview];
            [adminalertcontroller.view removeFromSuperview];
            [productslistcontroller.view removeFromSuperview];
            [pricecalculatorcontroller.view removeFromSuperview];
            [dailyplansummarylistcontroller.view removeFromSuperview];
            [callcardcontroller.view removeFromSuperview];
            [KIVcontroller.view removeFromSuperview];
            [SampleRequestController.view removeFromSuperview];
            
            topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            topheading_label.text = @"Call Card";
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            callcardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"callcard_screen"];
            callcardcontroller.view.tag=990;
            callcardcontroller.view.frame=CGRectMake(183,45, 841, 723);
            
            
            [self.view addSubview:callcardcontroller.view];
            [self removeActivityView];
        }); 
        
    }
    else if(indexPath.row==7)
    {
        
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *top_usernamelabel = @"Welcome, ";
            top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
            topusername_label.text = [top_usernamelabel capitalizedString];
            [productslistcontroller.view removeFromSuperview];
            [adminalertcontroller.view removeFromSuperview];
            [dashboardcontroller.view removeFromSuperview];
            [clinicslistcontroller.view removeFromSuperview];
            [orderlistcontroller.view removeFromSuperview];
            [pricecalculatorcontroller.view removeFromSuperview];
            [dailyplansummarylistcontroller.view removeFromSuperview];
            [callcardcontroller.view removeFromSuperview];
            [SampleRequestController.view removeFromSuperview];
            
            topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            topheading_label.text = @"KIV Report";
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            KIVcontroller = [storyboard instantiateViewControllerWithIdentifier:@"KIV_screen"];
            KIVcontroller.view.tag=990;
            KIVcontroller.view.frame=CGRectMake(183,45, 841, 723);
            
            
            [self.view addSubview:KIVcontroller.view];
            [self removeActivityView];
            
        });
    }
    else if(indexPath.row==8)
    {
        
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                           NSString *top_usernamelabel = @"Welcome, ";
                           top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
                           topusername_label.text = [top_usernamelabel capitalizedString];
                           [productslistcontroller.view removeFromSuperview];
                           [adminalertcontroller.view removeFromSuperview];
                           [dashboardcontroller.view removeFromSuperview];
                           [clinicslistcontroller.view removeFromSuperview];
                           [orderlistcontroller.view removeFromSuperview];
                           [pricecalculatorcontroller.view removeFromSuperview];
                           [dailyplansummarylistcontroller.view removeFromSuperview];
                           [callcardcontroller.view removeFromSuperview];
                           [KIVcontroller.view removeFromSuperview];
                           
                           topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
                           topheading_label.text = @"Samples";
                           
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                           SampleRequestController = [storyboard instantiateViewControllerWithIdentifier:@"samplerequest_screen"];
                           SampleRequestController.view.tag=990;
                           SampleRequestController.view.frame=CGRectMake(183,45, 841, 723);
                           
                           
                           [self.view addSubview:SampleRequestController.view];
                           [self removeActivityView];
                           
                       });
    }
    else if(indexPath.row==9)
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                           NSString *top_usernamelabel = @"Welcome, ";
                           top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
                           topusername_label.text = [top_usernamelabel capitalizedString];
                           [productslistcontroller.view removeFromSuperview];
                           [adminalertcontroller.view removeFromSuperview];
                           [dashboardcontroller.view removeFromSuperview];
                           [clinicslistcontroller.view removeFromSuperview];
                           [orderlistcontroller.view removeFromSuperview];
                           [pricecalculatorcontroller.view removeFromSuperview];
                           [dailyplansummarylistcontroller.view removeFromSuperview];
                           [callcardcontroller.view removeFromSuperview];
                           [KIVcontroller.view removeFromSuperview];
                           [SampleRequestController.view removeFromSuperview];
                           
                           topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
                           topheading_label.text = @"Price Calculator";
                           
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                           pricecalculatorcontroller = [storyboard instantiateViewControllerWithIdentifier:@"calculator_screen"];
                           pricecalculatorcontroller.view.tag=990;
                           pricecalculatorcontroller.view.frame=CGRectMake(183,45, 841, 723);
                           
                           
                           [self.view addSubview:pricecalculatorcontroller.view];
                           [self removeActivityView];
                       }); 
        
    }
    else if(indexPath.row==10)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        LoginViewController *loginviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"login_screen"];
        [self presentModalViewController:loginviewcontroller animated:YES];
    }
    else 
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *top_usernamelabel = @"Welcome, ";
        top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
        topusername_label.text = [top_usernamelabel capitalizedString];
        [dashboardcontroller.view removeFromSuperview];
        [clinicslistcontroller.view removeFromSuperview];
        [orderlistcontroller.view removeFromSuperview];
        [adminalertcontroller.view removeFromSuperview];
        [productslistcontroller.view removeFromSuperview];
        [pricecalculatorcontroller.view removeFromSuperview];
        [dailyplansummarylistcontroller.view removeFromSuperview];
        [callcardcontroller.view removeFromSuperview];
        [KIVcontroller.view removeFromSuperview];
        [SampleRequestController.view removeFromSuperview];
    }
    
}


@end