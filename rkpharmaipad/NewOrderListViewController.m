//
//  NewOrderListViewController.m
//  RKPharma
//
//  Created by Shivendra on 25/07/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "NewOrderListViewController.h"
#import "JSON.h"
#import "Order.h"
#import "OrderManager.h"
#import "DejalActivityView.h"
#import "ProductManager.h"
#import "UserManager.h"
#import "ClinicManager.h"
#import "LeftSidebarViewController.h"
#import "AddOrderViewController.h"
NSString *newdatetostring_selected = @"";
NSString *newdatefromstring_selected = @"";
NSString *neworderlocationid_selected = @"";
NSString *neworderproductid_selected = @"";

NSString *neworderspecializationid_selected = @"";

int neworderoffset = 0;
float newtotal = 0.0;

@interface NewOrderListViewController ()
{
    NSMutableArray *Order_List_Array;
    NSMutableData *responseData;
}
@end

@implementation NewOrderListViewController
@synthesize order_table,clinic_name,product_name,order_quantity,order_date,invoice_no,bonus,unofficial_bonus,status,dateto_picker,datefrom_picker,dateto_button,datefrom_button,product_button,location_button,location_picker,error_label,product_picker,remarks,specialization_button,specialization_picker,indicator,gtotal,totalamount,totalamountlabel,gtotallabel,sno,pdfView,addorder_button;
@synthesize  location_picker_toolbar,product_picker_toolbar,specialization_picker_toolbar,datefrom_picker_toolbar,dateto_picker_toolbar;
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


- (void)removeActivityView
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

- (void)pickerViewTapGestureRecognizedproductpicker:(UITapGestureRecognizer*)gestureRecognizerproductpicker
{
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    CGPoint touchPoint = [gestureRecognizerproductpicker locationInView:gestureRecognizerproductpicker.view.superview];
    
    CGRect frame = product_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, product_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}

- (void)pickerViewTapGestureRecognizedspecializationpicker:(UITapGestureRecognizer*)gestureRecognizerspecializationpicker
{
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    CGPoint touchPoint = [gestureRecognizerspecializationpicker locationInView:gestureRecognizerspecializationpicker.view.superview];
    
    CGRect frame = specialization_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, specialization_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}

-(void)dismissKeyboard
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
}

