//
//  AddSample.m
//  RKPharma
//
//  Created by shiv vaishnav on 02/08/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "AddSample.h"
#import "ProductManager.h"
#import "JSON.h"
#import "CustomTextField.h"

@interface AddSample ()
{
    IBOutlet UITableView *add_table;
    UITextField *batchNo,*expiryDate;
   // UITextField *products,*DeliveryQty;
    UIButton *Delete;
    IBOutlet UIButton *OrderDate,*AddMore, *DeliveryButton;
    IBOutlet UITextView *Remarks;
    
    NSMutableArray *ProductArray;
    NSMutableArray *Product_Dictionary;
    int rows;
    IBOutlet UIScrollView *main_scroll;
}
@end

@implementation AddSample
@synthesize toolbar,toolbar1,toolbar_product,Product_Picker_toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MMM-yyyy"];
    [OrderDate setTitle:[df stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    
    NSDate *tomorrowdate = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    NSLog(@"tomorwo date %@",tomorrowdate);
    
    [DeliveryButton setTitle:[df stringFromDate:tomorrowdate] forState:UIControlStateNormal];
    OrderDate.hidden=YES;
    DeliveryButton.hidden=YES;
    rows = 2;
    ProductArray = [NSMutableArray new];
    Product_Dictionary = [NSMutableArray new];
    [Product_Dictionary addObject:@""];
    [Product_Dictionary addObject:@""];
    
    ProductManager *pm_business=[[ProductManager alloc]init];
    NSString *response=[pm_business GetProductList];
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Product List%@",var);
        
        [ProductArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ProductId",@" All",@"ProductName",nil]];
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
    Product_Picker_toolbar.hidden = YES;
    Product_Picker.hidden = YES;
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
    
   CustomTextField *products = (CustomTextField *)[cell viewWithTag:1];
    products.delegate = self;
    products.Tag1 = (int)indexPath.row;

    batchNo = (UITextField *)[cell viewWithTag:2];
    expiryDate = (UITextField *)[cell viewWithTag:3];
    
    CustomTextField *DeliveryQty = (CustomTextField *)[cell viewWithTag:4];
    DeliveryQty.delegate = self;
    DeliveryQty.Tag1 = (int)indexPath.row;
    
    
    
    Delete = (UIButton *)[cell viewWithTag:5];
    
    batchNo.userInteractionEnabled = NO;
    expiryDate.userInteractionEnabled = NO;
    
    [Delete addTarget:self action:@selector(DeleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[Product_Dictionary objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *ProductInfo = [Product_Dictionary objectAtIndex:indexPath.row];
        NSLog(@"dictionary %@",ProductInfo);
        products.text = [ProductInfo valueForKey:@"productname"];
        expiryDate.text = [ProductInfo valueForKey:@"expdate"];
        DeliveryQty.text = [ProductInfo valueForKey:@"quantity"];
        batchNo.text = [ProductInfo valueForKey:@"batch"];
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
- (IBAction)Back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Samples",@"heading", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [main_scroll setContentOffset:CGPointMake(0, 250) animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [main_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    //keyboard will hide
    [main_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}



- (BOOL)textFieldShouldBeginEditing:(CustomTextField *)textField
{
    if (textField.tag == 1) {
        //rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        
        else
            
        {
            
         //   rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
            
            NSLog(@"%d",textField.Tag1);
            rowIndex =[NSIndexPath indexPathForRow:textField.Tag1 inSection:0];
            
        }
        [Product_Picker removeFromSuperview];
        [Product_Picker_toolbar removeFromSuperview];
        
        if(rowIndex.row<2)
            Product_Picker = [[UIPickerView alloc] initWithFrame: CGRectMake(textField.frame.origin.x+10,(textField.frame.origin.y+180+(rowIndex.row)*116)+44,250,150)];
        else
            Product_Picker = [[UIPickerView alloc] initWithFrame: CGRectMake(textField.frame.origin.x+10,(textField.frame.origin.y+180+1*116)+44,250,150)];
        
        Product_Picker.delegate = self;
        [self.view addSubview:Product_Picker];
        //[textField setInputAccessoryView:[self accessoryView]];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideProductPicker:)];
        gestureRecognizer.cancelsTouchesInView = NO;
        
        [Product_Picker addGestureRecognizer:gestureRecognizer];
        Product_Picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        [Product_Picker reloadAllComponents];
        Product_Picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(Product_Picker.frame.origin.x, Product_Picker.frame.origin.y-44,Product_Picker.frame.size.width,30+14)];
        //[location_picker_toolbar sizeToFit];
        Product_Picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
        /************** toolbar custmzation *************/
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems addObject:flexSpace];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
        
        [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
        [barItems addObject:doneBtn];
        [Product_Picker_toolbar setItems:barItems animated:YES];
        [self.view addSubview:Product_Picker_toolbar];
        /**********************/
        
        return NO;
    }
    return YES;
}
- (BOOL)textField:(CustomTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 4) {
        //rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        
        else
            
        {
            
            //rowIndex =[add_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
            
            NSLog(@"%d",textField.Tag1);
            rowIndex =[NSIndexPath indexPathForRow:textField.Tag1 inSection:0];

            
        }
        if ([[Product_Dictionary objectAtIndex:rowIndex.row] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict1 = [Product_Dictionary objectAtIndex:rowIndex.row];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
            
            NSCharacterSet *nonNumberSet ;
            nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            [dict removeObjectForKey:@"quantity"];
            [dict setObject:[textField.text stringByAppendingString:[string stringByTrimmingCharactersInSet:nonNumberSet]] forKey:@"quantity"];
            
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
        NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems2 addObject:flexSpace2];
        
        
        [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
        [barItems2 addObject:doneButton];
        [toolbar setItems:barItems2];
        toolbar.tag = 1;
        [main_scroll addSubview:toolbar];
        
        frame = toolbar.frame;
        
        DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 320, 280)];
        DatePicker.date=[NSDate date];
        DatePicker.tag =1;
        DatePicker.datePickerMode=UIDatePickerModeDate;
        
        [DatePicker addTarget:self action:@selector(ChangeOrderDate:) forControlEvents:UIControlEventValueChanged];
        DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        [main_scroll addSubview:DatePicker];
    }
    else
    {
        CGRect frame = DeliveryButton.frame;
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 320, 44)];
        toolbar.barStyle=UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
        NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems2 addObject:flexSpace2];
        
        
        [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
        [barItems2 addObject:doneButton];
        [toolbar setItems:barItems2];
        
        toolbar.tag = 2;
        [main_scroll addSubview:toolbar];
        
        //Show delivery date
        frame = toolbar.frame;
        
        DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 320, 280)];
        DatePicker.date=[NSDate date];
        DatePicker.tag =2;
        DatePicker.datePickerMode=UIDatePickerModeDate;
        DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        [DatePicker addTarget:self action:@selector(ChangeDeliveryDate:) forControlEvents:UIControlEventValueChanged];
        DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
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
    Product_Picker_toolbar.hidden =YES;
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
                               if ([[dict1 objectForKey:@"quantity"] isEqualToString:@""] || [[dict1 objectForKey:@"quantity"] stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
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
                           NSString *productString=@"";
                           for (int i = 0; i < rows; i++) {
                               NSDictionary *dict = [Product_Dictionary objectAtIndex:i];
                               productString = [productString stringByAppendingFormat:@"%@~%@~%@~%@,",[dict valueForKey:@"id"],[dict valueForKey:@"batch"],[dict valueForKey:@"expdate"],[dict valueForKey:@"quantity"]];
                           }
                           if ( [productString length] > 0)
                               productString = [productString substringToIndex:[productString length] - 1];
                           
                           SampleRequestDomain *sample_Obj = [SampleRequestDomain new];
                           NSString *JsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"RequestDate\":\"%@\",\"Remarks\":\"%@\",\"IssueDate\":\"%@\",\"SampleRequestProduct\":\"%@\"}",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],OrderDate.titleLabel.text,Remarks.text,DeliveryButton.titleLabel.text,productString];
                           sample_Obj.JsonRequest = JsonRequest;
                           sample_Obj = [DataModel AddSample:sample_Obj];
                           
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Sample Request",@"heading", nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil)
    {
        //label size
        CGRect frame = CGRectMake(10.0, 0.0, 250, 150);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:13.0]];
        
    }
    
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[ProductArray objectAtIndex:row];
    
    NSString *product_namestring = @"   ";
    product_namestring = [product_namestring stringByAppendingString:[itemAtIndex objectForKey:@"ProductName"]];
    
    //picker view array is the datasource
    [pickerLabel setText:product_namestring];
    
    return pickerLabel;
    
}

