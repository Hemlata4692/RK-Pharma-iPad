//
//  AddOrderViewController.m
//  RKPharma
//
//  Created by Shivendra on 25/07/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "AddOrderViewController.h"
#import "Clinic.h"
#import "ClinicManager.h"
#import "JSON.h"
#import "OrderManager.h"
#import "Order.h"
#import "DejalActivityView.h"
#import "NewOrderListViewController.h"
@interface AddOrderViewController ()

@end

@implementation AddOrderViewController
@synthesize areaArray,clinicArray,specializationArray,productArray,internal_scroll,external_scrool,orderId;
@synthesize table,productPicker,datePicker,ordeObject,area_picker_toolbar;
@synthesize  toolBar,toolBar1,clinic_picker_toolbar;
NSString *orderdatevalue=@"",*areaidvalue=@"",*clinicIdValue=@"",*productIdValue=@"",*deliveryDateValue=@"",*alert_msg=@"",*orderStatus=@"Delivered",*invoicereceived=@"0",*payment_received=@"0";
NSMutableArray *old_arr;
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
    NSLog(@"show aaya");
    [DejalBezelActivityView activityViewForView:self.view];
}


- (void)removeActivityView
{
    NSLog(@"hide aaya");
    // Remove the activity view, with animation for the two styles that support it:
    [DejalBezelActivityView removeViewAnimated:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

-(void)dateChanged
{
    NSLog(@"date");
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    //[dateFormat setDateStyle:NSDateFormatterMediumStyle];
    UITableViewCell *cell = [table cellForRowAtIndexPath:rowIndex];
    UITextField *textField = (UITextField *)[cell viewWithTag:3];
    
    textField.text=[dateFormat stringFromDate:date];
    //NSIndexPath *indexPath=[self.table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
    NSIndexPath *indexPath;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        
        indexPath=[self.table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        
    }
    else
    {
        indexPath =[self.table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
    }
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDictionary *oldDict = (NSDictionary *)[arr objectAtIndex:indexPath.row];
    [newDict addEntriesFromDictionary:oldDict];
    [newDict setValue:textField.text forKey:@"expiry"];
    [arr replaceObjectAtIndex:indexPath.row withObject:newDict];
}
NSString *OT=@"100",*OS=@"",*TOD=@"";
-(IBAction)button_select:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    if(btn.tag==100 || btn.tag==101)
    {
        OT=[NSString stringWithFormat:@"%d",btn.tag];
        for (UIButton *but in [external_scrool subviews]) {
            if(but.tag>99 && but.tag<102){
                if ([but isKindOfClass:[UIButton class]] && ![but isEqual:btn]) {
                    [but setSelected:NO];
                }
            }
        }
        if (!btn.selected) {
            btn.selected = !btn.selected;
        }
        [table reloadData];
    }
    else if(btn.tag==102 || btn.tag==103 || btn.tag==108)
    {
        OS=[NSString stringWithFormat:@"%d",btn.tag];
        for (UIButton *but in [internal_scroll subviews]) {
            if(but.tag==102 || but.tag==103 || but.tag==108){
                if ([but isKindOfClass:[UIButton class]] && ![but isEqual:btn]) {
                    [but setSelected:NO];
                }
            }
        }
        if (!btn.selected) {
            btn.selected = !btn.selected;
        }
        
    }
    else if(btn.tag==104 || btn.tag==105)
    {
        TOD=[NSString stringWithFormat:@"%d",btn.tag];
        for (UIButton *but in [internal_scroll subviews]) {
            if(but.tag>103 && but.tag<106){
                if ([but isKindOfClass:[UIButton class]] && ![but isEqual:btn]) {
                    [but setSelected:NO];
                }
            }
        }
        if (!btn.selected) {
            btn.selected = !btn.selected;
        }
        
    }
}
-(void)getclinicData
{
    Clinic *clinic=[[Clinic alloc]init];
    
    //set Clinic Name value in domain class
    clinic.location = areaidvalue;
    
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    NSString *response=[cm_business GetClinicNameList:clinic];//call businessmanager  method and handle response
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        [clinicArray removeAllObjects];
        //    [selectionStates removeAllObjects];
        for(NSDictionary *dictvar in var)
        {
            [clinicArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"ClinicId"],@"ClinicId",[dictvar objectForKey:@"ClinicName"],@"ClinicName",nil]];
        }
        NSLog(@"clinicarray %@",clinicArray);
        [clinic_picker reloadAllComponents];
    }
    
}
-(void)getOrderData:(NSString*)OrderId
{
    // [area_picker reloadAllComponents];
    
    Order *order=[[Order alloc]init];
    
    //set Clinic Name value in domain class
    order.order_id =orderId ;
    //Create business manager class object
    OrderManager *ordermanager=[[OrderManager alloc]init];
    NSString *response=[ordermanager getOrderData:order];//call businessmanager  method and handle response
    
    NSLog(@"repeatproduct1 %@",response.JSONValue);
    //{"BonusQuantity":0,"IsRepeat":false,"OrderQuantity":0,"UnofficialBonus":0}
    NSMutableArray *array=[response JSONFragmentValue];
    comments.text=[array valueForKey:@"Comments"];
     remarks.text=[array valueForKey:@"iPadRemark"];
    
    NSString *datefrom_string1 = @"   ";
    datefrom_string1 = [datefrom_string1 stringByAppendingString:[NSString stringWithFormat:@"%@",[array valueForKey:@"DeliveryDate"]]];
    [delivery_date setTitle:datefrom_string1 forState:UIControlStateNormal];
    [delivery_date setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
    deliveryDateValue=[array valueForKey:@"DeliveryDate"];
    
    delivery_note.text=[array valueForKey:@"DeliveryNote"];
   

    
    TOD=[NSString stringWithFormat:@"%@",[array valueForKey:@"DeliveryTerm"]];
    for (UIButton *but in [internal_scroll subviews]) {
        if([TOD intValue]==1 && but.tag==104)
        {            TOD=[NSString stringWithFormat:@"%d",104];
            
            but.selected=YES;
        }else if([TOD intValue]==2 && but.tag==105)
        {   but.selected=YES;
            TOD=[NSString stringWithFormat:@"%d",105];
        }
    }
    
    invoicereceived=[[array valueForKey:@"InvoiceReturned"]boolValue]?[NSString stringWithFormat:@"%@",@"1"]:[NSString stringWithFormat:@"%@",@"0"];
    
    payment_received=[[array valueForKey:@"PaymentReceived"]boolValue]?[NSString stringWithFormat:@"%@",@"1"]:[NSString stringWithFormat:@"%@",@"0"];
    
    areaidvalue=[NSString stringWithFormat:@"%@",[array valueForKey:@"LocationId"]];
    [self getclinicData];
    
    for(int i=0;i<areaArray.count;i++)
    {
        
        if([[NSString stringWithFormat:@"%@",[[areaArray objectAtIndex:i]valueForKey:@"LocationId"]] isEqualToString:[NSString stringWithFormat:@"%@",areaidvalue]])
        {
            [select_area setTitle:[[areaArray objectAtIndex:i]valueForKey:@"LocationName"] forState:UIControlStateNormal];
            select_area.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
            [select_area setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
            select_area.userInteractionEnabled=NO;
            break;
        }
    }
    // [clinic_picker reloadAllComponents];
    clinicIdValue=[NSString stringWithFormat:@"%@",[array valueForKey:@"ClinicId"]];
    for(int i=0;i<clinicArray.count;i++)
    {
        if([[NSString stringWithFormat:@"%@",[[clinicArray objectAtIndex:i]valueForKey:@"ClinicId"]] isEqualToString:[NSString stringWithFormat:@"%@",clinicIdValue]])
        {
            [select_clinic setTitle:[[clinicArray objectAtIndex:i]valueForKey:@"ClinicName"] forState:UIControlStateNormal];
            select_clinic.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
            [select_clinic setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
            break;
        }
    }
    
    NSString *datefrom_string = @"   ";
    datefrom_string = [datefrom_string stringByAppendingString:[NSString stringWithFormat:@"%@",[array valueForKey:@"OrderDate"]]];
    [orderDate setTitle:datefrom_string forState:UIControlStateNormal];
    [orderDate setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
    orderdatevalue=[array valueForKey:@"OrderDate"];
    
    OS=[array valueForKey:@"OrderSource"];
    for (UIButton *but in [internal_scroll subviews]) {
        if([OS isEqualToString:@"Personal"] && but.tag==102)
        {
            OS=[NSString stringWithFormat:@"%d",102];
            but.selected=YES;
        }else if([OS isEqualToString:@"Clinic Assistant"] && but.tag==103)
        {
            OS=[NSString stringWithFormat:@"%d",103];
            but.selected=YES;
        }
        else if([OS isEqualToString:@"Fax Order"] && but.tag==108)
        {
            OS=[NSString stringWithFormat:@"%d",108];
            but.selected=YES;
        }
    }
    
    orderStatus=[array valueForKey:@"OrderStatus"];
    
    OT=[NSString stringWithFormat:@"%@",[array valueForKey:@"OrderType"]];
    for (UIButton *but in [external_scrool subviews]) {
        if([OT intValue]==2 && but.tag==100)
        {
            OT=[NSString stringWithFormat:@"%d",100];
            but.selected=YES;
        }else if([OT intValue]==1 && but.tag==101)
        {            OT=[NSString stringWithFormat:@"%d",101];
            but.selected=YES;
        }
        if(but.tag==100 || but.tag==101)
            but.userInteractionEnabled=YES;
        
    }
    
    preferred_time.text=[array valueForKey:@"PrefDeliveryTime"];
    
    NSMutableArray *productArrayResponse=[array valueForKey:@"ProductOrder"];
    page=productArrayResponse.count;
    
    NSLog(@"productcount %d and %d",productArrayResponse.count,productArray.count);
    
    [arr removeAllObjects];
    [old_arr removeAllObjects];
    old_arr=[[NSMutableArray alloc]init];
    for(int i=0;i<productArrayResponse.count;i++)
    {
        d=[[NSMutableDictionary alloc]init];
        NSLog(@"%d in",i);
        NSMutableArray *productArrayResponse1=[productArrayResponse objectAtIndex:i];
        NSLog(@"Product1 %@",productArrayResponse1);
        for(int j=0;j<productArray.count;j++)
        {
            NSLog(@"%d in",j);            
            if([[[productArray objectAtIndex:j]valueForKey:@"ProductId"]intValue] ==[[productArrayResponse1 valueForKey:@"ProductId"]intValue])
            {
                NSLog(@"if true");
                [d setValue:[[productArray objectAtIndex:j]valueForKey:@"ProductName"] forKey:@"p_name"];
                break;
            }
            else{
                NSLog(@"else true");
            }
        }
        [d setValue:[productArrayResponse1 valueForKey:@"BatchNumber"] forKey:@"batch"];
        [d setValue:[productArrayResponse1 valueForKey:@"ExpiryDate"] forKey:@"expiry"];
        [d setValue:[productArrayResponse1 valueForKey:@"DeliveredQuantity"] forKey:@"delivery"];
        [d setValue:[productArrayResponse1 valueForKey:@"OrderQuantity"] forKey:@"order"];
        [d setValue:[productArrayResponse1 valueForKey:@"BonusQuantity"] forKey:@"bonus"];
        [d setValue:[productArrayResponse1 valueForKey:@"UnofficialBonus"] forKey:@"unofficial"];
        [d setValue:[productArrayResponse1 valueForKey:@"Price"] forKey:@"netprice"];
        [d setValue:[productArrayResponse1 valueForKey:@"IsRepeat"] forKey:@"isrepeat"];
        [d setValue:[productArrayResponse1 valueForKey:@"ProductId"] forKey:@"p_id"];
        [d setValue:[productArrayResponse1 valueForKey:@"Id"] forKey:@"web_p_id"];
        [d setValue:[productArrayResponse1 valueForKey:@"MainStock"] forKey:@"stock"];
        [d setValue:[productArrayResponse1 valueForKey:@"OrderType"] forKey:@"OrderType"];
        [d setValue:[productArrayResponse1 valueForKey:@"OrderType"] forKey:@"Old_OrderType"];
        
        [arr addObject:d];
        NSLog(@"arrain %@",arr);
        [old_arr addObject:d];
    }
    
    NSLog(@"arra is %@",arr);
    table.frame=CGRectMake(6, 204, 809, page*116);
    external_scrool.contentSize=CGSizeMake(0, 606+(page*116));
    internal_scroll.frame=CGRectMake(1, table.frame.origin.y+page*120, 809, 248);
    [orderDatepicker1 setFrame:CGRectMake(330, internal_scroll.frame.origin.y+200, 250, 150)];
    [table reloadData]; 
    [self removeActivityView];
    
}

- (void)viewDidLoad
{
    NSLog(@"aayainload %@",areaArray);
    page=0;
    arr=[[NSMutableArray alloc]init ];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    orderId=[defaults objectForKey:@"OrderId"];
    NSLog(@"orderid %@",orderId);
    // orderId=[ordeObject valueForKey:@"order_id"];
    
    // productPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-220, self.view.frame.size.width, 220)];
    // submit_button.frame=CGRectMake(687, 201, 107, 33);
    [external_scrool addSubview:internal_scroll];
    [internal_scroll addSubview:submit_button];
    productPicker = [[UIPickerView alloc] init] ;//]WithFrame:CGRectMake(499,45,250,150)];
    [external_scrool addSubview:productPicker];
    productPicker.hidden=YES;
    productPicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    productPicker.showsSelectionIndicator=YES;
    productPicker.delegate=self;
    productPicker.dataSource=self;
    toolBar = [[UIToolbar alloc] init ];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    //[toolBar sizeToFit];
    [external_scrool addSubview:toolBar];
    toolBar.hidden=YES;
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressToGetValue)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    [toolBar setItems:itemsArray];
    
    toolBar1 = [[UIToolbar alloc] init ];
    [toolBar1 setBarStyle:UIBarStyleBlackTranslucent];
    //[toolBar1 sizeToFit];
    [external_scrool addSubview:toolBar1];
    toolBar1.hidden=YES;
    UIBarButtonItem *flexButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressToGetValue)];
    [doneButton1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    NSArray *itemsArray1 = [NSArray arrayWithObjects:flexButton1, doneButton1, nil];
    [toolBar1 setItems:itemsArray1];
    rowIndex=[[NSIndexPath alloc]init];
    // datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-220,320 ,220)];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(499,45,250,150)];
    [external_scrool addSubview:datePicker];
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    
    datePicker.hidden=YES;
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    //Add
    
    
    clinicArray=[[NSMutableArray alloc]init];
    orderDatepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(12,95,250,150)];
    orderDatepicker.datePickerMode = UIDatePickerModeDate;
    orderDatepicker.date = [NSDate date];
    [orderDatepicker addTarget:self action:@selector(ChangeDateFromLabel:) forControlEvents:UIControlEventValueChanged];
    [external_scrool addSubview:orderDatepicker];
    orderDatepicker.hidden = YES;
    orderDatepicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    orderDatepicker1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(330,internal_scroll.frame.origin.y+130,250,150)];
    orderDatepicker1.datePickerMode = UIDatePickerModeDate;
    orderDatepicker1.date = [NSDate date];
    [orderDatepicker1 addTarget:self action:@selector(ChangeDateFromLabel1:) forControlEvents:UIControlEventValueChanged];
    [external_scrool addSubview:orderDatepicker1];
    orderDatepicker1.hidden = YES;
    orderDatepicker1.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    area_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(170,70+44,300,150)];
    area_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(area_picker.frame.origin.x, 70,area_picker.frame.size.width,30+14)];
    area_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems9 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace9 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems9 addObject:flexSpace9];
    UIBarButtonItem *doneBtn9= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    doneBtn9.tag = 9;
    [doneBtn9 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems9 addObject:doneBtn9];
    [area_picker_toolbar setItems:barItems9 animated:YES];
    [external_scrool addSubview:area_picker_toolbar];
    //area_picker_toolbar.hidden =
    area_picker_toolbar.hidden = YES;
    
    clinic_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(501,70+44,300,150)];
    clinic_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(clinic_picker.frame.origin.x, 70,clinic_picker.frame.size.width,30+14)];
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
    [external_scrool addSubview:clinic_picker_toolbar];
    clinic_picker_toolbar.hidden = YES;
    specialization_Picker=[[UIPickerView alloc]initWithFrame:CGRectMake(410,45,400,100)];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [area_picker addGestureRecognizer:gestureRecognizer];
    [external_scrool addSubview:area_picker];
    
    [area_picker setDelegate:self];
    [area_picker setDataSource:self];
    area_picker.hidden=YES;
    area_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    UITapGestureRecognizer *gestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized1:)];
    gestureRecognizer1.cancelsTouchesInView = NO;
    
    [clinic_picker addGestureRecognizer:gestureRecognizer1];
    [external_scrool addSubview:clinic_picker];
    
    [clinic_picker setDelegate:self];
    [clinic_picker setDataSource:self];
    clinic_picker.hidden=YES;
    clinic_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    UITapGestureRecognizer *gestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized2:)];
    gestureRecognizer2.cancelsTouchesInView = NO;
    
    [specialization_Picker addGestureRecognizer:gestureRecognizer2];
    [external_scrool addSubview:specialization_Picker];
    
    [specialization_Picker setDelegate:self];
    [specialization_Picker setDataSource:self];
    specialization_Picker.hidden=YES;
    specialization_Picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    if(orderId.length!=0){
        NSLog(@"in if");
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [self displayActivityView];
                           [self getOrderData:orderId];
                          // [self removeActivityView];
                       });
    }
    else{
        NSLog(@"in else");
        //Add Prodcut
        page=1;
        for (UIButton *but in [external_scrool subviews]) {
            if(but.tag==100)
            {
                but.selected=YES;
            }
        }
        d=[[NSMutableDictionary alloc]init];
        [d setValue:@"" forKey:@"p_name"];
        [d setValue:@"" forKey:@"batch"];
        [d setValue:@"" forKey:@"expiry"];
        [d setValue:@"" forKey:@"delivery"];
        [d setValue:@"" forKey:@"order"];
        [d setValue:@"" forKey:@"bonus"];
        [d setValue:@"" forKey:@"unofficial"];
        [d setValue:@"" forKey:@"netprice"];
        [d setValue:@"0" forKey:@"isrepeat"];
        [d setValue:@"" forKey:@"p_id"];
        [d setValue:@"" forKey:@"stock"];
        [d setValue:@"false" forKey:@"delete"];
        [d setValue:@"2" forKey:@"OrderType"];
        [d setValue:@"0" forKey:@"Old_OrderType"];
        [arr addObject:d];
        
    }
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    OT = @"100";
}

