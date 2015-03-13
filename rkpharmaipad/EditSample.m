//
//  EditSample.m
//  RKPharma
//
//  Created by shiv vaishnav on 03/08/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "EditSample.h"
#import "ProductManager.h"
#import "JSON.h"

@interface EditSample ()
{
    IBOutlet UITableView *add_table;
    UITextField *products,*DeliveryQty,*batchNo,*expiryDate;
    UIButton *Delete;
    IBOutlet UIButton *OrderDate,*AddMore, *DeliveryButton;
    IBOutlet UITextView *Remarks;
    
    NSMutableArray *Product_Dictionary;
    int rows;
    IBOutlet UIScrollView *main_scroll;
    RKPharmaAppDelegate *AppDel;
}
@end

@implementation EditSample
@synthesize ProductArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)Back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Samples",@"heading", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
}
- (void)viewDidLoad
{
    AppDel = (RKPharmaAppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"shiv %@",AppDel.SampleDictionary);
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MMM-yyyy"];
    [OrderDate setTitle:[AppDel.SampleDictionary valueForKey:@"RequestedDate"] forState:UIControlStateNormal];
    
    NSDate *tomorrowdate = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    [DeliveryButton setTitle:[df stringFromDate:tomorrowdate] forState:UIControlStateNormal];
    
    Remarks.text = [AppDel.SampleDictionary valueForKey:@"Remarks"];
    SampleRequestDomain *sample_Obj = [SampleRequestDomain new];
    NSString *JsonRequest = [NSString stringWithFormat:@"{\"RequestId\":\"%@\"}",[AppDel.SampleDictionary valueForKey:@"RequestNumber"]];
    sample_Obj.JsonRequest = JsonRequest;
    sample_Obj = [DataModel GetSampleDetail:sample_Obj];
    NSArray *InnerArray = [sample_Obj.dict valueForKey:@"SampleRequestProduct"];
    
    rows = InnerArray.count;
    
    ProductArray = [NSMutableArray new];
    Product_Dictionary = [NSMutableArray arrayWithArray:InnerArray];
    MainArray = [NSMutableArray arrayWithArray:InnerArray];
    MainDictionary = [NSDictionary dictionaryWithDictionary:sample_Obj.dict];
    
    [DeliveryButton setTitle:[MainDictionary valueForKey:@"issue_date"] forState:UIControlStateNormal];
    
    [add_table reloadData];
    
    ProductManager *pm_business=[[ProductManager alloc]init];
    NSString *response=[pm_business GetProductList];
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        
        [ProductArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ProductId",@"All",@"ProductName",nil]];
        for(NSDictionary *product_dictvar in var)
        {
            [ProductArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"ProductId"],@"ProductId",[product_dictvar objectForKey:@"ProductName"],@"ProductName",nil]];
            
        }
    }
    
    [AddMore addTarget:self action:@selector(AddRows:) forControlEvents:UIControlEventTouchUpInside];
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [main_scroll setContentOffset:CGPointMake(0, 250) animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [main_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)getData: (NSDictionary *)dict
{
    passDict = dict;
}
- (void)resignPicker
{
    if (toolbar.tag == 1) {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd-MMM-yyyy"];
        [OrderDate setTitle:[df stringFromDate:[DatePicker date]] forState:UIControlStateNormal];
        
    }
    else if (toolbar.tag == 2)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd-MMM-yyyy"];
        [DeliveryButton setTitle:[df stringFromDate:[DatePicker date]] forState:UIControlStateNormal];
        
    }
    [toolbar removeFromSuperview];
    [DatePicker removeFromSuperview];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    products = (UITextField *)[cell viewWithTag:1];
    products.delegate = self;
    batchNo = (UITextField *)[cell viewWithTag:2];
    expiryDate = (UITextField *)[cell viewWithTag:3];
    DeliveryQty = (UITextField *)[cell viewWithTag:4];
    DeliveryQty.delegate = self;
    Delete = (UIButton *)[cell viewWithTag:5];
    
    batchNo.userInteractionEnabled = NO;
    expiryDate.userInteractionEnabled = NO;
    
    [Delete addTarget:self action:@selector(DeleteCell:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%@",Product_Dictionary);
    if ([[Product_Dictionary objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *ProductInfo = [Product_Dictionary objectAtIndex:indexPath.row];
        NSLog(@"dictionary %@",ProductInfo);
        
        for (NSDictionary *dict in ProductArray) {
            if ([[dict valueForKey:@"ProductId"] intValue] == [[ProductInfo valueForKey:@"ProductId"] intValue]) {
                products.text = [dict valueForKey:@"ProductName"];
                break;
            }
        }
        expiryDate.text = [ProductInfo valueForKey:@"ExpDate"];
        DeliveryQty.text = [ProductInfo valueForKey:@"Quantity"];
        batchNo.text = [ProductInfo valueForKey:@"BatchNum"];
    }
    else
    {
        products.text = @"";
        expiryDate.text = @"";
        DeliveryQty.text = @"";
        batchNo.text = @"";
    }
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
            rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
        }
        
        [Product_Picker removeFromSuperview];
        [Product_Picker_toolbar removeFromSuperview];
        Product_Picker = [[UIPickerView alloc] initWithFrame:CGRectMake(30,235,350,150)];
        Product_Picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        // Product_Picker = [[UIPickerView alloc] initWithFrame:textField.inputView.frame];
        // Product_Picker.backgroundColor=[UIColor whiteColor];
        Product_Picker.delegate = self;
        [self.view addSubview:Product_Picker];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideProductPicker:)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [Product_Picker addGestureRecognizer:gestureRecognizer];
        
        [Product_Picker reloadAllComponents];
        /** picker toolbar code **/
        
        Product_Picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(Product_Picker.frame.origin.x, Product_Picker.frame.origin.y-44,Product_Picker.frame.size.width,30+14)];
        Product_Picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
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
        [Product_Picker_toolbar setItems:barItems2 animated:YES];
        [self.view addSubview:Product_Picker_toolbar];
        return NO;
    }
    return YES;
}
-(IBAction)done_clicked:(id)sender
{
    // UIButton *btn = (UIButton*)sender;
    
    [Product_Picker_toolbar removeFromSuperview];
    [Product_Picker removeFromSuperview];
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 4) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
            rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
        }
        
        if ([[Product_Dictionary objectAtIndex:rowIndex.row] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict1 = [Product_Dictionary objectAtIndex:rowIndex.row];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
            
            NSCharacterSet *nonNumberSet ;
            nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            [dict removeObjectForKey:@"Quantity"];
            [dict setObject:[textField.text stringByAppendingString:[string stringByTrimmingCharactersInSet:nonNumberSet]] forKey:@"Quantity"];
            
            [Product_Dictionary removeObjectAtIndex:rowIndex.row];
            [Product_Dictionary insertObject:dict atIndex:rowIndex.row];
            
            if (range.length == 1){
                return YES;
            }else{
                
                return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select a product first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        
    }
    else
        return YES;
}

- (IBAction)ChangeDate:(UIButton *)sender
{
    [toolbar removeFromSuperview];
    [DatePicker removeFromSuperview];
    if (sender.tag == 1) {
        //Show order date
        CGRect frame = OrderDate.frame;
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 320, 44)];
        toolbar.barStyle=UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
        NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
        [toolbar setItems:itemsArray];
        
        toolbar.tag = 1;
        [main_scroll addSubview:toolbar];
        
        frame = toolbar.frame;
        
        DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 320, 280)];
        DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        //DatePicker.backgroundColor=[UIColor whiteColor];
        DatePicker.date=[NSDate date];
        DatePicker.tag =1;
        DatePicker.datePickerMode=UIDatePickerModeDate;
        
        [DatePicker addTarget:self action:@selector(ChangeOrderDate:) forControlEvents:UIControlEventValueChanged];
        [main_scroll addSubview:DatePicker];
    }
    else
    {
        CGRect frame = DeliveryButton.frame;
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 320, 44)];
        toolbar.barStyle=UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
        NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
        [toolbar setItems:itemsArray];
        
        toolbar.tag = 2;
        [main_scroll addSubview:toolbar];
        
        //Show delivery date
        frame = toolbar.frame;
        
        DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 320, 280)];
        
        DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        DatePicker.date=[NSDate date];
        DatePicker.tag =2;
        DatePicker.datePickerMode=UIDatePickerModeDate;
        
        [DatePicker addTarget:self action:@selector(ChangeDeliveryDate:) forControlEvents:UIControlEventValueChanged];
        [main_scroll addSubview:DatePicker];
    }
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
- (IBAction)ChangeOrderDate:(id)sender
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MMM-yyyy"];
    [OrderDate setTitle:[df stringFromDate:DatePicker.date] forState:UIControlStateNormal];
}
- (IBAction)ChangeDeliveryDate:(id)sender
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MMM-yyyy"];
    [DeliveryButton setTitle:[df stringFromDate:DatePicker.date] forState:UIControlStateNormal];
}
- (void)HideProductPicker:(UITapGestureRecognizer*)gestureRecognizer
{
    Product_Picker.hidden=YES;
    Product_Picker_toolbar.hidden = YES;
}
- (IBAction)Submit:(id)sender
{
    [self displayActivityView];
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       
                       int condition = 0;
                       
                       for (int i = 0; i < rows; i++) {
                           if ([[Product_Dictionary objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                               NSDictionary *dict = [Product_Dictionary objectAtIndex:i];
                               NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:dict];
                               if ([[dict1 objectForKey:@"Quantity"] isEqualToString:@""] || [[dict1 objectForKey:@"Quantity"] stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
                                   condition = 2;
                                   break;
                               }
                           }
                           else
                           {
                               condition = 1;
                               break;
                           }
                       }
                       if (condition == 1) {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter product details." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                           [alert show];
                       }
                       else if (condition == 2)
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter correct quantity." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                           [alert show];
                       }
                       else
                       {
                           NSArray *CopyMainArray = [NSArray arrayWithArray:MainArray];
                           
                           NSMutableArray *AllProductIds = [NSMutableArray new];
                           for (NSDictionary *dict in Product_Dictionary) {
                               NSString *productId = [dict valueForKey:@"ProductId"];
                               [AllProductIds addObject:productId];
                           }
                           
                           for (int i = 0; i < CopyMainArray.count ; i++) {
                               NSMutableDictionary *dict = [CopyMainArray objectAtIndex:i];
                               NSString *productId = [dict valueForKey:@"ProductId"];
                               
                               if ([AllProductIds containsObject:productId]) {
                                   [AllProductIds removeObject:productId];
                                   
                                   
                                   for (int j = 0; j < Product_Dictionary.count; j++) {
                                       NSMutableDictionary *dict1 = [Product_Dictionary objectAtIndex:j];
                                       if ([[dict1 valueForKey:@"ProductId"] intValue] == [productId intValue]) {
                                           [dict1 setObject:@"false" forKey:@"delete"];
                                           [dict1 setObject:[dict valueForKey:@"Id"] forKey:@"Id"];
                                           [MainArray removeObjectAtIndex:i];
                                           [MainArray insertObject:dict1 atIndex:i];
                                           break;
                                       }
                                   }
                                   
                               }
                               else
                               {
                                   [dict setObject:@"true" forKey:@"delete"];
                                   [MainArray removeObjectAtIndex:i];
                                   [MainArray insertObject:dict atIndex:i];
                               }
                               
                           }
                           
                           for (int i = 0; i < AllProductIds.count; i++) {
                               for (NSMutableDictionary *dict in Product_Dictionary) {
                                   NSString *productid = [dict valueForKey:@"ProductId"];
                                   if ([productid intValue] == [[AllProductIds objectAtIndex:i] intValue]) {
                                       [dict setValue:@"false" forKey:@"delete"];
                                       [dict setValue:@"0" forKey:@"Id"];
                                       [MainArray addObject:dict];
                                       break;
                                   }
                               }
                           }
                           NSLog(@"main array %@",MainArray);
                           NSLog(@"second array %@",Product_Dictionary);
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           NSString *productString=@"";
                           for (int i = 0; i < MainArray.count; i++) {
                               NSDictionary *dict = [MainArray objectAtIndex:i];
                               NSString *delete=[dict valueForKey:@"delete"];
                               if ([delete isEqualToString:@"true"]) {
                                   delete=@"1";
                               }
                               else
                               {
                                   delete=@"0";
                               }
                               productString = [productString stringByAppendingFormat:@"%@~%@~%@~%@~%@~%@~%@,",[dict valueForKey:@"Id"],[AppDel.SampleDictionary valueForKey:@"RequestNumber"],[dict valueForKey:@"ProductId"],[dict valueForKey:@"BatchNum"],[dict valueForKey:@"ExpDate"],[dict valueForKey:@"Quantity"],delete];
                           }
                           NSLog(@"productstring %@",productString);
                           if ( [productString length] > 0)
                               productString = [productString substringToIndex:[productString length] - 1];
                           
                           SampleRequestDomain *sample_Obj = [SampleRequestDomain new];
                           NSString *JsonRequest = [NSString stringWithFormat:@"{\"Id\":\"%@\",\"UserId\":\"%@\",\"RequestDate\":\"%@\",\"Remarks\":\"%@\",\"IssueDate\":\"%@\",\"IsIssued\":\"%@\",\"SampleRequestProduct\":\"%@\"}",[AppDel.SampleDictionary valueForKey:@"RequestNumber"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],OrderDate.titleLabel.text,Remarks.text,DeliveryButton.titleLabel.text,[AppDel.SampleDictionary valueForKey:@"Issued"],productString];
                           NSLog(@"json request %@",JsonRequest);
                           //UpdateSampleRequest
                           sample_Obj.JsonRequest = JsonRequest;
                           sample_Obj = [DataModel EditSample:sample_Obj];
                           
                           if ([sample_Obj.response isEqualToString:@"true"]) {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Successfully added." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                               alert.tag = 1;
                               [alert show];
                               
                               
                               
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to add sample request at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                               [alert show];
                               
                           }
                           
                       }
                       [self removeActivityView];
                   });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Sample Request",@"heading", nil]];
        [self.view removeFromSuperview];
    }
}

