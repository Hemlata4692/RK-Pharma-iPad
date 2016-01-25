//
//  SampleRequestListViewController.m
//  RKPharma
//
//  Created by Shivendra on 25/07/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "SampleRequestListViewController.h"
#import "JSON.h"
#import "Product.h"
#import "DejalActivityView.h"
#import "ProductManager.h"
#import "UserManager.h"
#import "ClinicManager.h"
#import "AddSample.h"
#import "LoginViewController.h"
#import "ReturnSample.h"
#import "ReturnSampleList.h"

NSString *sampleproductid_selected = @"";
NSString *sampledatetostring_selected = @"";
NSString *sampledatefromstring_selected = @"";
@interface SampleRequestListViewController ()

@end

@implementation SampleRequestListViewController
@synthesize sample_table,product_button,product_picker,datefrom_button,datefrom_picker,dateto_button,dateto_picker,indicator,status_button,error_label,remarks,requested_date,product_name,issued_quantity,sample_status,sno,requestsample_button,returnsample_button;
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
    NSString *dateto_string = @"   ";
    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:dateto_picker.date]]];
    [dateto_button setTitle:dateto_string forState:UIControlStateNormal];
    sampledatetostring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:dateto_picker.date]];
    [dateto_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}

-(IBAction)ChangeDateFromLabel:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *datefrom_string = @"   ";
    datefrom_string = [datefrom_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:datefrom_picker.date]]];
    [datefrom_button setTitle:datefrom_string forState:UIControlStateNormal];
    sampledatefromstring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:datefrom_picker.date]];
    [datefrom_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}

- (void)pickerViewTapGestureRecognizedproductpicker:(UITapGestureRecognizer*)gestureRecognizerproductpicker
{
    product_picker.hidden = YES;
    CGPoint touchPoint = [gestureRecognizerproductpicker locationInView:gestureRecognizerproductpicker.view.superview];
    
    CGRect frame = product_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, product_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}