-(IBAction)done_clicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag ==2)
    {
        clinic_picker_toolbar.hidden=YES;
        clinic_picker.hidden = YES;
    }else{
        area_picker_toolbar.hidden  =YES;
        area_picker.hidden = YES;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    toolBar.hidden=YES;
    toolBar1.hidden=YES;
    orderDatepicker.hidden = YES;
    orderDatepicker1.hidden = YES;
    area_picker.hidden=YES;
    area_picker_toolbar.hidden  =YES;
    clinic_picker.hidden=YES;
    clinic_picker_toolbar.hidden=YES;
    specialization_Picker.hidden=YES;
    
    // [external_scrool setContentOffset:CGPointMake(0, textView.frame.origin.y) animated:YES];
    
    if(textView==delivery_note && [textView.text isEqualToString:@"Delivery Notes"])
        textView.text=@"";
    else if(textView==comments && [textView.text isEqualToString:@"Comments"])
        textView.text=@"";
    else if(textView==remarks && [textView.text isEqualToString:@"Remarks"])
        textView.text=@"";
}-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView==delivery_note && [textView.text isEqualToString:@""])
        textView.text=@"Delivery Notes";
    else if(textView==comments && [textView.text isEqualToString:@""])
        textView.text=@"Comments";
    else if(textView==remarks && [textView.text isEqualToString:@""])
        textView.text=@"Remarks";

}
- (IBAction)AddButtonAction:(id)sender