- (NSString *)GetLastDay
{
    NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:curDate]; // Get necessary date components
    
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *tDateMonth = [calendar dateFromComponents:comps];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MMM-yyyy"];
    return [df stringFromDate:tDateMonth];
}
- (NSString *)getFirstDay
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MMM-yyyy"];
    return [df stringFromDate:firstDayOfMonthDate];
}
-(IBAction)add_order:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@""  forKey:@"OrderId"];
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       NSString *top_usernamelabel = @"Welcome, ";
                       top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
                       
                       LeftSidebarViewController *lftsbr=[[LeftSidebarViewController alloc]init];
                       lftsbr.topheading_label.text = top_usernamelabel;
                       
                       
                       //lftsbr.topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
                       lftsbr.topheading_label.text = @"Add Order";
                       
                       
                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                       addordercontroller = [storyboard instantiateViewControllerWithIdentifier:@"addorder_screen"];
                       addordercontroller.view.tag=990;
                       addordercontroller.view.frame=CGRectMake(0,0, 841, 784);
                       addordercontroller.areaArray=location_array;
                       addordercontroller.specializationArray=specialization_array;
                       addordercontroller.productArray=[product_array mutableCopy];
                       //    Added by rohit modi
                       // mentain last and new product array in add/edit order
                       addordercontroller.latestProductArray=[product_array mutableCopy];
                       addordercontroller.oldProductArray=[product_array mutableCopy];
                       //    end
                       [addordercontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [addordercontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       
                       [self.view addSubview:addordercontroller.view];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Add Order",@"heading", nil]];
                       [self removeActivityView];
                   });
}
-(IBAction)OrderService
{
    
    NSString *offsetstring = [NSString stringWithFormat:@"%d",neworderoffset];
    
    NSMutableDictionary *JsonObject = [NSMutableDictionary new];
    [JsonObject setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] forKey:@"userid"];
    [JsonObject setObject:neworderlocationid_selected forKey:@"locationid"];
    [JsonObject setObject:neworderproductid_selected forKey:@"productid"];
    [JsonObject setObject:newdatefromstring_selected forKey:@"datefrom"];
    [JsonObject setObject:newdatetostring_selected forKey:@"dateto"];
    [JsonObject setObject:neworderspecializationid_selected forKey:@"specialization"];
    [JsonObject setObject:offsetstring forKey:@"offset"];
    //Create business manager class object
    NSLog(@"jsonrequest %@",JsonObject);
    ProductManager *pm_business=[[ProductManager alloc]init];
    NSString *response=[pm_business GetNewProductLists:JsonObject];//call businessmanager login method and handle response
    NSLog(@" Product List response is %@",response);
    
    NSDictionary *var =  [response JSONValue];
    NSLog(@"dict Order List%@",var);
    
    for(NSDictionary *dictvar in var)
    {
        [Order_List_Array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"BonusQuantity"],@"BonusQuantity",[dictvar objectForKey:@"ClinicName"],@"ClinicName",[dictvar objectForKey:@"DoctorName"],@"DoctorName",[dictvar objectForKey:@"InvoiceDate"],@"InvoiceDate",[dictvar objectForKey:@"InvoiceGenerated"],@"InvoiceGenerated",[dictvar objectForKey:@"InvoiceNo"],@"InvoiceNo",[dictvar objectForKey:@"IsCanceled"],@"IsCanceled",[dictvar objectForKey:@"IsNet"],@"IsNet",[dictvar objectForKey:@"OrderDate"],@"OrderDate",[dictvar objectForKey:@"OrderPrice"],@"OrderPrice",[dictvar objectForKey:@"ProductCount"],@"ProductCount",[dictvar objectForKey:@"ProductName"],@"ProductName",[dictvar objectForKey:@"Status"],@"Status",[dictvar objectForKey:@"UnofficialBonus"],@"UnofficialBonus",[dictvar objectForKey:@"Remark"],@"Remark",[dictvar objectForKey:@"RowNumner"],@"RowNumner",[dictvar objectForKey:@"Quantity"],@"Quantity",[dictvar objectForKey:@"OrderId"],@"OrderId",nil]];
        
    }
    
    if (response.length !=0)
    {
        //Order_List_Array =  [response JSONValue];
        NSLog(@" COUNT ARRAY %d",Order_List_Array.count);
        if(Order_List_Array.count == 0)
        {
            self.order_table.frame = CGRectMake(10,86,821,0);
        }
        else if(Order_List_Array.count == 1)
        {
            self.order_table.frame = CGRectMake(10,86,821,100);
        }
        else if(Order_List_Array.count == 2)
        {
            self.order_table.frame = CGRectMake(10,86,821,200);
        }
        else if(Order_List_Array.count == 3)
        {
            self.order_table.frame = CGRectMake(10,86,821,300);
        }
        else if(Order_List_Array.count == 4)
        {
            self.order_table.frame = CGRectMake(10,86,821,400);
        }
        else if(Order_List_Array.count == 5)
        {
            self.order_table.frame = CGRectMake(10,86,821,500);
        }
        else if(Order_List_Array.count >= 6)
        {
            self.order_table.frame = CGRectMake(10,86,821,600);
        }
        
        [order_table reloadData];
    }
    else{
        error_label.hidden=NO;
    }
}

-(IBAction)getOrderTotal
{
    NSLog(@" Check Location Id%@",neworderlocationid_selected);
    NSMutableDictionary *JsonObject = [NSMutableDictionary new];
    [JsonObject setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] forKey:@"userid"];
    [JsonObject setObject:neworderlocationid_selected forKey:@"locationid"];
    [JsonObject setObject:neworderproductid_selected forKey:@"productid"];
    [JsonObject setObject:newdatefromstring_selected forKey:@"datefrom"];
    [JsonObject setObject:newdatetostring_selected forKey:@"dateto"];
    [JsonObject setObject:neworderspecializationid_selected forKey:@"specialization"];
    //Create business manager class object
    NSLog(@"jsonobject %@",JsonObject);
    OrderManager *orderManager=[[OrderManager alloc]init];
    NSString *response=[orderManager GetOrderGtotal:JsonObject];//call businessmanager login method and handle response
    NSMutableArray *array=[[NSMutableArray alloc]init];
    array=[response JSONValue];
    if([[array valueForKey:@"Total"] isEqualToString:@""])
    {
        gtotal.text=@"0.0";
        //error_label.hidden=NO;
    }
    else{
        gtotal.text=[array valueForKey:@"Total"];
        //error_label.hidden=YES;
    }NSLog(@" Order List response is %@",response);
    
}

