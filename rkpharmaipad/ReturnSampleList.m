//
//  ReturnSampleList.m
//  RKPharma
//
//  Created by Shiven on 9/3/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "ReturnSampleList.h"
#import "SampleRequestListViewController.h"
#import "JSON.h"
#import "Product.h"
#import "DejalActivityView.h"
#import "ProductManager.h"
#import "ViewReturnSample.h"
#import "EditReturnSample.h"


NSString *returnsampledatetostring_selected = @"";
NSString *returnsampledatefromstring_selected = @"";

@interface ReturnSampleList ()

@end

@implementation ReturnSampleList
@synthesize returnsample_table,datefrom_button,datefrom_picker,dateto_button,dateto_picker,indicator,status_button,error_label,exp_date,return_date,return_qty,product_name,issued_date,returnsample_status,sno,batch_no;

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


-(IBAction)ChangeDateToLabel:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    //[dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateto_string = @"   ";
    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:dateto_picker.date]]];
    [dateto_button setTitle:dateto_string forState:UIControlStateNormal];
    returnsampledatetostring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:dateto_picker.date]];
    [dateto_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}

-(IBAction)ChangeDateFromLabel:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    //[dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *datefrom_string = @"   ";
    datefrom_string = [datefrom_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:datefrom_picker.date]]];
    [datefrom_button setTitle:datefrom_string forState:UIControlStateNormal];
    returnsampledatefromstring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:datefrom_picker.date]];
    [datefrom_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
    
}



-(IBAction)SampleReturnService
{
    //Create domain class object
    Product *product=[[Product alloc]init];
    
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
    
    if(![[NSString stringWithFormat:@"%@",returnsampledatefromstring_selected] isEqualToString:@""] || ![[NSString stringWithFormat:@"%@",returnsampledatetostring_selected] isEqualToString:@""])
    {
        NSLog(@" If Con");
        product.datefrom_string = returnsampledatefromstring_selected;
        product.dateto_string = returnsampledatetostring_selected;
    }
    else
    {
        NSLog(@" Else Con");
        product.datefrom_string = [NSString stringWithFormat:@"01-%@-%d",date_month,year];
        product.dateto_string = [df stringFromDate:tDateMonth];
    }
    
    
    
    //Create business manager class object
    ProductManager *pm_business=[[ProductManager alloc]init];
    NSString *response=[pm_business GetSampleReturntList:product];//call businessmanager login method and handle response
    NSLog(@" Sample Return List response is %@",response);
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Sample Return List%@",var);
        
        
        for(NSDictionary *dictvar in var)
        {
            NSLog(@" ABOVE Dict %@",dictvar);
            [returnsample_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"SampleId"],@"SampleId",[dictvar objectForKey:@"SampleName"],@"SampleName",[dictvar objectForKey:@"Unit"],@"Unit",[dictvar objectForKey:@"Quantity"],@"Quantity",[dictvar objectForKey:@"BatchNo"],@"BatchNo",[dictvar objectForKey:@"ExpiryDate"],@"ExpiryDate",[dictvar objectForKey:@"ReturnedQuantity"],@"ReturnedQuantity",[dictvar objectForKey:@"ReturnDate"],@"ReturnDate",[dictvar objectForKey:@"IssueMonth"],@"IssueMonth",[dictvar objectForKey:@"IsAccepted"],@"IsAccepted",nil]];
            
        }
        [returnsample_table reloadData];
        // Do any additional setup after loading the view.
        
        
        if(returnsample_array.count == 0)
        {
            self.returnsample_table.frame = CGRectMake(10,86,821,0);
        }
        else if(returnsample_array.count == 1)
        {
            self.returnsample_table.frame = CGRectMake(10,86,821,100);
        }
        else if(returnsample_array.count == 2)
        {
            self.returnsample_table.frame = CGRectMake(10,86,821,200);
        }
        else if(returnsample_array.count == 3)
        {
            self.returnsample_table.frame = CGRectMake(10,86,821,300);
        }
        else if(returnsample_array.count == 4)
        {
            self.returnsample_table.frame = CGRectMake(10,86,821,400);
        }
        else if(returnsample_array.count == 5)
        {
            self.returnsample_table.frame = CGRectMake(10,86,821,500);
        }
        else if(returnsample_array.count >= 6)
        {
            self.returnsample_table.frame = CGRectMake(10,86,821,600);
        }
        
        
        if(returnsample_array.count == 0)
        {
            error_label.text = @"No Record Found !";
            error_label.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        }
        else
        {
            error_label.text = @"";
        }
    }
}