{
    area_picker_toolbar.hidden  =YES;
    productPicker.hidden=YES;
    datePicker.hidden=YES;
    toolBar1.hidden=YES;
    orderDatepicker.hidden = YES;
    orderDatepicker1.hidden = YES;
    area_picker.hidden=YES;
    clinic_picker.hidden=YES;
    toolBar.hidden=YES;
     clinic_picker_toolbar.hidden=YES;
    toolBar.hidden=YES;
    NSLog(@"add");
    
    d=[[NSMutableDictionary alloc]init];
    [d setValue:@"" forKey:@"p_name"];
    [d setValue:@"" forKey:@"p_id"];
    [d setValue:@"" forKey:@"batch"];
    [d setValue:@"" forKey:@"expiry"];
    [d setValue:@"" forKey:@"order"];
    [d setValue:@"" forKey:@"delivery"];
    [d setValue:@"" forKey:@"bonus"];
    [d setValue:@"" forKey:@"unofficial"];
    [d setValue:@"" forKey:@"netprice"];
    [d setValue:@"0" forKey:@"isrepeat"];
    [d setValue:@"" forKey:@"stock"];
    [d setValue:@"false" forKey:@"delete"];
    [d setValue:@"2" forKey:@"OrderType"];
    [d setValue:@"0" forKey:@"Old_OrderType"];
    [arr addObject:d];
    page++;
    /* [table beginUpdates];
     NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:page-1 inSection:0]];
     [table insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
     [table endUpdates];
     */
    table.frame=CGRectMake(6, 204, 809, page*116);
    external_scrool.contentSize=CGSizeMake(0, 606+(page*116));
    internal_scroll.frame=CGRectMake(1, table.frame.origin.y+page*120, 809, 248);
    [orderDatepicker1 setFrame:CGRectMake(330, internal_scroll.frame.origin.y+200, 250, 150)];
    // submit_button.frame=CGRectMake(699,651+(page-1*116), 107, 33);
    [table reloadData];
    
}
- (void)DeleteButtonAction:(id)sender
{
    area_picker_toolbar.hidden  =YES;
    productPicker.hidden=YES;
    datePicker.hidden=YES;
    toolBar1.hidden=YES;
    orderDatepicker.hidden = YES;
    orderDatepicker1.hidden = YES;
    area_picker.hidden=YES;
    clinic_picker.hidden=YES;
    toolBar.hidden=YES;
     clinic_picker_toolbar.hidden=YES;
    toolBar.hidden=YES;
    if(page==1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if(orderId.length!=0)
        {
            NSIndexPath *indexPath;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
            {
                indexPath=[self.table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
            }
            else
            {
                indexPath=[self.table indexPathForCell:(UITableViewCell *)[[[sender superview] superview]superview]];
            }
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[arr objectAtIndex:indexPath.row];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setValue:@"true" forKey:@"delete"];
            [arr replaceObjectAtIndex:indexPath.row withObject:newDict];
            if([[[arr objectAtIndex:indexPath.row]valueForKey:@"p_id"]isEqualToString:@""])
            {
                page--;
                [arr removeObjectAtIndex:indexPath.row];
            }
        }
        else{
            page--;
            NSIndexPath *indexPath;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
            {
                indexPath=[self.table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
            }
            else
            {
                indexPath=[self.table indexPathForCell:(UITableViewCell *)[[[sender superview] superview]superview]];
            }
            [arr removeObjectAtIndex:indexPath.row];
        }
        //[table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        table.frame=CGRectMake(6, 204, 809, page*116);
        external_scrool.contentSize=CGSizeMake(0, 606+(page*116));
        internal_scroll.frame=CGRectMake(1, table.frame.origin.y+page*120, 809, 248);
        //  submit_button.frame=CGRectMake(699,651-(page*116), 107, 33);
        [table reloadData];
    }
}

- (void)repeatProduct:(id)sender
{
    
    NSLog(@"repeatproductddd");
    //NSIndexPath *indexPath =[self.table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSIndexPath *indexPath;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        indexPath =[self.table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    }
    else
    {
        indexPath =[self.table indexPathForCell:(UITableViewCell *)[[[sender superview] superview]superview ]];
    }
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    UIButton *repeatbtn = (UIButton *)[cell viewWithTag:9];
    
    if(!(repeatbtn.selected==YES))
    {
        repeatbtn.selected=YES;
        NSLog(@"selected");
        Order *order=[[Order alloc]init];
        
        //set Clinic Name value in domain class
        order.product_id = [[arr objectAtIndex:indexPath.row]valueForKey:@"p_id"];
        order.clinic_id=clinicIdValue;
        //Create business manager class object
        OrderManager *ordermanager=[[OrderManager alloc]init];
        NSString *response=[ordermanager RepeatProduct:order];//call businessmanager  method and handle response
        NSLog(@"repeatproduct %@",response);
        //{"BonusQuantity":0,"IsRepeat":false,"OrderQuantity":0,"UnofficialBonus":0}
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[arr objectAtIndex:indexPath.row];
        [newDict addEntriesFromDictionary:oldDict];
        
        NSMutableArray *var =  [response JSONValue];
        
        NSLog(@"REPEAT ORDER QUAN %@",[var valueForKey:@"OrderQuantity"]);
        
        
        //        UITextField *textField = (UITextField *)[cell viewWithTag:5];
        //        textField.text=[NSString stringWithFormat:@"%@",[var valueForKey:@"OrderQuantity"]];
        //        UITextField *textField1 = (UITextField *)[cell viewWithTag:6];
        //        textField1.text=[NSString stringWithFormat:@"%@",[var valueForKey:@"BonusQuantity"]];
        //        UITextField *textField2 = (UITextField *)[cell viewWithTag:7];
        //        textField2.text=[NSString stringWithFormat:@"%@",[var valueForKey:@"UnofficialBonus"]];
        
        NSInteger orderInteger = [[var valueForKey:@"OrderQuantity"]intValue];
        NSString *textfield = [NSString stringWithFormat:@"%d", orderInteger];
        
        NSInteger bonusInteger = [[var valueForKey:@"BonusQuantity"]intValue];
        NSString *textfield1 = [NSString stringWithFormat:@"%d", bonusInteger];
        
        NSInteger unofficialInteger = [[var valueForKey:@"UnofficialBonus"]intValue];
        NSString *textfield2 = [NSString stringWithFormat:@"%d", unofficialInteger];
        
        
        //        UITextField *textField = (UITextField *)[cell viewWithTag:5];
        //        textField.text=[NSString stringWithFormat:@"%d",[[var valueForKey:@"OrderQuantity"]intValue]];
        //        UITextField *textField1 = (UITextField *)[cell viewWithTag:6];
        //        textField1.text=[NSString stringWithFormat:@"%d",[[var valueForKey:@"BonusQuantity"]intValue]];
        //        UITextField *textField2 = (UITextField *)[cell viewWithTag:7];
        //        textField2.text=[NSString stringWithFormat:@"%d",[[var valueForKey:@"UnofficialBonus"]intValue]];
        
        [newDict setValue:textfield forKey:@"order"];
        [newDict setValue:textfield1 forKey:@"bonus"];
        [newDict setValue:textfield2 forKey:@"unofficial"];
        NSLog([[var valueForKey:@"IsRepeat"] boolValue]?@"true":@"false");
        [newDict setValue:[[var valueForKey:@"IsRepeat"]boolValue]?@"1":@"0" forKey:@"isrepeat"];
        
        NSLog(@"arr before %@",arr);
        
        [arr replaceObjectAtIndex:indexPath.row withObject:newDict];
        
        NSLog(@"arr After %@",arr);
    }
    else{
        
        NSLog(@"notselected");
        
        repeatbtn.selected=NO;
    }
    [table reloadData];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //table.frame=CGRectMake(0, 0, 320, 200*page);
    return page;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    UIButton *delete = (UIButton *)[cell viewWithTag:8];
    [delete addTarget:self action:@selector(DeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    if([[[arr objectAtIndex:indexPath.row]valueForKey:@"delete"] isEqualToString:@"false"])
    {
        delete.hidden=NO;
    }
    else{
        delete.hidden=YES;
    }
    UIButton *repeat = (UIButton *)[cell viewWithTag:9];
    [repeat addTarget:self action:@selector(repeatProduct:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *selectProduct=(UITextField *)[cell viewWithTag:1];
    selectProduct.delegate=self;
    
    UITextField *expiryDate=(UITextField *)[cell viewWithTag:3];
    expiryDate.delegate=self;
    expiryDate.inputView = datePicker;
    
    UITextField *batch=(UITextField *)[cell viewWithTag:2];
    batch.delegate=self;
    UITextField *deliveryQty=(UITextField *)[cell viewWithTag:4];
    deliveryQty.delegate=self;
    
    UITextField *orderQty=(UITextField *)[cell viewWithTag:5];
    orderQty.delegate=self;
    
    UITextField *bonusQty=(UITextField *)[cell viewWithTag:6];
    bonusQty.delegate=self;
    
    UITextField *unofficial=(UITextField *)[cell viewWithTag:7];
    unofficial.delegate=self;
    
    UITextField *netprice=(UITextField *)[cell viewWithTag:10];
    netprice.delegate=self;
    
    UIButton *generalPrice=(UIButton*)[cell viewWithTag:12];
    UIButton *netPrice=(UIButton*)[cell viewWithTag:13];
    OT=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] valueForKey:@"OrderType"]];
    [generalPrice setImage:[UIImage imageNamed:@"radiobutton1.png"] forState:UIControlStateSelected];
    [generalPrice setImage:[UIImage imageNamed:@"radiobutton2.png"] forState:UIControlStateNormal];
    [netPrice setImage:[UIImage imageNamed:@"radiobutton1.png"] forState:UIControlStateSelected];
    [netPrice setImage:[UIImage imageNamed:@"radiobutton2.png"] forState:UIControlStateNormal];
    [generalPrice addTarget:self action:@selector(selectGeneralPrice:) forControlEvents:UIControlEventTouchUpInside];
    [netPrice addTarget:self action:@selector(selectNetPrice:) forControlEvents:UIControlEventTouchUpInside];
    if([OT intValue]==2)
    {
        netPrice.selected=NO;
        generalPrice.selected = YES;
        
        netprice.hidden=YES;
        bonusQty.hidden=NO;
        unofficial.hidden=NO;
    }
    else if([OT intValue]==1)
    {
        generalPrice.selected=NO;
        netPrice.selected = YES;
        
        netprice.hidden=NO;
        bonusQty.hidden=YES;
        unofficial.hidden=YES;
    }
    
    generalPrice.userInteractionEnabled=netPrice.userInteractionEnabled=YES;
    
    NSLog(@"index %d",indexPath.row);
    NSLog(@"arr %@ and %@",arr,[[arr objectAtIndex:indexPath.row]valueForKey:@"expiry"]);
    selectProduct.text=[[arr objectAtIndex:indexPath.row]valueForKey:@"p_name"];
    expiryDate.text=[[arr objectAtIndex:indexPath.row]valueForKey:@"expiry"];
    orderQty.text=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row]valueForKey:@"order"]];
    deliveryQty.text=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row]valueForKey:@"delivery"]];
    bonusQty.text=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row]valueForKey:@"bonus"]];
    unofficial.text=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row]valueForKey:@"unofficial"]];
    batch.text=[[arr objectAtIndex:indexPath.row]valueForKey:@"batch"];
    netprice.text=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row]valueForKey:@"netprice"]];
    
    
    NSLog(@" CHECK OT VALUE %@",OT);
    NSLog(@"otot");
    NSLog(@"true/false %@",[[arr objectAtIndex:indexPath.row]valueForKey:@"isrepeat"]);
    if([[[arr objectAtIndex:indexPath.row]valueForKey:@"isrepeat"]boolValue])
    {
        orderQty.enabled=NO;
        bonusQty.enabled=NO;
        unofficial.enabled=NO;
    }
    else{
        orderQty.enabled=YES;
        bonusQty.enabled=YES;
        unofficial.enabled=YES;
    }
    return cell;
}
- (IBAction)selectGeneralPrice:(UIButton *)sender{
    CGPoint buttonOrigin = sender.frame.origin;
    CGPoint pointInTableview = [self.table convertPoint:buttonOrigin fromView:sender.superview];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:pointInTableview];
    NSMutableDictionary *dict = [arr objectAtIndex:indexPath.row];
    [dict removeObjectForKey:@"OrderType"];
    [dict setValue:@"2" forKey:@"OrderType"];
    [arr removeObjectAtIndex:indexPath.row];
    [arr insertObject:dict atIndex:indexPath.row];
    NSLog(@"arr %@",arr);
    [self.table reloadData];
}
- (IBAction)selectNetPrice:(UIButton *)sender{
    CGPoint buttonOrigin = sender.frame.origin;
    CGPoint pointInTableview = [self.table convertPoint:buttonOrigin fromView:sender.superview];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:pointInTableview];
    NSMutableDictionary *dict = [arr objectAtIndex:indexPath.row];
    [dict removeObjectForKey:@"OrderType"];
    [dict setValue:@"1" forKey:@"OrderType"];
    [arr removeObjectAtIndex:indexPath.row];
    [arr insertObject:dict atIndex:indexPath.row];
    NSLog(@"arr1 %@",arr);
    [self.table reloadData];
}
#pragma mark textField methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    toolBar.hidden=YES;
    toolBar1.hidden=YES;
    productPicker.hidden=YES;
    datePicker.hidden=YES;
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)doneBtnPressToGetValue
{
    toolBar.hidden=YES;
    toolBar1.hidden=YES;
    productPicker.hidden=YES;
    datePicker.hidden=YES;
    orderDatepicker.hidden=YES;
    orderDatepicker1.hidden=YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag==1 || textField.tag==3)
    {
        productPicker.hidden=YES;
        datePicker.hidden=YES;
        toolBar1.hidden=YES;
        orderDatepicker.hidden = YES;
        orderDatepicker1.hidden = YES;
        area_picker.hidden=YES;
        clinic_picker.hidden=YES;
        toolBar.hidden=YES;
         clinic_picker_toolbar.hidden=YES;
        toolBar.hidden=NO;
        area_picker_toolbar.hidden  =YES;
        
        
        
        //rowIndex =[self.table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[self.table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        
        else
            
        {
            
            rowIndex =[self.table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
            
        }
        switch (textField.tag) {
            case 1:
                [productPicker setFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y+284+(rowIndex.row)*116, 320, 400)];
                [toolBar setFrame:CGRectMake(textField.frame.origin.x,productPicker.frame.origin.y-42,320, 42)];
                productPicker.hidden=NO;
                [external_scrool bringSubviewToFront:toolBar];
                [external_scrool bringSubviewToFront:productPicker];
                [productPicker reloadAllComponents];
                break;
            case 3:
                datePicker.frame=CGRectMake(textField.frame.origin.x, textField.frame.origin.y+284+(rowIndex.row)*116, 320, 400);
                [toolBar setFrame:CGRectMake(textField.frame.origin.x,datePicker.frame.origin.y-42,320, 42)];
                datePicker.hidden=NO;
                [external_scrool bringSubviewToFront:toolBar];
                [external_scrool bringSubviewToFront:datePicker];
                break;
            default:
                break;
        }
        return NO;
    }
    else
    {
        [textField setInputAccessoryView:toolBar1];
        toolBar1.hidden=NO;
        return YES;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    orderDatepicker.hidden=YES;
    orderDatepicker1.hidden=YES;
    
    NSLog(@"end");
    [textField resignFirstResponder];
    
    
    NSIndexPath *indexPath;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        
        indexPath=[self.table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        
    }
    else
    {
        indexPath =[self.table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
    }
    
    NSLog(@"same");
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDictionary *oldDict = (NSDictionary *)[arr objectAtIndex:indexPath.row];
    [newDict addEntriesFromDictionary:oldDict];
    
    switch (textField.tag)
    {
        case 1:
            [newDict setValue:textField.text forKey:@"p_name"];
            break;
        case 2:
            [newDict setValue:textField.text forKey:@"batch"];
            break;
        case 3:
            [newDict setValue:textField.text forKey:@"expiry"];
            break;
        case 4:
            [newDict setValue:textField.text forKey:@"delivery"];
            break;
        case 5:
            [newDict setValue:textField.text forKey:@"order"];
            break;
        case 6:
            [newDict setValue:textField.text forKey:@"bonus"];
            break;
        case 7:
            [newDict setValue:textField.text forKey:@"unofficial"];
            break;
        case 10:
            [newDict setValue:textField.text forKey:@"netprice"];
            break;
            
        default:
            break;
    }
    [arr replaceObjectAtIndex:indexPath.row withObject:newDict];
    
    
    //[table reloadData];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
    
}
NSString *error=@"no";
-(void)alert_message:(NSString*)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

-(void)alert_message_self:(NSString*)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    neworderlistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"neworder_screen"];
    neworderlistcontroller.view.frame=CGRectMake(0,0, 841, 723);
    
    [neworderlistcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [neworderlistcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    
    [self.view addSubview:neworderlistcontroller.view];
    //return;
}

-(IBAction)submit:(id)sender
{
    error=@"no";
    if([[NSString stringWithFormat:@"%@",orderdatevalue] isEqualToString:@""])
    {
        alert_msg=@"Please select order date";
        [self alert_message:alert_msg];
    }else if([[NSString stringWithFormat:@"%@",clinicIdValue] isEqualToString:@""]){
        alert_msg=@"Please select clinic";
        [self alert_message:alert_msg];
    }
    else if([[NSString stringWithFormat:@"%@",TOD] isEqualToString:@""])
    {    alert_msg=@"Please selct Terms of Delivery";
        [self alert_message:alert_msg];
    }
    else
    {
        NSLog(@"arr.count %@",arr);
        for (int i = 0; i< arr.count; i++)
        {
            
            NSMutableArray *arr1=[arr objectAtIndex:i];
            NSLog(@"1");
            if(arr.count==1 && [[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"p_id"]] isEqualToString:@""])
            {
                error=@"yes";
                arr.count==1?(alert_msg=[NSString stringWithFormat:@"Please select at least one product"]):(alert_msg=[NSString stringWithFormat:@"Please select product name or delete it."]);
                [self alert_message:alert_msg];
                NSLog(@"2");}
            else if([[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"p_id"]] isEqualToString:@""])
            {
                error=@"yes";
                alert_msg=[NSString stringWithFormat:@"Please select product name or delete it."];
                [self alert_message:alert_msg];
                NSLog(@"3");
            }
            else if([[arr1 valueForKey:@"batch"] isEqualToString:@""])
            {
                error=@"yes";
                alert_msg=[NSString stringWithFormat:@"Please fill batch number"];
                [self alert_message:alert_msg];
                NSLog(@"4");}
            else if([[arr1 valueForKey:@"expiry"] isEqualToString:@""])
            {                    error=@"yes";
                alert_msg=[NSString stringWithFormat:@"Please select expiry date"];
                [self alert_message:alert_msg];
                NSLog(@"5");}
            else if([[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"order"]] isEqualToString:@""] || [[arr1 valueForKey:@"order"]intValue] ==0)
            {                    error=@"yes";
                alert_msg=[NSString stringWithFormat:@"Please fill order quantity"];
                [self alert_message:alert_msg];
                NSLog(@"6");}
            else if([[arr1 valueForKey:@"delivery"]intValue]>([[arr1 valueForKey:@"order"]intValue]+[[arr1 valueForKey:@"bonus"]intValue]+[[arr1 valueForKey:@"unofficial"]intValue]))
            {
                error=@"yes";
                alert_msg=[NSString stringWithFormat:@"Delivery quantity for product %@ can not be greater than by Order quantity, Bonus, Unofficialbonus",[arr1 valueForKey:@"p_name"]];
                [self alert_message:alert_msg];
                NSLog(@"7");}
            else if([[arr1 valueForKey:@"stock"]intValue]<([[arr1 valueForKey:@"order"]intValue]+[[arr1 valueForKey:@"bonus"]intValue]+[[arr1 valueForKey:@"unofficial"]intValue]))
            {
                error=@"yes";
                alert_msg=[NSString stringWithFormat:@"Product stock for product %@ is lesser than by Order quantity, Bonus, Unofficialbonus",[arr1 valueForKey:@"p_name"]];                    
                [self alert_message:alert_msg];
                NSLog(@"8");}
            else if([[arr1 valueForKey:@"delivery"]intValue]<([[arr1 valueForKey:@"order"]intValue]+[[arr1 valueForKey:@"bonus"]intValue]+[[arr1 valueForKey:@"unofficial"]intValue]))
            {
                NSLog(@"9 %d and %d ",[[arr1 valueForKey:@"delivery"]intValue],[[arr1 valueForKey:@"order"]intValue]+[[arr1 valueForKey:@"bonus"]intValue]+[[arr1 valueForKey:@"unofficial"]intValue]);
                
                orderStatus=@"Processing";
            }
        }
        
        if([error isEqualToString:@"no"]){
            
            [self displayActivityView];
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
            NSLog(@"OT %@ OS %@ TOD %@",OT,OS,TOD);
            OT=[[NSString stringWithFormat:@"%@",OT] isEqualToString:@"100"]?@"2":@"1";
            NSLog(@"OT %@ OS %@ TOD %@",OT,OS,TOD);
            OS=[[NSString stringWithFormat:@"%@",OS] isEqualToString:@"102"]?@"Personal":[[NSString stringWithFormat:@"%@",OS] isEqualToString:@"108"]?@"Fax Order":@"Clinic Assistant";
            NSLog(@"OT %@ OS %@ TOD %@",OT,OS,TOD);
            TOD=[[NSString stringWithFormat:@"%@",TOD] isEqualToString:@"104"]?@"1":@"2";
            NSMutableString *productid_string = [NSMutableString string];
            [productid_string appendFormat:@""];
            NSMutableString *productid_string1 = [NSMutableString string];
            [productid_string1 appendFormat:@""];
            NSLog(@"arrcount %@ oldarr count %@",arr,old_arr);
            if(arr.count>0)
            {
                //OrderType
//                Old_OrderType
                for (int i = 0; i< arr.count; i++)
                {
                    NSMutableArray *arr1=[arr objectAtIndex:i];
                    if(orderId.length!=0){
                        NSLog(@"editing a existing one %@",arr1);
                        [productid_string appendFormat:@"%d~%d~%@~%@~%@~%@~%@~%@~%@~%@~%@~%@~%@",[[arr1 valueForKey:@"web_p_id"]intValue],[[arr1 valueForKey:@"p_id"]intValue],[arr1 valueForKey:@"batch"],[arr1 valueForKey:@"expiry"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"order"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"order"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"bonus"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"bonus"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"unofficial"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"unofficial"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"delivery"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"delivery"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"netprice"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"netprice"],[arr1 valueForKey:@"OrderType"],[arr1 valueForKey:@"Old_OrderType"],[arr1 valueForKey:@"isrepeat"],[[arr1 valueForKey:@"delete"]boolValue]?@"1":@"0"];
                        NSLog(@"edited striung %@",productid_string);
                    }
                    else{
                        NSLog(@"1aaya isme");
                        [productid_string appendFormat:@"%@~%@~%@~%@~%@~%@~%@~%@~%@~%@",[arr1 valueForKey:@"p_id"],[arr1 valueForKey:@"batch"],[arr1 valueForKey:@"expiry"],[[arr1 valueForKey:@"order"]isEqualToString:@""]?@"0":[arr1 valueForKey:@"order"],[[arr1 valueForKey:@"delivery"]isEqualToString:@""]?@"0":[arr1 valueForKey:@"delivery"],[[arr1 valueForKey:@"bonus"]isEqualToString:@""]?@"0":[arr1 valueForKey:@"bonus"],[[arr1 valueForKey:@"unofficial"]isEqualToString:@""]?@"0":[arr1 valueForKey:@"unofficial"],[[arr1 valueForKey:@"netprice"]isEqualToString:@""]?@"0":[arr1 valueForKey:@"netprice"],[arr1 valueForKey:@"isrepeat"],[arr1 valueForKey:@"OrderType"]];
                        NSLog(@"added string %@",productid_string);
                    }
                    if(i!=[arr count]-1)
                        [productid_string appendString:@","];
                }//id~productid~batchno~exp~orderq~bonus~unoff~deli
                for(int i=0;i<old_arr.count;i++)
                {
                    NSMutableArray *arr1=[old_arr objectAtIndex:i];
                    [productid_string1 appendFormat:@"%d~%d~%@~%@~%@~%@~%@~%@~%@~%@",[[arr1 valueForKey:@"web_p_id"]intValue],[[arr1 valueForKey:@"p_id"]intValue ],[arr1 valueForKey:@"batch"],[arr1 valueForKey:@"expiry"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"order"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"order"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"bonus"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"bonus"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"unofficial"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"unofficial"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"delivery"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"delivery"],[[NSString stringWithFormat:@"%@",[arr1 valueForKey:@"netprice"]]isEqualToString:@""]?@"0":[arr1 valueForKey:@"netprice"],[arr1 valueForKey:@"Old_OrderType"]];
                    NSLog(@"old string %@",productid_string1);
                    if(i!=[old_arr count]-1)
                        [productid_string1 appendString:@","];
                }
            }
                               
                               
            NSMutableDictionary *JsonObject = [NSMutableDictionary new];
            [JsonObject setObject:clinicIdValue forKey:@"ClinicId"];
            [JsonObject setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] forKey:@"StaffId"];
            [JsonObject setObject:orderdatevalue forKey:@"OrderDate"];
            [JsonObject setObject:OS forKey:@"OrderSource"];
            [JsonObject setObject:orderStatus forKey:@"OrderStatus"];
            [JsonObject setObject:comments.text forKey:@"Comments"];
            [JsonObject setObject:deliveryDateValue forKey:@"DeliveryDate"];
            [JsonObject setObject:delivery_note.text forKey:@"DeliveryNote"];
                               [JsonObject setObject:remarks.text forKey:@"iPadRemark"];
            [JsonObject setObject:TOD forKey:@"DeliveryTerm"];
            [JsonObject setObject:OT forKey:@"OrderType"];
            [JsonObject setObject:preferred_time.text forKey:@"PrefDeliveryTime"];
            [JsonObject setObject:invoicereceived forKey:@"InvoiceReturned"];
            [JsonObject setObject:payment_received forKey:@"PaymentReceived"];
            [JsonObject setObject:@"" forKey:@"BuyerOrderDate"];
            [JsonObject setObject:@"" forKey:@"BuyerOrderNo"];
            [JsonObject setObject:productid_string forKey:@"ProductOrder"];
            [JsonObject setObject:productid_string1 forKey:@"ProductOrder1"];
            [self displayActivityView];
            
            NSLog(@"jsonrequest %@",JsonObject);
            OrderManager *orderManager=[[OrderManager alloc]init];
            NSString *response=[orderManager AddOrder:JsonObject];//call businessmanager login method and handle response
            NSMutableArray *var =  [response JSONValue];
            [self removeActivityView];
            if([var valueForKey:@"IsSuccess"])
                [self alert_message_self:orderId.length!=0?@"Order successfully updated.":@"Order successfully added."];
            else
                [self alert_message:orderId.length!=0?@"Order not updated.":@"Order not added."];
            
            NSLog(@" Product List response is %@",response);
            [self removeActivityView];
            });
                               
        }
        else{
            NSLog(@"eror hai");
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    area_picker_toolbar.hidden  =YES;
    toolBar.hidden=YES;
    toolBar1.hidden=YES;
    orderDatepicker.hidden = YES;
    orderDatepicker1.hidden = YES;
    area_picker.hidden=YES;
    clinic_picker.hidden=YES;
    clinic_picker_toolbar.hidden=YES;
    specialization_Picker.hidden=YES;
    [super touchesBegan:touches withEvent:event];
}
-(IBAction)GetDate:(id)sender
{
    NSLog(@"getdate");
    UIButton *btn=(UIButton*)sender;
    toolBar.hidden=NO;
    
    area_picker_toolbar.hidden  =YES;
    
    
    if(btn.tag==97){
        [toolBar setFrame:CGRectMake(btn.frame.origin.x,orderDatepicker.frame.origin.y-42,250, 42)];
        orderDatepicker.hidden = NO;
        orderDatepicker1.hidden=YES;
    }else
    {
        NSLog(@"in 98");
        [toolBar setFrame:CGRectMake(330,orderDatepicker1.frame.origin.y-42,250, 42)];
        orderDatepicker1.hidden=NO;
        orderDatepicker.hidden=YES;
    }
    [external_scrool bringSubviewToFront:toolBar];
    clinic_picker.hidden=YES;
    clinic_picker_toolbar.hidden=YES;
    area_picker.hidden=YES;
    specialization_Picker.hidden=YES;

}
-(IBAction)Get_Location
{
    toolBar.hidden=YES;
    toolBar1.hidden=YES;
    [area_picker reloadAllComponents];
    orderDatepicker.hidden = YES;
    orderDatepicker1.hidden = YES;
    specialization_Picker.hidden=YES;
    clinic_picker.hidden = YES;
    clinic_picker_toolbar.hidden=YES;
    if([area_picker isHidden])
    {
        area_picker.hidden=NO;
        area_picker_toolbar.hidden=NO;
    }
    else
    {
        area_picker.hidden=YES;
        area_picker_toolbar.hidden  =YES;
    }
}
-(IBAction)Get_Specialization
{
    toolBar.hidden=YES;
    toolBar1.hidden=YES;
    [specialization_Picker reloadAllComponents];
    orderDatepicker.hidden = YES;
    orderDatepicker1.hidden = YES;
    clinic_picker_toolbar.hidden=YES;
    clinic_picker_toolbar.hidden=YES;
    clinic_picker.hidden = YES;
    if([specialization_Picker isHidden])
        specialization_Picker.hidden=NO;
    else
        specialization_Picker.hidden=YES;
}
-(IBAction)repeatDeliveryTerm:(UIButton*)sender
{
    if(!(sender.selected==YES))
    {
        repeatDeliveryTerm.selected=YES;
        Order *order=[[Order alloc]init];
        order.clinic_id=clinicIdValue;
        //Create business manager class object
        OrderManager *ordermanager=[[OrderManager alloc]init];
        NSString *response=[ordermanager RepeatDeliveryTerm:order];//call businessmanager  method and handle response
        NSLog(@"repeatproduct %@",response);
        //{"BonusQuantity":0,"IsRepeat":false,"OrderQuantity":0,"UnofficialBonus":0}
        NSMutableArray *var =  [response JSONValue];
        for (UIButton *but in [internal_scroll subviews]) {
            if(but.tag==104 && [[NSString stringWithFormat:@"%d",[[var valueForKey:@"DeliveryTerm"]intValue]] isEqualToString:@"1"]){
                but.selected=YES;
                TOD=[NSString stringWithFormat:@"%d",but.tag];
                for (UIButton *but in [internal_scroll subviews]) {
                    if(but.tag==105)
                    {
                        but.selected=NO;
                        
                    }
                }
            }
            else if(but.tag==105 && [[NSString stringWithFormat:@"%d",[[var valueForKey:@"DeliveryTerm"]intValue]] isEqualToString:@"2"])
            {
                but.selected=YES;
                TOD=[NSString stringWithFormat:@"%d",but.tag];
                for (UIButton *but in [internal_scroll subviews]) {
                    if(but.tag==104)
                    {
                        but.selected=NO;
                    }
                }
            }
        }
        
    }
    else{
        repeatDeliveryTerm.selected=NO;
    }
}
-(IBAction)Get_Clinic
{
    area_picker_toolbar.hidden  =YES;
    toolBar.hidden=YES;
    toolBar1.hidden=YES;
    orderDatepicker.hidden = YES;
    orderDatepicker1.hidden = YES;
    area_picker.hidden=YES;
    specialization_Picker.hidden=YES;
    if(clinicArray.count>0)
    {
        if([clinic_picker isHidden])
        {
            clinic_picker.hidden=NO;
            clinic_picker_toolbar.hidden=NO;
        }
        else
        {
            clinic_picker.hidden=YES;
            clinic_picker_toolbar.hidden=YES;
        }
    }
    else
    {
        if(![[NSString stringWithFormat:@"%@",clinicIdValue] isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"This location has no clinic. Please select another." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select location first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}
-(IBAction)ChangeDateFromLabel:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *datefrom_string = @"   ";
    datefrom_string = [datefrom_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:orderDatepicker.date]]];
    [orderDate setTitle:datefrom_string forState:UIControlStateNormal];
    orderdatevalue = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:orderDatepicker.date]];
    [orderDate setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}