-(IBAction)SpecializationService
{
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    // To Get Location
    NSString *response=[cm_business GetSpecialization];//call businessmanager Location method and handle response
    
    
    NSDictionary *var =  [response JSONValue];
    NSLog(@"dict Specialization List%@",var);
    
    [specialization_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Id",@"All",@"Specialization",nil]];
    for(NSDictionary *dictvar in var)
    {
        [specialization_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Id"],@"Id",[dictvar objectForKey:@"Specialization"],@"Specialization",nil]];
        
    }
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
    newdatetostring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:dateto_picker.date]];
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
    newdatefromstring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:datefrom_picker.date]];
    [datefrom_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}
-(IBAction)closePDF:(id)sender
{
    pdfView.hidden=YES;
    close_Button.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        addorder_button.hidden = YES;
    }
    else
    {
        addorder_button.hidden = NO;
    }
    
    responseData=[NSMutableData data];
    pdfView.hidden=YES;
    close_Button.hidden=YES;
    pdfView.scalesPageToFit=YES;
    neworderlocationid_selected = @"0";
    neworderproductid_selected = @"0";
    newdatetostring_selected = [self GetLastDay];
    newdatefromstring_selected = [self getFirstDay];
    neworderspecializationid_selected = @"0";
    neworderoffset = 0;
    newtotal = 0.0;
    
    location_array = [[NSMutableArray alloc] init];
    product_array = [[NSMutableArray alloc] init];
    specialization_array = [[NSMutableArray alloc] init];
    Order_List_Array = [[NSMutableArray alloc] init];
    // To Show Location Picker
    location_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(10,75+14,200,100)];
    
    product_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(162,75+14,300,100)];
    
    // To Show Location Picker
    specialization_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(313,75+14,200,100)];
    
    // To Show Location Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [location_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:location_picker];
    
    [location_picker setDelegate:self];
    [location_picker setDataSource:self];
    location_picker.hidden=YES;
    location_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    location_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(location_picker.frame.origin.x, 45,location_picker.frame.size.width,30+14)];
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
    /**********************/
    location_picker_toolbar.hidden = YES;
    
    // To Show specialization Picker View
    UITapGestureRecognizer *gestureRecognizerspecializationpicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognizedspecializationpicker:)];
    gestureRecognizerspecializationpicker.cancelsTouchesInView = NO;
    
    // To Show Specialization Picker View
    
    [specialization_picker addGestureRecognizer:gestureRecognizerspecializationpicker];
    [self.view addSubview:specialization_picker];
    
    [specialization_picker setDelegate:self];
    [specialization_picker setDataSource:self];
    specialization_picker.hidden=YES;
    
    specialization_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    
    
    specialization_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(specialization_picker.frame.origin.x, 45,specialization_picker.frame.size.width,30+14)];
    /************** toolbar custmzation *************/
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems2 addObject:flexSpace2];
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn2.tag = 2;
    [doneBtn2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems2 addObject:doneBtn2];
    [specialization_picker_toolbar setItems:barItems2 animated:YES];
    specialization_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:specialization_picker_toolbar];
    /**********************/
    specialization_picker_toolbar.hidden  = YES;
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
    
    product_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(product_picker.frame.origin.x, 45,product_picker.frame.size.width,30+14)];
    //[location_picker_toolbar sizeToFit];
    product_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems3 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems3 addObject:flexSpace3];
    
    UIBarButtonItem *doneBtn3 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn3.tag = 3;
    [doneBtn3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems3 addObject:doneBtn3];
    [product_picker_toolbar setItems:barItems3 animated:YES];
    [self.view addSubview:product_picker_toolbar];
    /**********************/
    product_picker_toolbar.hidden = YES;
    
    // To create datepickers
    dateto_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(594,75+14,250,150)];
    dateto_picker.datePickerMode = UIDatePickerModeDate;
    dateto_picker.date = [NSDate date];
    [dateto_picker addTarget:self action:@selector(ChangeDateToLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dateto_picker];
    dateto_picker.hidden = YES;
    dateto_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    dateto_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(dateto_picker.frame.origin.x, 45,dateto_picker.frame.size.width,30+14)];
    //[location_picker_toolbar sizeToFit];
    dateto_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
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
    [dateto_picker_toolbar setItems:barItems4 animated:YES];
    [self.view addSubview:dateto_picker_toolbar];
    /**********************/
    dateto_picker_toolbar.hidden = YES;
    
    datefrom_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(464,75+14,250,150)];
    datefrom_picker.datePickerMode = UIDatePickerModeDate;
    datefrom_picker.date = [NSDate date];
    [datefrom_picker addTarget:self action:@selector(ChangeDateFromLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datefrom_picker];
    datefrom_picker.hidden = YES;
    datefrom_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    datefrom_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(datefrom_picker.frame.origin.x, 45,dateto_picker.frame.size.width,30+14)];
    //[location_picker_toolbar sizeToFit];
    datefrom_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems5 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems5 addObject:flexSpace5];
    
    UIBarButtonItem *doneBtn5 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn5.tag = 5;
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
    
    // To Hide Load More indicator
    indicator.hidden = YES;
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    order_array = [[NSMutableArray alloc]init];
    
    self.order_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    [self OrderService];
    [self getOrderTotal];
    
    //Create business manager class object
    ProductManager *pm_business=[[ProductManager alloc]init];
    NSString *response=[pm_business GetProductList];//call businessmanager login method and handle response
    NSLog(@" Product List response is %@",response);
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Product List%@",var);
        
        [product_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ProductId",@"All",@"ProductName",nil]];
        for(NSDictionary *product_dictvar in var)
        {
            [product_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"ProductId"],@"ProductId",[product_dictvar objectForKey:@"ProductName"],@"ProductName",nil]];
            
        }
        
        //Create business manager class object
        UserManager *um_business=[[UserManager alloc]init];
        // To Get Location
        NSString *location_response=[um_business GeLocationList];//call businessmanager Location method and handle response
        
        
        NSDictionary *location_var =  [location_response JSONValue];
        NSLog(@"dict Location List%@",location_var);
        
        [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"LocationId",@"All",@"LocationName",nil]];
        for(NSDictionary *location_dictvar in location_var)
        {
            [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[location_dictvar objectForKey:@"LocationId"],@"LocationId",[location_dictvar objectForKey:@"LocationName"],@"LocationName",nil]];
            
        }
        
        [self SpecializationService];
    }
    // [self OrderService];
    /*
     [product_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ProductId",@"All",@"ProductName",nil]];
     for(NSDictionary *product_dictvar in var)
     {
     [product_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"ProductId"],@"ProductId",[product_dictvar objectForKey:@"ProductName"],@"ProductName",nil]];
     
     }
     
     //Create business manager class object
     UserManager *um_business=[[UserManager alloc]init];
     // To Get Location
     NSString *location_response=[um_business GeLocationList];//call businessmanager Location method and handle response
     
     NSDictionary *location_var =  [location_response JSONValue];
     NSLog(@"dict Location List%@",location_var);
     
     [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"LocationId",@"All",@"LocationName",nil]];
     for(NSDictionary *location_dictvar in location_var)
     {
     [location_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[location_dictvar objectForKey:@"LocationId"],@"LocationId",[location_dictvar objectForKey:@"LocationName"],@"LocationName",nil]];
     
     }
     
     [self SpecializationService];
     */
    
    
    
}
-(IBAction)done_clicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag ==1)
    {
        location_picker.hidden=YES;
        location_picker_toolbar.hidden = YES;
    }
    else if(btn.tag ==2)
    {
        specialization_picker.hidden=YES;
        specialization_picker_toolbar.hidden = YES;
    }
    else if(btn.tag ==3)
    {
        product_picker.hidden=YES;
        product_picker_toolbar.hidden = YES;
    }
    else if(btn.tag ==4)
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
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    pdfView.hidden=YES;
    close_Button.hidden=YES;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height)
    {
        NSLog(@"Order Offset ");
        NSLog(@"List Count %d",Order_List_Array.count);
        if(Order_List_Array.count >= neworderoffset && Order_List_Array.count >= 20)
        {
            NSLog(@"Order Offset New ");
            indicator.hidden = NO;
            [self.indicator startAnimating];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               neworderoffset = neworderoffset + 20;
                               [self OrderService];
                               [self getOrderTotal];
                               [self.indicator stopAnimating];
                               indicator.hidden = YES;
                           });
        }
	}
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"orderlistcount %d",Order_List_Array.count);
    if(Order_List_Array.count > 0)
    {
        error_label.hidden=YES;
    }
    else
    {
        error_label.hidden=NO;
    }
    return Order_List_Array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(IBAction)Get_Product
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    pdfView.hidden=YES;
    close_Button.hidden=YES;
    if([product_picker isHidden])
    {
        product_picker.hidden=NO;
        product_picker_toolbar.hidden = NO;
    }
    else
    {
        product_picker.hidden=YES;
        product_picker_toolbar.hidden = YES;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"neworder_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[Order_List_Array objectAtIndex:indexPath.row];
    NSLog(@"%d itemindex %@",indexPath.row,itemAtIndex);
    clinic_name=(UILabel *)[cell viewWithTag:1];
    clinic_name.text = [itemAtIndex objectForKey:@"ClinicName"];
    clinic_name.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    product_name=(UILabel *)[cell viewWithTag:7];
    product_name.text = [itemAtIndex objectForKey:@"ProductName"];
    product_name.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    if([[itemAtIndex objectForKey:@"ProductCount"] intValue]>0)
    {
        product_name.text = [NSString stringWithFormat:@"%@ + %d",[itemAtIndex objectForKey:@"ProductName"],[[itemAtIndex objectForKey:@"ProductCount"] intValue]];
    }
    
    
    
    NSString *bonus_string = @"";
    if([[itemAtIndex objectForKey:@"BonusQuantity"] integerValue]>0)
    {
        NSString *bonuquantity = [NSString stringWithFormat:@"%@",[itemAtIndex objectForKey:@"BonusQuantity"]];
        bonus_string = [bonus_string stringByAppendingFormat:@" + "];
        bonus_string = [bonus_string stringByAppendingString:bonuquantity];
    }
    
    NSString *unofficialbonus_string = @"";
    if([[itemAtIndex objectForKey:@"UnofficialBonus"] integerValue]>0)
    {
        NSString *unbonuquan = [NSString stringWithFormat:@"%@",[itemAtIndex objectForKey:@"UnofficialBonus"]];
        
        unofficialbonus_string = [unofficialbonus_string stringByAppendingFormat:@" + "];
        unofficialbonus_string = [unofficialbonus_string stringByAppendingString:unbonuquan];
    }
    
    NSString *total_quantity = [NSString stringWithFormat:@"%@%@%@",[itemAtIndex objectForKey:@"Quantity"],bonus_string,unofficialbonus_string];
    
    
    
    
    order_quantity=(UILabel *)[cell viewWithTag:3];
    //NSInteger order_qunatity_int = [[itemAtIndex objectForKey:@"Quantity"] integerValue];
    //order_quantity.text = [NSString stringWithFormat:@"%d",order_qunatity_int];
    order_quantity.text = total_quantity;
    //order_quantity.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    order_quantity.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    
    order_date=(UILabel *)[cell viewWithTag:5];
    order_date.text = [itemAtIndex objectForKey:@"OrderDate"];
    order_date.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    NSLog(@"orderdate %@",order_date.text);
    /* invoice_no=(UILabel *)[cell viewWithTag:5];
     invoice_no.text = [itemAtIndex objectForKey:@"InvoiceNo"];
     invoice_no.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
     */
    //    bonus=(UILabel *)[cell viewWithTag:6];
    //    NSInteger bonus_int = [[itemAtIndex objectForKey:@"BonusQuantity"] integerValue];
    //    bonus.text = [NSString stringWithFormat:@"%d",bonus_int];
    //    bonus.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    //
    //    unofficial_bonus=(UILabel *)[cell viewWithTag:7];
    //    NSInteger unofficialbonus_int = [[itemAtIndex objectForKey:@"UnofficialBonus"] integerValue];
    //    unofficial_bonus.text = [NSString stringWithFormat:@"%d",unofficialbonus_int];
    //    unofficial_bonus.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    
    status=(UILabel *)[cell viewWithTag:8];
    if([[itemAtIndex objectForKey:@"Status"] isEqualToString:@"Processing"])
    {
        status.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    else
    {
        status.textColor= [UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(0/255.0) alpha:1];
    }
    
    status.text = [itemAtIndex objectForKey:@"Status"];
    
    remarks=(UILabel *)[cell viewWithTag:9];
    remarks.text = [itemAtIndex objectForKey:@"Remark"];
    
    NSString *totalamount_string = [NSString stringWithFormat:@"S$ "];
    if([[itemAtIndex objectForKey:@"OrderPrice"] isEqual:[NSNull null]])
        totalamount_string = [totalamount_string stringByAppendingFormat:@"0"];
    else
        totalamount_string = [totalamount_string stringByAppendingFormat:@"%@",[itemAtIndex objectForKey:@"OrderPrice"]];
    
    totalamount=(UILabel *)[cell viewWithTag:12];
    totalamount.text = totalamount_string;
    totalamount.textColor= [UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(0/255.0) alpha:1];
    
    totalamountlabel=(UILabel *)[cell viewWithTag:6];
    totalamountlabel.textColor= [UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(0/255.0) alpha:1];
    
    sno=(UILabel *)[cell viewWithTag:11];
    NSString *sno_string = [NSString stringWithFormat:@"%d",(order_array.count + 1) - (indexPath.row+1)];
    sno_string = [sno_string stringByAppendingString:@"."];
    //sno.text = sno_string;
    
    sno.text = [NSString stringWithFormat:@"%@",[itemAtIndex objectForKey:@"RowNumner"]];
    sno.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
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
    NSLog([[itemAtIndex objectForKey:@"InvoiceGenerated"]boolValue]?@"invoice true":@"invoice false");
    Edit_Button = (UIButton *)[cell viewWithTag:10];
    view_Button = (UIButton *)[cell viewWithTag:13];
    if([[itemAtIndex objectForKey:@"InvoiceGenerated"]boolValue])
    { Edit_Button.hidden=YES;
        view_Button.hidden=NO;
        
    }else
    {   Edit_Button.hidden=NO;
        view_Button.hidden=YES;
        
    }
    
    
    [Edit_Button addTarget:self action:@selector(EditOrder:) forControlEvents:UIControlEventTouchUpInside];
    [view_Button addTarget:self action:@selector(PDFView:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        Edit_Button.hidden = YES;
    }
    else
    {
        Edit_Button.hidden = NO;
    }
    
    return cell;
}
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData=[[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append data in the reception buffer
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [pdfView loadData:responseData MIMEType:@"text/pdf" textEncodingName:@"UTF-8" baseURL:nil];
    [self removeActivityView];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Something went wrong ..
    
}
- (IBAction)EditOrder:(UIButton *)sender
{
    close_Button.hidden=YES;
    //NSIndexPath *indexPath =[self.order_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:order_table];
    NSIndexPath *indexPath = [order_table indexPathForRowAtPoint:rootViewPoint];
    
    [addordercontroller setOrderId:[[Order_List_Array objectAtIndex:indexPath.row]valueForKey:@"OrderId"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[Order_List_Array objectAtIndex:indexPath.row]valueForKey:@"OrderId"]  forKey:@"OrderId"];
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       NSString *top_usernamelabel = @"Welcome, ";
                       top_usernamelabel = [top_usernamelabel stringByAppendingString:[defaults objectForKey:@"fullname"]];
                       
                       LeftSidebarViewController *lftsbr=[[LeftSidebarViewController alloc]init];
                       lftsbr.topheading_label.text = top_usernamelabel;
                       
                       
                       //lftsbr.topheading_label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
                       lftsbr.topheading_label.text = @"Edit Order";
                       
                       
                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                       addordercontroller = [storyboard instantiateViewControllerWithIdentifier:@"addorder_screen"];
                       addordercontroller.view.tag=990;
                       NSLog(@"orderlistarray %@ and id %@",[Order_List_Array objectAtIndex:indexPath.row],[[Order_List_Array objectAtIndex:indexPath.row]valueForKey:@"OrderId"]);
                       
                       addordercontroller.view.frame=CGRectMake(0,0, 841, 784);
                       addordercontroller.areaArray=location_array;
                       addordercontroller.specializationArray=specialization_array;
                       addordercontroller.productArray=product_array;
                       //    Added by rohit modi
                       // mentain last and new product array in add/edit order
                       addordercontroller.latestProductArray=[product_array mutableCopy];
                       addordercontroller.oldProductArray=[product_array mutableCopy];
                       //    end

                       [addordercontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 784.0f)]; //notice this is OFF screen!
                       [UIView beginAnimations:@"animateTableView" context:nil];
                       [UIView setAnimationDuration:0.4];
                       [addordercontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 784.0f)]; //notice this is ON screen!
                       [UIView commitAnimations];
                       
                       
                       [self.view addSubview:addordercontroller.view];
                       
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Edit Order",@"heading", nil]];
                       [self removeActivityView];
                   });
    
}
- (IBAction)PDFView:(UIButton *)sender
{
    close_Button.hidden=NO;
    //NSIndexPath *indexPath =[self.order_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:order_table];
    NSIndexPath *indexPath = [order_table indexPathForRowAtPoint:rootViewPoint];
    
    [addordercontroller setOrderId:[[Order_List_Array objectAtIndex:indexPath.row]valueForKey:@"OrderId"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[Order_List_Array objectAtIndex:indexPath.row]valueForKey:@"OrderId"]  forKey:@"OrderId"];
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://rkpharma.com/invoice.ashx?id=%@",[[Order_List_Array objectAtIndex:indexPath.row]valueForKey:@"OrderId"]]];
                    //   NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://ranosys.info/rkpharma/invoice.ashx?id=%@",[[Order_List_Array objectAtIndex:indexPath.row]valueForKey:@"OrderId"]]];
                       
                       NSLog(@"URL %@",[NSString stringWithFormat:@"http://rkpharma.com/invoice.ashx?id=%@",[[Order_List_Array objectAtIndex:indexPath.row]valueForKey:@"OrderId"]]);
                       
                       NSURLRequest *newrequest = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
                       [NSURLConnection connectionWithRequest:newrequest delegate:self];
                       //[brochure_view loadRequest:newrequest];
                       
                       pdfView.hidden=NO;
                       
                       
                   });
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    product_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
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
    else if(pickerView==product_picker)
    {
        return product_array.count;
    }
    else
    {
        return specialization_array.count;
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
        
        if(pickerView==product_picker)
        {
            //label size
            CGRect frame = CGRectMake(20.0, 0.0, 250, 150);
            
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            //here you can play with fonts
            [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        }
        else{
            //label size
            CGRect frame = CGRectMake(20.0, 0.0, 150, 150);
            
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
    else if(pickerView==product_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:row];
        
        //picker view array is the datasource
        [pickerLabel setText:[itemAtIndex objectForKey:@"ProductName"]];
    }
    else if(pickerView==specialization_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[specialization_array objectAtIndex:row];
        
        //picker view array is the datasource
        [pickerLabel setText:[itemAtIndex objectForKey:@"Specialization"]];
    }
    
    return pickerLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView==location_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
        neworderlocationid_selected=[itemAtIndex objectForKey:@"LocationId"];
        
        NSString *location_name = @"   ";
        location_name = [location_name stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]];
        
        [location_button setTitle:[itemAtIndex objectForKey:@"LocationName"] forState:UIControlStateNormal];
        location_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        [location_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        location_picker.showsSelectionIndicator = YES;
        location_picker.hidden= NO;
        location_picker_toolbar.hidden = NO;
        
    }
    else if(pickerView==product_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:row];
        neworderproductid_selected=[itemAtIndex objectForKey:@"ProductId"];
        
        NSString *product_namestring = @"   ";
        product_namestring = [product_namestring stringByAppendingString:[itemAtIndex objectForKey:@"ProductName"]];
        [product_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        [product_button setTitle:[itemAtIndex objectForKey:@"ProductName"] forState:UIControlStateNormal];
        product_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        product_picker.showsSelectionIndicator = YES;
        product_picker.hidden= NO;
        product_picker_toolbar.hidden = NO;
    }
    else
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[specialization_array objectAtIndex:row];
        neworderspecializationid_selected=[itemAtIndex objectForKey:@"Id"];
        
        NSString *specialization_namestring = @"   ";
        specialization_namestring = [specialization_namestring stringByAppendingString:[itemAtIndex objectForKey:@"Specialization"]];
        
        [specialization_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        [specialization_button setTitle:[itemAtIndex objectForKey:@"Specialization"] forState:UIControlStateNormal];
        specialization_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        specialization_picker.showsSelectionIndicator = YES;
        specialization_picker.hidden= NO;
        specialization_picker_toolbar.hidden  = NO;
    }
}