- (void)resignPicker
{
    if (toolbar.tag == 1)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd-MMM-yyyy"];
        //[df setDateFormat:@"MMM-yyyy"];
        NSString *datefrom_string = @"   ";
        datefrom_string = [datefrom_string stringByAppendingString:[NSString stringWithFormat:@"%@",[df stringFromDate:[datefrom_picker date]]]];
        
        //[datefrom_button setTitle:[df stringFromDate:[datefrom_picker date]] forState:UIControlStateNormal];
        [datefrom_button setTitle:datefrom_string forState:UIControlStateNormal];
        //datefrom_picker.hidden = YES;
        // [datefrom_picker removeFromSuperview];
        
    }
    else if (toolbar.tag == 2)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd-MMM-yyyy"];
        NSString *dateto_string = @"   ";
        dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[df stringFromDate:[dateto_picker date]]]];
        [dateto_button setTitle:dateto_string forState:UIControlStateNormal];
        //[df setDateFormat:@"MMM-yyyy"];
        //[dateto_button setTitle:[df stringFromDate:[dateto_picker date]] forState:UIControlStateNormal];
        //dateto_picker.hidden = YES;
        //[dateto_picker removeFromSuperview];
    }
    toolbar.hidden = YES;
    toolbar1.hidden = YES;
    dateto_picker.hidden = YES;
    datefrom_picker.hidden = YES;
    //[toolbar removeFromSuperview];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"MY VIEW DID LOAD");
    
    // To create datepickers
    dateto_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(156,90,250,150)];
    dateto_picker.datePickerMode = UIDatePickerModeDate;
    dateto_picker.date = [NSDate date];
    [dateto_picker addTarget:self action:@selector(ChangeDateToLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dateto_picker];
    dateto_picker.hidden = YES;
    dateto_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    datefrom_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10,90,250,150)];
    datefrom_picker.datePickerMode = UIDatePickerModeDate;
    datefrom_picker.date = [NSDate date];
    [datefrom_picker addTarget:self action:@selector(ChangeDateFromLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datefrom_picker];
    datefrom_picker.hidden = YES;
    datefrom_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    // To Hide Load More indicator
    indicator.hidden = YES;
    
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    returnsample_array = [[NSMutableArray alloc]init];
    
    self.returnsample_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    [self SampleReturnService];
    
    
    CGRect frame = datefrom_button.frame;
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 250, 44)];
    toolbar.barStyle=UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    [barItems addObject:doneButton];
    [toolbar setItems:barItems];
    toolbar.tag = 1;
    [self.view addSubview:toolbar];
    toolbar.hidden = YES;
    
    frame = toolbar.frame;
    
    
    CGRect frame_dateto = dateto_button.frame;
    toolbar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(frame_dateto.origin.x, frame_dateto.origin.y+frame_dateto.size.height, 250, 44)];
    toolbar1.barStyle=UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton_dateto = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems2 addObject:flexSpace2];
    
    [doneButton_dateto setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                               nil]
                                     forState:UIControlStateNormal];
    [barItems2 addObject:doneButton_dateto];
    [toolbar1 setItems:barItems2];
    
    toolbar1.tag = 2;
    [self.view addSubview:toolbar1];
    toolbar1.hidden = YES;
    
    frame_dateto = toolbar1.frame;
}

#pragma Table view delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return returnsample_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"samplereturn_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[returnsample_array objectAtIndex:indexPath.row];
    
    sno=(UILabel *)[cell viewWithTag:1];
    NSString *sno_string = [NSString stringWithFormat:@"%d",(returnsample_array.count + 1) - (indexPath.row+1)];
    sno_string = [sno_string stringByAppendingString:@"."];
    sno.text = sno_string;
    
    product_name =(UILabel *)[cell viewWithTag:2];
    product_name.text = [itemAtIndex objectForKey:@"SampleName"];
    
    batch_no =(UILabel *)[cell viewWithTag:3];
    batch_no.text = [itemAtIndex objectForKey:@"BatchNo"];
    
    exp_date =(UILabel *)[cell viewWithTag:4];
    exp_date.text = [itemAtIndex objectForKey:@"ExpiryDate"];
    
    return_qty =(UILabel *)[cell viewWithTag:5];
    return_qty.text = [itemAtIndex objectForKey:@"ReturnedQuantity"];
    
    return_date =(UILabel *)[cell viewWithTag:6];
    return_date.text = [itemAtIndex objectForKey:@"ReturnDate"];
    
    issued_date =(UILabel *)[cell viewWithTag:7];
    issued_date.text = [itemAtIndex objectForKey:@"IssueMonth"];
    
    
    returnsample_status =(UILabel *)[cell viewWithTag:9];
    
    status_button=(UIButton *)[cell viewWithTag:8];
    
    
    
    [status_button addTarget:self action:@selector(EditReturnSampleRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        status_button.hidden = YES;
        if([[itemAtIndex objectForKey:@"IsAccepted"] isEqualToString:@"true"] )
        {
            returnsample_status.hidden = NO;
        }
        else
        {
            returnsample_status.hidden = YES;
            
        }
    }
    else
    {
        if([[itemAtIndex objectForKey:@"IsAccepted"] isEqualToString:@"true"] )
        {
            status_button.hidden = YES;
            returnsample_status.hidden = NO;
        }
        else
        {
            status_button.hidden = NO;
            returnsample_status.hidden = YES;
            
        }
    }
    
    
    
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
    
    
    return cell;
}