-(IBAction)ChangeDateFromLabel1:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *datefrom_string = @"   ";
    datefrom_string = [datefrom_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:orderDatepicker1.date]]];
    [delivery_date setTitle:datefrom_string forState:UIControlStateNormal];
    deliveryDateValue = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:orderDatepicker1.date]];
    [delivery_date setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
}
- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    area_picker_toolbar.hidden  =YES;
    area_picker.hidden=YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = area_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, area_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}
- (void)pickerViewTapGestureRecognized1:(UITapGestureRecognizer*)gestureRecognizer
{
    clinic_picker.hidden=YES;
    clinic_picker_toolbar.hidden=YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = clinic_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, clinic_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}
- (void)pickerViewTapGestureRecognized2:(UITapGestureRecognizer*)gestureRecognizer
{
    specialization_Picker.hidden=YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = area_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, specialization_Picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}
-(void)dismissKeyboard
{
    orderDatepicker.hidden = YES;
    orderDatepicker1.hidden = YES;
    clinic_picker.hidden = YES;
    area_picker.hidden = YES;
    area_picker_toolbar.hidden  =YES;
    clinic_picker_toolbar.hidden=YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Here we are setting the number of rows in the pickerview to the number of objects of the NSArray. You should understand this since we covered it in the tableview tutorial.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView==area_picker)
    {
        return areaArray.count;
    }
    else if(pickerView==clinic_picker)
    {
        return clinicArray.count;
    }
    else if(pickerView==specialization_Picker)
    {
        return specializationArray.count;
    }
    else if(pickerView==productPicker)
    {
        return productArray.count;
    }
    else{
        return 1;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pickertitle;
    if(pickerView==area_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[areaArray objectAtIndex:row];
        pickertitle=[itemAtIndex objectForKey:@"LocationName"];
    }
    else if(pickerView==clinic_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[clinicArray objectAtIndex:row];
        pickertitle=[itemAtIndex objectForKey:@"ClinicName"];
    }
    else if(pickerView==specialization_Picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[specializationArray objectAtIndex:row];
        pickertitle=[itemAtIndex objectForKey:@"Specialization"];
    }
    else if(pickerView==productPicker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[productArray objectAtIndex:row];
        pickertitle=[itemAtIndex objectForKey:@"ProductName"];
        
    }
    return pickertitle;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView==area_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[areaArray objectAtIndex:row];
        areaidvalue=[itemAtIndex objectForKey:@"LocationId"];
        
        NSString *location_name = @"   ";
        location_name = [location_name stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]];
        area_picker_toolbar.hidden =NO;
        [select_area setTitle:[itemAtIndex objectForKey:@"LocationName"] forState:UIControlStateNormal];
        select_area.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        [select_area setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        area_picker.showsSelectionIndicator = YES;
        area_picker.hidden= NO;
        
        [self getclinicData];
    }
    else if(pickerView==clinic_picker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[clinicArray objectAtIndex:row];
        clinicIdValue=[itemAtIndex objectForKey:@"ClinicId"];
        NSString *clinic_namestring = @"   ";
        clinic_namestring = [clinic_namestring stringByAppendingString:[itemAtIndex objectForKey:@"ClinicName"]];
        [select_clinic setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        [select_clinic setTitle:[itemAtIndex objectForKey:@"ClinicName"] forState:UIControlStateNormal];
        select_clinic.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        clinic_picker.showsSelectionIndicator = YES;
        clinic_picker.hidden= NO;
        clinic_picker_toolbar.hidden=NO;
    }
    else if (pickerView==specialization_Picker){
        NSDictionary *itemAtIndex = (NSDictionary *)[specializationArray objectAtIndex:row];
        areaidvalue=[itemAtIndex objectForKey:@"Id"];
        
        NSString *specialization_name = @"   ";
        specialization_name = [specialization_name stringByAppendingString:[itemAtIndex objectForKey:@"Specialization"]];
        
        [select_specialization setTitle:[itemAtIndex objectForKey:@"Specialization"] forState:UIControlStateNormal];
        select_specialization.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 35);
        [select_specialization setTitleColor:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] forState:UIControlStateNormal];
        specialization_Picker.showsSelectionIndicator = YES;
        specialization_Picker.hidden= NO;
    }
    else if(pickerView==productPicker)
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[productArray objectAtIndex:row];
        productIdValue=[itemAtIndex objectForKey:@"ProductId"];
        NSString *product_namestring = @"   ";
        product_namestring = [product_namestring stringByAppendingString:[itemAtIndex objectForKey:@"ProductName"]];
        
        UITableViewCell *cell = [table cellForRowAtIndexPath:rowIndex];
        UITextField *textField = (UITextField *)[cell viewWithTag:1];
        
        textField.text=[itemAtIndex objectForKey:@"ProductName"];;
        
        //NSIndexPath *indexPath=[self.table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        NSIndexPath *indexPath;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            indexPath=[self.table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
            indexPath =[self.table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
        }
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[arr objectAtIndex:indexPath.row];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setValue:textField.text forKey:@"p_name"];
        [newDict setValue:productIdValue forKey:@"p_id"];
        
        
        Order *order=[[Order alloc]init];
        
        //set Clinic Name value in domain class
        order.product_id = productIdValue;
        
        //Create business manager class object
        OrderManager *ordermanager=[[OrderManager alloc]init];
        NSString *response=[ordermanager GetProductInfo:order];//call businessmanager  method and handle response
        NSLog(@"productresponse %@",response);
        if (response.length !=0)
        {
            NSMutableArray *var =  [response JSONValue];
            UITextField *textField = (UITextField *)[cell viewWithTag:2];
            textField.text=[var valueForKey:@"BatchNumber"];
            UITextField *textField1 = (UITextField *)[cell viewWithTag:3];
            textField1.text=[var valueForKey:@"ExpDate"];
            UITextField *textField2 = (UITextField *)[cell viewWithTag:10];
            textField2.text=[var valueForKey:@"UnitPrice"];
            [newDict setValue:textField.text forKey:@"batch"];
            [newDict setValue:textField1.text forKey:@"expiry"];
            [newDict setValue:textField2.text forKey:@"netprice"];
            UITextField *textField3 = (UITextField *)[cell viewWithTag:4];
            textField3.text=@"";
            UITextField *textField4 = (UITextField *)[cell viewWithTag:5];
            textField4.text=@"";
            UITextField *textField5 = (UITextField *)[cell viewWithTag:6];
            textField5.text=@"";
            UITextField *textField6 = (UITextField *)[cell viewWithTag:7];
            textField6.text=@"";
            [newDict setValue:textField3.text forKey:@"delivery"];
            [newDict setValue:textField4.text forKey:@"order"];
            [newDict setValue:textField5.text forKey:@"bonus"];
            [newDict setValue:textField6.text forKey:@"unofficial"];
            UIButton *repeat = (UIButton *)[cell viewWithTag:9];
            repeat.selected=NO;
            [newDict setValue:@"0" forKey:@"isrepeat"];
            [newDict setValue:[var valueForKey:@"ProductStock"] forKey:@"stock"];
            //rrr   [newDict setValue:[var valueForKey:@"IsRepeat"] forKey:@"isrepeat"];
        }
        
        [arr replaceObjectAtIndex:indexPath.row withObject:newDict];
    }
}


- (IBAction)Back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