-(IBAction)Get_Location
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    pdfView.hidden=YES;
    close_Button.hidden=YES;
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


-(IBAction)ResetOrder
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    product_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    product_picker.hidden = YES;
    pdfView.hidden=YES;
    close_Button.hidden=YES;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       newdatetostring_selected = [self GetLastDay];
                       newdatefromstring_selected = [self getFirstDay];
                       
                       
                       newtotal = 0.0;
                       neworderoffset = 0;
                       neworderproductid_selected=@"0";
                       neworderlocationid_selected = @"0";
                       neworderspecializationid_selected = @"0";
                       [Order_List_Array removeAllObjects];
                       [datefrom_button setTitle:@"  Date From" forState:UIControlStateNormal];
                       [dateto_button setTitle:@"  Date To" forState:UIControlStateNormal];
                       [location_button setTitle:@"  Select Area" forState:UIControlStateNormal];
                       [specialization_button setTitle:@"  Specialization" forState:UIControlStateNormal];
                       [product_button setTitle:@"  Select Product" forState:UIControlStateNormal];
                       
                       [location_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [specialization_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [product_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       
                       [datefrom_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [dateto_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [self OrderService];
                       [self getOrderTotal];
                       
                       location_picker.showsSelectionIndicator = NO;
                       specialization_picker.showsSelectionIndicator = NO;
                       product_picker.showsSelectionIndicator = NO;
                       [location_picker reloadAllComponents];
                       [specialization_picker reloadAllComponents];
                       [product_picker reloadAllComponents];
                       [self removeActivityView];
                   });
}

-(IBAction)SearchOrder
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    product_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    pdfView.hidden=YES;
    close_Button.hidden=YES;
    neworderoffset = 0;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [Order_List_Array removeAllObjects];
                       newtotal = 0.0;
                       [self getOrderTotal];
                       [self OrderService];
                       [self removeActivityView];
                   });
}

-(IBAction)GetDateFrom
{
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    product_picker.hidden = YES;
    pdfView.hidden=YES;
    close_Button.hidden=YES;
    if([datefrom_picker isHidden])
    {
        datefrom_picker.hidden=NO;
        datefrom_picker_toolbar.hidden = NO;
    }
    
    else
    {
        datefrom_picker.hidden=YES;
        datefrom_picker_toolbar.hidden = YES;
    }
}

-(IBAction)GetDateTo
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    product_picker.hidden = YES;
    pdfView.hidden=YES;
    close_Button.hidden=YES;
    if([dateto_picker isHidden])
    {
        dateto_picker.hidden=NO;
        dateto_picker_toolbar.hidden = NO;
    }
    else
    {
        dateto_picker.hidden=YES;
        dateto_picker_toolbar.hidden = YES;
    }
}

-(IBAction)GetSpecialization
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden  = YES;
    product_picker.hidden = YES;
    pdfView.hidden=YES;
    close_Button.hidden=YES;
    if([specialization_picker isHidden])
    {
        specialization_picker.hidden=NO;
        specialization_picker_toolbar.hidden  = NO;
    }
    else
    {
        specialization_picker.hidden=YES;
        specialization_picker_toolbar.hidden  = YES;
    }
}


@end