- (IBAction)DeleteCell:(UIButton *)sender
{
    //NSIndexPath *indexPath =[add_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:add_table];
    NSIndexPath *indexPath = [add_table indexPathForRowAtPoint:rootViewPoint];
    
    NSUInteger row = indexPath.row;
    [Product_Dictionary removeObjectAtIndex:row];
    --rows;
    [add_table reloadData];
}
- (IBAction)AddRows:(id)sender
{
    ++rows;
    [Product_Dictionary addObject:@""];
    [add_table reloadData];
}

#pragma mark - picker view delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Here we are setting the number of rows in the pickerview to the number of objects of the NSArray. You should understand this since we covered it in the tableview tutorial.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ProductArray.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *itemAtIndex = (NSDictionary *)[ProductArray objectAtIndex:row];
    return [itemAtIndex objectForKey:@"ProductName"];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDictionary *itemAtIndex = (NSDictionary *)[ProductArray objectAtIndex:row];
    NSString* productIdValue=[itemAtIndex objectForKey:@"ProductId"];
    NSString *product_namestring = @"   ";
    product_namestring = [product_namestring stringByAppendingString:[itemAtIndex objectForKey:@"ProductName"]];
    
    Order *order=[[Order alloc]init];
    
    //set Clinic Name value in domain class
    order.product_id = productIdValue;
    
    //Create business manager class object
    OrderManager *ordermanager=[[OrderManager alloc]init];
    NSString *response=[ordermanager GetProductInfo:order];//call businessmanager  method and handle response
    NSLog(@"productresponse %@",response);
    if (response.length !=0)
    {
        NSDictionary *ProductInfo = [response JSONValue];
        [Product_Dictionary removeObjectAtIndex:rowIndex.row];
        [Product_Dictionary insertObject:[NSDictionary dictionaryWithObjectsAndKeys:productIdValue,@"ProductId",[itemAtIndex objectForKey:@"ProductName"],@"ProductName",[ProductInfo valueForKey:@"BatchNumber"],@"BatchNum",[ProductInfo valueForKey:@"ExpDate"],@"ExpDate",@"",@"Quantity", nil] atIndex:rowIndex.row];
        [add_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:rowIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