//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSDictionary *itemAtIndex = (NSDictionary *)[ProductArray objectAtIndex:row];
//    return [itemAtIndex objectForKey:@"ProductName"];
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDictionary *itemAtIndex = (NSDictionary *)[ProductArray objectAtIndex:row];
    NSString* productIdValue=[itemAtIndex objectForKey:@"ProductId"];
    NSString *product_namestring = @"   ";
    product_namestring = [product_namestring stringByAppendingString:[itemAtIndex objectForKey:@"ProductName"]];
    
    //UITableViewCell *cell = [add_table cellForRowAtIndexPath:rowIndex];
    // UITextField *textField = (UITextField *)[cell viewWithTag:1];
    
    //textField.text=[itemAtIndex objectForKey:@"ProductName"];;
    
    
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
        NSLog(@"Batch Number %@",[ProductInfo valueForKey:@"BatchNumber"]);
        NSLog(@"ExpDate %@",[ProductInfo valueForKey:@"ExpDate"]);
        [Product_Dictionary removeObjectAtIndex:rowIndex.row];
        [Product_Dictionary insertObject:[NSDictionary dictionaryWithObjectsAndKeys:productIdValue,@"id",[itemAtIndex objectForKey:@"ProductName"],@"productname",[ProductInfo valueForKey:@"BatchNumber"],@"batch",[ProductInfo valueForKey:@"ExpDate"],@"expdate",@"",@"quantity", nil] atIndex:rowIndex.row];
        [add_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:rowIndex] withRowAnimation:UITableViewRowAnimationNone];
        //[add_table reloadSections:[NSIndexSet indexSetWithIndex:rowIndex.row] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[add_table reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