-(IBAction)SampleRequestService
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
    
    if(![[NSString stringWithFormat:@"%@",sampledatefromstring_selected] isEqualToString:@""] || ![[NSString stringWithFormat:@"%@",sampledatetostring_selected] isEqualToString:@""])
    {
        NSLog(@" If Con");
        product.datefrom_string = sampledatefromstring_selected;
        product.dateto_string = sampledatetostring_selected;
    }
    else
    {
        NSLog(@" Else Con");
        product.datefrom_string = [NSString stringWithFormat:@"01-%@-%d",date_month,year];
        product.dateto_string = [df stringFromDate:tDateMonth];
    }
    
    
    
    //Create business manager class object
    ProductManager *pm_business=[[ProductManager alloc]init];
    NSString *response=[pm_business GetSampleRequestList:product];//call businessmanager login method and handle response
    NSLog(@" Sample Request List response is %@",response);
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Sample Request List%@",var);
        
        
        for(NSDictionary *dictvar in var)
        {
            [sample_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"RequestNumber"],@"RequestNumber",[dictvar objectForKey:@"RequestedDate"],@"RequestedDate",[dictvar objectForKey:@"SalesPerson"],@"SalesPerson",[dictvar objectForKey:@"RequestedQuantity"],@"RequestedQuantity",[dictvar objectForKey:@"ProductCount"],@"ProductCount",[dictvar objectForKey:@"PrductName"],@"PrductName",[dictvar objectForKey:@"IssuedQuantity"],@"IssuedQuantity",[dictvar objectForKey:@"Issued"],@"Issued",[dictvar objectForKey:@"Remarks"],@"Remarks",nil]];
            
        }
       [sample_table reloadData];
        // Do any additional setup after loading the view.
        
        
        if(sample_array.count == 0)
        {
            self.sample_table.frame = CGRectMake(10,86,821,0);
        }
        else if(sample_array.count == 1)
        {
            self.sample_table.frame = CGRectMake(10,86,821,100);
        }
        else if(sample_array.count == 2)
        {
            self.sample_table.frame = CGRectMake(10,86,821,200);
        }
        else if(sample_array.count == 3)
        {
            self.sample_table.frame = CGRectMake(10,86,821,300);
        }
        else if(sample_array.count == 4)
        {
            self.sample_table.frame = CGRectMake(10,86,821,400);
        }
        else if(sample_array.count == 5)
        {
            self.sample_table.frame = CGRectMake(10,86,821,500);
        }
        else if(sample_array.count >= 6)
        {
            self.sample_table.frame = CGRectMake(10,86,821,600);
        }
        
        if(sample_array.count == 0)
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
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"in sample viewdidappear");
}
- (void)ReloadWholeView: (NSNotification *)notification
{
    [self viewDidLoad];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        requestsample_button.hidden = YES;
        returnsample_button.hidden = YES;
    }
    else
    {
        requestsample_button.hidden = NO;
        returnsample_button.hidden = NO;
    }

    
    sampleproductid_selected = @"";
    
    product_array = [[NSMutableArray alloc] init];
    
    
    // To Show Product Picker
    product_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(173,45,300,100)];
    
        
    // To Show Product Picker View
    UITapGestureRecognizer *gestureRecognizerproductpicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognizedproductpicker:)];
    gestureRecognizerproductpicker.cancelsTouchesInView = NO;
    
    // To Show Product Picker
    [product_picker addGestureRecognizer:gestureRecognizerproductpicker];
    [self.view addSubview:product_picker];
    
    [product_picker setDelegate:self];
    [product_picker setDataSource:self];
    product_picker.hidden=YES;
    product_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    
    
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
    
    sample_array = [[NSMutableArray alloc]init];
    
    self.sample_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    [self SampleRequestService];
    
    
    CGRect frame = datefrom_button.frame;
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 250, 44)];
    toolbar.barStyle=UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                       nil]
 forState:UIControlStateNormal];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
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
    [doneButton_dateto setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                               nil]
                                     forState:UIControlStateNormal];
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems2 addObject:flexSpace2];
    [barItems2 addObject:doneButton_dateto];
    [toolbar1 setItems:barItems2];
    toolbar1.tag = 2;
    [self.view addSubview:toolbar1];
    toolbar1.hidden = YES;
    
    frame_dateto = toolbar1.frame;
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
        
        [datefrom_button setTitle:datefrom_string forState:UIControlStateNormal];
        
    }
    else if (toolbar.tag == 2)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd-MMM-yyyy"];
        NSString *dateto_string = @"   ";
        dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[df stringFromDate:[dateto_picker date]]]];
        [dateto_button setTitle:dateto_string forState:UIControlStateNormal];
    }
    toolbar.hidden = YES;
    toolbar1.hidden = YES;
    dateto_picker.hidden = YES;
    datefrom_picker.hidden = YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    dateto_picker.hidden = YES;
    datefrom_picker.hidden = YES;
    toolbar.hidden = YES;
    toolbar1.hidden = YES;
    [super touchesBegan:touches withEvent:event];
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
    return sample_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"samplerequest_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[sample_array objectAtIndex:indexPath.row];
    
    sno=(UILabel *)[cell viewWithTag:1];
    NSString *sno_string = [NSString stringWithFormat:@"%d",(sample_array.count + 1) - (indexPath.row+1)];
    sno_string = [sno_string stringByAppendingString:@"."];
    sno.text = sno_string;
    
    requested_date =(UILabel *)[cell viewWithTag:3];
    requested_date.text = [itemAtIndex objectForKey:@"RequestDate"];
    requested_date.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];

    issued_quantity=(UILabel *)[cell viewWithTag:4];
    issued_quantity.text = [itemAtIndex objectForKey:@"IssuedQuantity"];
    issued_quantity.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    remarks=(UILabel *)[cell viewWithTag:6];
    remarks.text = [itemAtIndex objectForKey:@"Remarks"];
    
    product_name=(UILabel *)[cell viewWithTag:2];
    
    if([[itemAtIndex objectForKey:@"ProductCount"]integerValue] > 0)
    {
        product_name.text = [NSString stringWithFormat:@"%@ + %d",[itemAtIndex objectForKey:@"PrductName"],[[itemAtIndex objectForKey:@"ProductCount"]integerValue] ];
    }
    else
    {
        product_name.text = [itemAtIndex objectForKey:@"PrductName"];
    }
    
    product_name.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    sample_status=(UILabel *)[cell viewWithTag:5];
    sample_status.textColor= [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    
    
    status_button=(UIButton *)[cell viewWithTag:7];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        status_button.hidden = YES;
        if([[itemAtIndex objectForKey:@"Issued"]integerValue] == 1)
        {
            sample_status.hidden = NO;
            sample_status.text = @"ISSUED";
        }
        else
        {
            sample_status.hidden = YES;
            
        }
    }
    else
    {
        
        if([[itemAtIndex objectForKey:@"Issued"]integerValue] == 1)
        {
            sample_status.hidden = NO;
            status_button.hidden = YES;
            sample_status.text = @"ISSUED";
        }
        else
        {
            sample_status.hidden = YES;
            status_button.hidden = NO;
            
        }
        [status_button addTarget:self action:@selector(EditSampleRequest:) forControlEvents:UIControlEventTouchUpInside];
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
- (IBAction)EditSampleRequest:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadWholeView:) name:@"didappear" object:nil];
    //NSIndexPath *indexPath =[sample_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:sample_table];
    NSIndexPath *indexPath = [sample_table indexPathForRowAtPoint:rootViewPoint];
    
    NSUInteger row = indexPath.row;
    NSDictionary *itemAtIndex = (NSDictionary *)[sample_array objectAtIndex:row];
    
    RKPharmaAppDelegate *AppDel = (RKPharmaAppDelegate *)[UIApplication sharedApplication].delegate;
    AppDel.SampleDictionary = itemAtIndex;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    editSample = [storyboard instantiateViewControllerWithIdentifier:@"editsample"];
    editSample.view.tag=990;
    editSample.view.frame=CGRectMake(0,0, 841, 784);
    [editSample.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [editSample.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    
    [self.view addSubview:editSample.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Edit Sample",@"heading", nil]];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadWholeView:) name:@"didappear" object:nil];
    NSUInteger row = indexPath.row;
    NSDictionary *itemAtIndex = (NSDictionary *)[sample_array objectAtIndex:row];

    RKPharmaAppDelegate *AppDel = (RKPharmaAppDelegate *)[UIApplication sharedApplication].delegate;
    AppDel.SampleDictionary = itemAtIndex;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    editSample = [storyboard instantiateViewControllerWithIdentifier:@"viewsample"];
    editSample.view.tag=990;
    editSample.view.frame=CGRectMake(0,0, 841, 784);
    [editSample.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [editSample.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
    [UIView commitAnimations];


    [self.view addSubview:editSample.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"View Sample",@"heading", nil]];
}

#pragma Picker View Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Here we are setting the number of rows in the pickerview to the number of objects of the NSArray. You should understand this since we covered it in the tableview tutorial.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return product_array.count;
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
            CGRect frame = CGRectMake(20.0, 0.0, 250, 150);
            
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            //here you can play with fonts
            [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        
        
    }
    
    
    
        NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:row];
        
        //picker view array is the datasource
        [pickerLabel setText:[itemAtIndex objectForKey:@"ProductName"]];
    
    
    return pickerLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
        NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:row];
        sampleproductid_selected=[itemAtIndex objectForKey:@"ProductId"];
        
        NSString *product_namestring = @"   ";
        product_namestring = [product_namestring stringByAppendingString:[itemAtIndex objectForKey:@"ProductName"]];
        [product_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        [product_button setTitle:[itemAtIndex objectForKey:@"ProductName"] forState:UIControlStateNormal];
        product_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        product_picker.showsSelectionIndicator = YES;
        product_picker.hidden= NO;
    
}

-(IBAction)Get_Product
{
    datefrom_picker.hidden = YES;
    dateto_picker.hidden = YES;
    if([product_picker isHidden])
    {
        product_picker.hidden=NO;
    }
    else
    {
        product_picker.hidden=YES;
    }
}


- (IBAction)AddSample:(id)sender
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadWholeView:) name:@"didappear" object:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    addsample = [storyboard instantiateViewControllerWithIdentifier:@"addsample"];
    addsample.view.tag=990;
    addsample.view.frame=CGRectMake(0,0, 841, 784);
    [addsample.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [addsample.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    
    [self.view addSubview:addsample.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Add Sample",@"heading", nil]];
}

- (IBAction)ReturnSample:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadWholeView:) name:@"didappear" object:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    returnsample = [storyboard instantiateViewControllerWithIdentifier:@"returnsample"];
    returnsample.view.tag=990;
    returnsample.view.frame=CGRectMake(0,0, 841, 784);
    [returnsample.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [returnsample.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    
    [self.view addSubview:returnsample.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Return Sample",@"heading", nil]];
}

- (IBAction)ReturnSampleList:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadWholeView:) name:@"didappear" object:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    returnsamplelist = [storyboard instantiateViewControllerWithIdentifier:@"returnsample_list"];
    returnsamplelist.view.tag=990;
    returnsamplelist.view.frame=CGRectMake(0,0, 841, 784);
    [returnsamplelist.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [returnsamplelist.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    [self.view addSubview:returnsamplelist.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Return Sample List",@"heading", nil]];
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
        
        
        sampledatetostring_selected = @"";
        sampledatefromstring_selected = @"";
        
        [sample_array removeAllObjects];
        [datefrom_button setTitle:@"  Date From" forState:UIControlStateNormal];
        [dateto_button setTitle:@"  Date To" forState:UIControlStateNormal];
        
        [datefrom_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
        [dateto_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
        
        [self SampleRequestService];
        
        [self removeActivityView];
    });
}

-(IBAction)SearchSampleRequest
{
    datefrom_picker.hidden = YES;
    dateto_picker.hidden = YES;
    product_picker.hidden = YES;
    toolbar.hidden = YES;
    toolbar1.hidden =YES;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [sample_array removeAllObjects];
        [self SampleRequestService];
        [self removeActivityView];
    });
}

-(IBAction)GetDateFrom
{
    dateto_picker.hidden = YES;
    product_picker.hidden = YES;
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
    product_picker.hidden = YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