- (void)EditReturnSampleRequest:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadWholeView:) name:@"didappear" object:nil];
    //NSIndexPath *indexPath =[returnsample_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:returnsample_table];
    NSIndexPath *indexPath = [returnsample_table indexPathForRowAtPoint:rootViewPoint];
    
    NSDictionary *itemAtIndex = (NSDictionary *)[returnsample_array objectAtIndex:indexPath.row];
    
    NSLog(@" CHECK SAMPLE ID %@",[itemAtIndex objectForKey:@"SampleId"]);
    
    RKPharmaAppDelegate *AppDel = (RKPharmaAppDelegate *)[UIApplication sharedApplication].delegate;
    AppDel.SampleId = [itemAtIndex objectForKey:@"SampleId"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    editreturnsample = [storyboard instantiateViewControllerWithIdentifier:@"edit_return_sample"];
    editreturnsample.view.tag=990;
    editreturnsample.view.frame=CGRectMake(0,0, 841, 784);
    [editreturnsample.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [editreturnsample.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    
    [self.view addSubview:editreturnsample.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Edit Sample Return",@"heading", nil]];
}

- (void)ReloadWholeView: (NSNotification *)notification
{
    [self viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadWholeView:) name:@"didappear" object:nil];
    NSUInteger row = indexPath.row;
    NSDictionary *itemAtIndex = (NSDictionary *)[returnsample_array objectAtIndex:row];
    
    RKPharmaAppDelegate *AppDel = (RKPharmaAppDelegate *)[UIApplication sharedApplication].delegate;
    AppDel.SampleId = [itemAtIndex objectForKey:@"SampleId"];
    
    NSLog(@" SAMPLE ID %@",[itemAtIndex objectForKey:@"SampleId"]);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    viewreturnsample = [storyboard instantiateViewControllerWithIdentifier:@"view_sample_return"];
    viewreturnsample.view.tag=990;
    viewreturnsample.view.frame=CGRectMake(0,0, 841, 784);
    [viewreturnsample.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [viewreturnsample.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    
    [self.view addSubview:viewreturnsample.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"View Sample Return",@"heading", nil]];
}

-(IBAction)ResetSampleRequest
{
    datefrom_picker.hidden = YES;
    dateto_picker.hidden = YES;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       // To Fetch Month Last Date
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
                       
                       
                       returnsampledatetostring_selected = @"";
                       returnsampledatefromstring_selected = @"";
                       
                       [returnsample_array removeAllObjects];
                       [datefrom_button setTitle:@"  Date From" forState:UIControlStateNormal];
                       [dateto_button setTitle:@"  Date To" forState:UIControlStateNormal];
                       
                       [datefrom_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [dateto_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       
                       [self SampleReturnService];
                       
                       [self removeActivityView];
                   });
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)SearchSampleRequest
{
    datefrom_picker.hidden = YES;
    dateto_picker.hidden = YES;
    toolbar1.hidden = YES;
    toolbar.hidden = YES;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [returnsample_array removeAllObjects];
                       [self SampleReturnService];
                       [self removeActivityView];
                   });
}

//-(IBAction)GetDateFrom
//{
//    dateto_picker.hidden = YES;
//    if([datefrom_picker isHidden])
//    {
//        datefrom_picker.hidden=NO;
//        toolbar.hidden = NO;
//    }
//    else
//    {
//        datefrom_picker.hidden=YES;
//        toolbar.hidden = YES;
//    }
//    toolbar.hidden = NO;
//    toolbar1.hidden = YES;
//}
//
//-(IBAction)GetDateTo
//{
//    datefrom_picker.hidden = YES;
//
//    if([dateto_picker isHidden])
//    {
//        dateto_picker.hidden=NO;
//    }
//    else
//    {
//        dateto_picker.hidden=YES;
//    }
//    toolbar1.hidden = NO;
//    toolbar.hidden = YES;
//}

-(IBAction)GetDateFrom
{
    dateto_picker.hidden = YES;
    toolbar1.hidden = YES;
    if([datefrom_picker isHidden])
    {
        datefrom_picker.hidden=NO;
        toolbar.hidden = NO;
    }
    else
    {
        datefrom_picker.hidden=YES;
        toolbar.hidden = YES;
    }
}

-(IBAction)GetDateTo
{
    datefrom_picker.hidden = YES;
    toolbar.hidden = YES;
    
    if([dateto_picker isHidden])
    {
        dateto_picker.hidden=NO;
        toolbar1.hidden = NO;
    }
    else
    {
        dateto_picker.hidden=YES;
        toolbar1.hidden = YES;
    }
    
    
}

- (IBAction)Back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Samples",@"heading", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
