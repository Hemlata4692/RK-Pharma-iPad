//
//  OrderListViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "OrderListViewController.h"
#import "JSON.h"
#import "Order.h"
#import "OrderManager.h"
#import "DejalActivityView.h"
#import "ProductManager.h"
#import "UserManager.h"
#import "ClinicManager.h"

NSString *datetostring_selected = @"";
NSString *datefromstring_selected = @"";
NSString *orderlocationid_selected = @"";
NSString *orderproductid_selected = @"";
NSString *orderspecializationid_selected = @"";

int orderoffset = 0;
float total = 0.0;

@interface OrderListViewController ()

@end

@implementation OrderListViewController
@synthesize order_table,clinic_name,product_name,order_quantity,order_date,invoice_no,bonus,unofficial_bonus,status,dateto_picker,datefrom_picker,dateto_button,datefrom_button,product_button,location_button,location_picker,error_label,product_picker,remarks,specialization_button,specialization_picker,indicator,gtotal,totalamount,totalamountlabel,gtotallabel,sno;
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


- (void)removeActivityView;
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
    specialization_picker_toolbar.hidden = YES;
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
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
}


-(IBAction)OrderService
{
    //Create domain class object
    Order *order=[[Order alloc]init];
    
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
    
    if(![[NSString stringWithFormat:@"%@",datefromstring_selected] isEqualToString:@""] || ![[NSString stringWithFormat:@"%@",datetostring_selected] isEqualToString:@""] || ![[NSString stringWithFormat:@"%@",orderlocationid_selected] isEqualToString:@""] || ![[NSString stringWithFormat:@"%@",orderproductid_selected] isEqualToString:@""] || ![[NSString stringWithFormat:@"%@",orderspecializationid_selected] isEqualToString:@""])
    {
        NSLog(@" If Con");
        order.datefrom_string = datefromstring_selected;
        order.dateto_string = datetostring_selected;
    }
    else
    {
        NSLog(@" Else Con");
        order.datefrom_string = [NSString stringWithFormat:@"01-%@-%d",date_month,year];
        order.dateto_string = [df stringFromDate:tDateMonth];
    }
    
    
    
    order.location_id = orderlocationid_selected;
    order.product_name = orderproductid_selected;
    order.specialization_id = orderspecializationid_selected;
    
    NSString *offsetstring = [NSString stringWithFormat:@"%d",orderoffset];
    
    order.offset = offsetstring;
    
    //Create business manager class object
    OrderManager *om_business=[[OrderManager alloc]init];
    NSString *response=[om_business GetOrderList:order];//call businessmanager login method and handle response
    NSLog(@" Order List response is %@",response);
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Order List%@",var);
        
        
        for(NSDictionary *dictvar in var)
        {
            [order_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"BonusQuantity"],@"BonusQuantity",[dictvar objectForKey:@"ClinicName"],@"ClinicName",[dictvar objectForKey:@"DoctorName"],@"DoctorName",[dictvar objectForKey:@"OrderDate"],@"OrderDate",[dictvar objectForKey:@"ProductName"],@"ProductName",[dictvar objectForKey:@"Quantity"],@"Quantity",[dictvar objectForKey:@"Status"],@"Status",[dictvar objectForKey:@"UnofficialBonus"],@"UnofficialBonus",[dictvar objectForKey:@"InvoiceNo"],@"InvoiceNo",[dictvar objectForKey:@"Remark"],@"Remark",[dictvar objectForKey:@"OrderPrice"],@"OrderPrice",[dictvar objectForKey:@"RowNumner"],@"RowNumner",nil]];
            total += [[dictvar objectForKey:@"OrderPrice"] floatValue];
            NSLog(@"Float Value %.2f",[[dictvar objectForKey:@"OrderPrice"] floatValue]);
            
        }
        NSLog(@" Total Result : %.2f",total);
        //        gtotal.text = [NSString stringWithFormat: @"%.2f", total];
        //        gtotal.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        //        gtotallabel.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        [order_table reloadData];
        // Do any additional setup after loading the view.
        
        
        //Create business manager class object
        OrderManager *omgtotal_business=[[OrderManager alloc]init];
        NSString *responsegtotal=[omgtotal_business GetOrderGtotal:order];//call businessmanager login method and handle response
        NSLog(@" Order Total response is %@",responsegtotal);
        
        NSDictionary *vargtotal =  [responsegtotal JSONValue];
        NSLog(@"dict Order Total%@",vargtotal);
        //NSLog(@" Gtotal %@",[vargtotal objectForKey:@"Total"]);
        NSLog(@"Gtotal Value %.2f",[[vargtotal objectForKey:@"Total"] floatValue]);
        
        gtotal.text = [NSString stringWithFormat: @"%.2f", [[vargtotal objectForKey:@"Total"] floatValue]];
        gtotal.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        gtotallabel.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        
        
        if(order_array.count == 0)
        {
            self.order_table.frame = CGRectMake(10,86,821,0);
        }
        else if(order_array.count == 1)
        {
            self.order_table.frame = CGRectMake(10,86,821,100);
        }
        else if(order_array.count == 2)
        {
            self.order_table.frame = CGRectMake(10,86,821,200);
        }
        else if(order_array.count == 3)
        {
            self.order_table.frame = CGRectMake(10,86,821,300);
        }
        else if(order_array.count == 4)
        {
            self.order_table.frame = CGRectMake(10,86,821,400);
        }
        else if(order_array.count == 5)
        {
            self.order_table.frame = CGRectMake(10,86,821,500);
        }
        else if(order_array.count >= 6)
        {
            self.order_table.frame = CGRectMake(10,86,821,600);
        }
        
        if(order_array.count == 0)
        {
            error_label.text = @"No Record Found !";
            error_label.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
            gtotal.hidden = YES;
            gtotallabel.hidden = YES;
        }
        else
        {
            error_label.text = @"";
            gtotal.hidden = NO;
            gtotallabel.hidden = NO;
        }
    }
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
    datetostring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:dateto_picker.date]];
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
    datefromstring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:datefrom_picker.date]];
    [datefrom_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    orderlocationid_selected = @"";
    orderproductid_selected = @"";
    datetostring_selected = @"";
    datefromstring_selected = @"";
    orderspecializationid_selected = @"";
    orderoffset = 0;
    total = 0.0;
    
    location_array = [[NSMutableArray alloc] init];
    product_array = [[NSMutableArray alloc] init];
    specialization_array = [[NSMutableArray alloc] init];
    
    // To Show Location Picker
    location_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(10,75+14,200,100)];
    location_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(location_picker.frame.origin.x, 45,location_picker.frame.size.width,30+14)];
    
    
    // To Show Location Picker
    product_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(173,75+14,300,100)];
    product_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(product_picker.frame.origin.x, 45,product_picker.frame.size.width,30+14)];
    
    
    // To Show Location Picker
    specialization_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(336,75+14,200,100)];
    specialization_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(specialization_picker.frame.origin.x, 45,specialization_picker.frame.size.width,30+14)];
    
    
    // To Show Location Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [location_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:location_picker];
    //[location_picker_toolbar sizeToFit];
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
    
    
    [location_picker setDelegate:self];
    [location_picker setDataSource:self];
    location_picker.hidden=YES;
    location_picker_toolbar.hidden = YES;
    location_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
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
    
    // To Show Product Picker View
    UITapGestureRecognizer *gestureRecognizerspecializationpicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognizedspecializationpicker:)];
    gestureRecognizerspecializationpicker.cancelsTouchesInView = NO;
    
    // To Show Specialization Picker View
    
    [specialization_picker addGestureRecognizer:gestureRecognizerspecializationpicker];
    [self.view addSubview:specialization_picker];
    
    [specialization_picker setDelegate:self];
    [specialization_picker setDataSource:self];
    specialization_picker.hidden=YES;
    specialization_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    //[location_picker_toolbar sizeToFit];
    specialization_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
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
    [self.view addSubview:specialization_picker_toolbar];
    /**********************/
    specialization_picker_toolbar.hidden = YES;
    
    // To create datepickers
    dateto_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(580,75+14,250,150)];
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
    
    
    datefrom_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(499,75+14,250,150)];
    datefrom_picker.datePickerMode = UIDatePickerModeDate;
    datefrom_picker.date = [NSDate date];
    [datefrom_picker addTarget:self action:@selector(ChangeDateFromLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datefrom_picker];
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
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
    
    // To Hide Picker when touch outside of textfield
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                                   initWithTarget:self
    //                                   action:@selector(dismissKeyboard)];
    //
    //    [self.view addGestureRecognizer:tap];
    //    [tap setCancelsTouchesInView:NO];
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    order_array = [[NSMutableArray alloc]init];
    
    self.order_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    [self OrderService];
    
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
    location_picker_toolbar.hidden =YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
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
    NSLog(@"Order Offset ");
	if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height)
    {
        NSLog(@"Order Offset ");
        if(order_array.count >= orderoffset && order_array.count >= 20)
        {
            indicator.hidden = NO;
            [self.indicator startAnimating];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               orderoffset = orderoffset + 20;
                               [self OrderService];
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
    return order_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"order_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[order_array objectAtIndex:indexPath.row];
    
    clinic_name=(UILabel *)[cell viewWithTag:1];
    clinic_name.text = [itemAtIndex objectForKey:@"ClinicName"];
    clinic_name.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    product_name=(UILabel *)[cell viewWithTag:2];
    product_name.text = [itemAtIndex objectForKey:@"ProductName"];
    product_name.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    
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
    
    NSLog(@"Total Quant %@",total_quantity);
    
    
    order_quantity=(UILabel *)[cell viewWithTag:3];
    //NSInteger order_qunatity_int = [[itemAtIndex objectForKey:@"Quantity"] integerValue];
    //order_quantity.text = [NSString stringWithFormat:@"%d",order_qunatity_int];
    order_quantity.text = total_quantity;
    //order_quantity.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    order_quantity.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    
    order_date=(UILabel *)[cell viewWithTag:4];
    order_date.text = [itemAtIndex objectForKey:@"OrderDate"];
    order_date.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    invoice_no=(UILabel *)[cell viewWithTag:5];
    invoice_no.text = [itemAtIndex objectForKey:@"InvoiceNo"];
    invoice_no.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
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
    totalamount_string = [totalamount_string stringByAppendingFormat:@"%@",[itemAtIndex objectForKey:@"OrderPrice"]];
    
    totalamount=(UILabel *)[cell viewWithTag:10];
    totalamount.text = totalamount_string;
    totalamount.textColor= [UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(0/255.0) alpha:1];
    
    totalamountlabel=(UILabel *)[cell viewWithTag:6];
    totalamountlabel.textColor= [UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(0/255.0) alpha:1];
    
    sno=(UILabel *)[cell viewWithTag:11];
    NSString *sno_string = [NSString stringWithFormat:@"%d",(order_array.count + 1) - (indexPath.row+1)];
    sno_string = [sno_string stringByAppendingString:@"."];
    //sno.text = sno_string;
    
    sno.text = [NSString stringWithFormat:@"%@",[itemAtIndex objectForKey:@"RowNumner"]];    sno.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
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
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
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
        else
        {
            //label size
            CGRect frame = CGRectMake(20.0, 0.0, 150, 150);
            
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
        orderlocationid_selected=[itemAtIndex objectForKey:@"LocationId"];
        
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
        orderproductid_selected=[itemAtIndex objectForKey:@"ProductId"];
        
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
        orderspecializationid_selected=[itemAtIndex objectForKey:@"Id"];
        
        NSString *specialization_namestring = @"   ";
        specialization_namestring = [specialization_namestring stringByAppendingString:[itemAtIndex objectForKey:@"Specialization"]];
        
        [specialization_button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        [specialization_button setTitle:[itemAtIndex objectForKey:@"Specialization"] forState:UIControlStateNormal];
        specialization_button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        specialization_picker.showsSelectionIndicator = YES;
        specialization_picker.hidden= NO;
        specialization_picker_toolbar.hidden = NO;
    }
}

-(IBAction)Get_Location
{
    NSLog(@"anju");
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
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

-(IBAction)Get_Product
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
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

-(IBAction)ResetOrder
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
    
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
                       
                       
                       datetostring_selected = @"";
                       datefromstring_selected = @"";
                       
                       total = 0.0;
                       orderoffset = 0;
                       orderlocationid_selected = @"";
                       orderproductid_selected = @"";
                       orderspecializationid_selected = @"";
                       [order_array removeAllObjects];
                       [datefrom_button setTitle:@"  Date From" forState:UIControlStateNormal];
                       [dateto_button setTitle:@"  Date To" forState:UIControlStateNormal];
                       [location_button setTitle:@"  Select Area" forState:UIControlStateNormal];
                       [product_button setTitle:@"  Select by Product" forState:UIControlStateNormal];
                       [specialization_button setTitle:@"  Specialization" forState:UIControlStateNormal];
                       
                       [location_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [product_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [specialization_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [datefrom_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       [dateto_button setTitleColor:[UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1] forState:UIControlStateNormal];
                       
                       [self OrderService];
                       
                       location_picker.showsSelectionIndicator = NO;
                       product_picker.showsSelectionIndicator = NO;
                       specialization_picker.showsSelectionIndicator = NO;
                       
                       [location_picker reloadAllComponents];
                       [product_picker reloadAllComponents];
                       [specialization_picker reloadAllComponents];
                       
                       [self removeActivityView];
                   });
}

-(IBAction)SearchOrder
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    dateto_picker.hidden = YES;
    dateto_picker_toolbar.hidden = YES;
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
    orderoffset = 0;
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [order_array removeAllObjects];
                       total = 0.0;
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
    specialization_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    if([datefrom_picker isHidden])
    {
        datefrom_picker.hidden=NO;
        datefrom_picker_toolbar.hidden = NO;
    }
    else
    {
        datefrom_picker_toolbar.hidden = YES;
        datefrom_picker.hidden=YES;
    }
}

-(IBAction)GetDateTo
{
    datefrom_picker.hidden = YES;
    datefrom_picker_toolbar.hidden = YES;
    
    location_picker.hidden = YES;
    location_picker_toolbar.hidden = YES;
    specialization_picker.hidden = YES;
    specialization_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
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
    location_picker_toolbar.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    if([specialization_picker isHidden])
    {
        specialization_picker.hidden=NO;
        specialization_picker_toolbar.hidden = NO;
    }
    else 
    {
        specialization_picker.hidden=YES;
        specialization_picker_toolbar.hidden = YES;
    }
}


@end
