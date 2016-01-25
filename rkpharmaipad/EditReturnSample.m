//
//  EditReturnSample.m
//  RKPharma
//
//  Created by Shiven on 9/17/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "EditReturnSample.h"
#import "ProductManager.h"
#import "Product.h"
#import "DailyPlanManager.h"
#import "DailyPlan.h"
#import "JSON.h"
#import "RKPharmaAppDelegate.h"

@interface EditReturnSample ()
{
    IBOutlet UITableView *returnsample_table;
    UITextField *return_products,*returnQty,*BatchNo,*ExpDate,*monthyear;
    UIButton *Delete;
    IBOutlet UIButton *AddMore;
    
    NSMutableArray *ProductArray;
    NSMutableArray *Product_Dictionary;
    int rows;
    RKPharmaAppDelegate *AppDel;
}
@end

@implementation EditReturnSample

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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    ProductArray = [NSMutableArray new];
    
    Product_Dictionary = [[NSMutableArray alloc]init];
    
    AppDel = (RKPharmaAppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"Shiven %@",AppDel.SampleId);
    
    //Create domain class object
    Product *product=[[Product alloc]init];
    
    product.sampleid = AppDel.SampleId;
    
    //Create business manager class object
    ProductManager *pm_business=[[ProductManager alloc]init];
    NSString *response=[pm_business GetSampleDetails:product];//call businessmanager login method and handle response
    NSLog(@" Sample Return Details response is %@",response);
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Sample Return List%@",var);
        
        NSLog(@" ABOVE ww %@",[var objectForKey:@"SampleName"]);
        //for(NSDictionary *dictvar in var)
        //{
        NSLog(@" ABOVE %@",[var objectForKey:@"SampleName"]);
        //NSLog(@" SAMPLE DETAIL %@",[dictvar objectForKey:@"SampleName"]);
        [Product_Dictionary addObject:[NSDictionary dictionaryWithObjectsAndKeys:[var objectForKey:@"SampleId"],@"SampleId",[var objectForKey:@"SampleName"],@"SampleName",[var objectForKey:@"Unit"],@"Unit",[var objectForKey:@"Quantity"],@"Quantity",[var objectForKey:@"BatchNo"],@"BatchNo",[var objectForKey:@"ExpiryDate"],@"ExpiryDate",[var objectForKey:@"ReturnedQuantity"],@"ReturnedQuantity",[var objectForKey:@"ReturnDate"],@"ReturnDate",[var objectForKey:@"IssueMonth"],@"IssueMonth",[var objectForKey:@"IsAccepted"],@"IsAccepted",nil]];
        
        //}
    }
    
    NSLog(@" Main Array %d",Product_Dictionary.count);
}

#pragma TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Product_Dictionary.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    
    return_products = (UITextField *)[cell viewWithTag:2];
    monthyear = (UITextField *)[cell viewWithTag:1];
    BatchNo = (UITextField *)[cell viewWithTag:3];
    ExpDate = (UITextField *)[cell viewWithTag:4];
    returnQty = (UITextField *)[cell viewWithTag:5];
    
    monthyear.delegate = self;
    return_products.delegate = self;
    returnQty.delegate = self;
    
    BatchNo.userInteractionEnabled = NO;
    ExpDate.userInteractionEnabled = NO;
    return_products.userInteractionEnabled = NO;
    monthyear.userInteractionEnabled = NO;
    
    if ([[Product_Dictionary objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *ProductInfo = [Product_Dictionary objectAtIndex:indexPath.row];
        NSLog(@"dictionary %@",ProductInfo);
        return_products.text = [ProductInfo valueForKey:@"SampleName"];
        ExpDate.text = [ProductInfo valueForKey:@"ExpiryDate"];
        returnQty.text = [ProductInfo valueForKey:@"ReturnedQuantity"];
        BatchNo.text = [ProductInfo valueForKey:@"BatchNo"];
        monthyear.text = [ProductInfo valueForKey:@"IssueMonth"];
    }
    else
    {
        return_products.text = @"";
        ExpDate.text = @"";
        returnQty.text = @"";
        BatchNo.text = @"";
        monthyear.text = @"";
    }
    
    //Delete = (UIButton *)[cell viewWithTag:7];
    
    
    //[Delete addTarget:self action:@selector(DeleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

- (IBAction)DeleteCell:(id)sender
{
    NSLog(@"ROWSSS %d",rows);
    if(rows>1)
    {
        NSIndexPath *indexPath =[returnsample_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        NSUInteger row = indexPath.row;
        [Product_Dictionary removeObjectAtIndex:row];
        --rows;
        [returnsample_table reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You cannot delete this row" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
        [alert show];
    }
}
- (IBAction)AddRows:(id)sender
{
    ++rows;
    [Product_Dictionary addObject:@""];
    [returnsample_table reloadData];
}

- (void)HideDateLabel
{
    NSLog(@" ROW INDEX %d",rowIndex.row);
    [toolbar_date removeFromSuperview];
    [DatePicker removeFromSuperview];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"MMM-yyyy"];
    NSString *dateto_string = @"";
    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:DatePicker.date]]];
    NSLog(@"DatePicker%@",dateto_string);
    
    
    [Product_Dictionary removeObjectAtIndex:rowIndex.row];
    [Product_Dictionary insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"SampleId",@"",@"SampleName",@"",@"BatchNo",@"",@"ExpiryDate",@"",@"ReturnedQuantity",@"",@"AvailableQty",@"",@"ReturnDate",dateto_string,@"IssueMonth", nil] atIndex:rowIndex.row];
    
    NSLog(@" PDDD %@",Product_Dictionary);
    
    [returnsample_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:rowIndex] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)HideProductPicker:(UITapGestureRecognizer*)gestureRecognizer
{
    Product_Picker.hidden=YES;
}

- (IBAction)SelectDateLabel:(id)sender
{
    NSLog(@" ROW INDEX %d",rowIndex.row);
    
    NSLog(@"Check Hide");
}

- (IBAction)Back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Return Sample List",@"heading", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Return Sample List",@"heading", nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
        [self.view removeFromSuperview];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
        }
        
        
        [toolbar_date removeFromSuperview];
        [DatePicker removeFromSuperview];
        
        
        toolbar_date = [[UIToolbar alloc] initWithFrame:CGRectMake(10, 386, 250, 50)];
        toolbar_date.barStyle=UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(HideDateLabel)];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems addObject:flexSpace];
        
        [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
        [barItems addObject:doneButton];
        [toolbar_date setItems:barItems];
        
        toolbar_date.tag = 1;
        [self.view addSubview:toolbar_date];
        
        // To create datepickers
        DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(textField.frame.origin.x+400,textField.frame.origin.y+200,250,150)];
        DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        DatePicker.datePickerMode = UIDatePickerModeDate;
        DatePicker.date = [NSDate date];
        [DatePicker addTarget:self action:@selector(SelectDateLabel:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:DatePicker];
        DatePicker.hidden = NO;
        DatePicker.maximumDate = [NSDate date];
        
        
        return NO;
    }
    else if(textField.tag == 2)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
        }
        
        NSLog(@" ROW INDEX %d",rowIndex.row);
        UITableViewCell *cell = [returnsample_table cellForRowAtIndexPath:rowIndex];
        UITextField *textField = (UITextField *)[cell viewWithTag:1];
        
        NSLog(@"Textfield 2 %@",textField.text);
        
        NSLog(@"Textfield 2 Length %d",[textField.text length]);
        
        if([textField.text length]>0)
        {
            NSArray* foo = [textField.text componentsSeparatedByString: @"-"];
            NSString* month = [foo objectAtIndex: 0];
            NSString* year = [foo objectAtIndex: 1];
            
            NSString *dateStr = month;
            
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMM"];
            NSDate *date = [dateFormat dateFromString:dateStr];
            
            NSDateFormatter *dateformattermonth = [[NSDateFormatter alloc] init];
            [dateformattermonth setDateStyle:NSDateFormatterShortStyle];
            [dateformattermonth setTimeStyle:NSDateFormatterNoStyle];
            [dateformattermonth setDateFormat:@"MM"];
            NSString *datetomonth_string = @"";
            datetomonth_string = [datetomonth_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformattermonth stringFromDate:date]]];
            NSLog(@"DatePicker Month%@",datetomonth_string);
            
            
            DailyPlan *dailyplan=[[DailyPlan alloc]init];
            
            //set Clinic Name value in domain class
            dailyplan.month = datetomonth_string;
            dailyplan.year = year;
            
            //Create business manager class object
            DailyPlanManager *dailyplanmanager=[[DailyPlanManager alloc]init];
            NSString *response=[dailyplanmanager GetSamples:dailyplan];//call businessmanager  method and handle response
            NSLog(@"Sample Response %@",response);
            if (response.length !=0)
            {
                [ProductArray removeAllObjects];
                NSDictionary *var =  [response JSONValue];
                NSLog(@"dict Sample List%@",var);
                for(NSDictionary *product_dictvar in var)
                {
                    NSLog(@" PRODUCT QUANTITY %@",[product_dictvar objectForKey:@"Quantity"]);
                    [ProductArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"SampleId"],@"SampleId",[product_dictvar objectForKey:@"SampleName"],@"SampleName",[product_dictvar objectForKey:@"Unit"],@"Unit",[product_dictvar objectForKey:@"Quantity"],@"AvailableQty",[product_dictvar objectForKey:@"BatchNo"],@"BatchNo",[product_dictvar objectForKey:@"ExpiryDate"],@"ExpiryDate",nil]];
                    
                }
            }
            
            NSLog(@"Product COUNT %d",ProductArray.count);
            
            
            [Product_Picker removeFromSuperview];
            Product_Picker = [[UIPickerView alloc] initWithFrame: CGRectMake(10,430,250,150)];
            Product_Picker.delegate = self;
            [self.view addSubview:Product_Picker];
            //[textField setInputAccessoryView:[self accessoryView]];
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideProductPicker:)];
            gestureRecognizer.cancelsTouchesInView = NO;
            [Product_Picker addGestureRecognizer:gestureRecognizer];
            
            [Product_Picker reloadAllComponents];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select month/year first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
            [alert show];
        }
        return NO;
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"TeFe");
    if (textField.tag == 5)
    {
        NSLog(@"TExtfield 5");
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
        }
        
        if ([[Product_Dictionary objectAtIndex:rowIndex.row] isKindOfClass:[NSDictionary class]])
        {
            
            NSDictionary *dict1 = [Product_Dictionary objectAtIndex:rowIndex.row];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
            
            NSCharacterSet *nonNumberSet ;
            nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            
            [dict removeObjectForKey:@"ReturnedQuantity"];
            [dict setObject:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"ReturnedQuantity"];
            
            NSLog(@" RETQQQT%@",[textField.text stringByReplacingCharactersInRange:range withString:string] );
            [Product_Dictionary removeObjectAtIndex:rowIndex.row];
            [Product_Dictionary insertObject:dict atIndex:rowIndex.row];
            
            if (range.length == 1)
            {
                return YES;
            }
            else
            {
                return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select a Sample first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        
    }
    else
        return YES;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [[event allTouches] anyObject];
    Product_Picker.hidden = YES;
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)Submit:(id)sender
{
    [self displayActivityView];
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       
                       int condition = 0;
                       
                       //for (int i = 0; i < rows; i++)
                       //{
                           if ([[Product_Dictionary objectAtIndex:0] isKindOfClass:[NSDictionary class]])
                           {
                               NSDictionary *dict = [Product_Dictionary objectAtIndex:0];
                               NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:dict];
                               NSLog(@" RETURN DICT %@",[dict1 objectForKey:@"ReturnedQuantity"]);
                               NSLog(@" Available DICT %@",[dict1 objectForKey:@"Quantity"]);
                               if ([[dict1 objectForKey:@"ReturnedQuantity"] isEqualToString:@""] || [[dict1 objectForKey:@"ReturnedQuantity"] length] == 0)
                               {
                                   condition = 2;
                                   //break;
                               }
                               else if([[dict1 objectForKey:@"Quantity"] integerValue] < [[dict1 objectForKey:@"ReturnedQuantity"] integerValue])
                               {
                                   condition = 3;
                                   //break;
                               }
                               
                           }
                           else
                           {
                               condition = 1;
                               //break;
                           }
                       //}
                       if (condition == 1) {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter Sample return details." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                           [alert show];
                       }
                       else if (condition == 2)
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter correct return quantity or return date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                           [alert show];
                       }
                       else if (condition == 3)
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Return Quantity should be less than available quantity" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                           [alert show];
                       }
                       else
                       {
//                           NSString *productString=@"";
//                           for (int i = 0; i < rows; i++) {
//                               NSDictionary *dict = [Product_Dictionary objectAtIndex:i];
//                               productString = [productString stringByAppendingFormat:@"%@~%@~%@,",[dict valueForKey:@"SampleId"],[dict valueForKey:@"returnQty"],[dict valueForKey:@"returnDate"]];
//                           }
//                           
//                           if ( [productString length] > 0)
//                               productString = [productString substringToIndex:[productString length] - 1];
                           NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                           [dateformatter setDateStyle:NSDateFormatterShortStyle];
                           [dateformatter setTimeStyle:NSDateFormatterNoStyle];
                           [dateformatter setDateFormat:@"dd-MMM-yyyy"];
                           NSString *dateto_string = @"";
                           dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:[NSDate date]]]];
                           
                           NSDictionary *dict = [Product_Dictionary objectAtIndex:0];
                           
                           SampleRequestDomain *sample_Obj = [SampleRequestDomain new];
                           NSString *JsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"SampleId\":\"%d\",\"Qauntity\":\"%@\",\"ReturnDate\":\"%@\"}",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],[[dict valueForKey:@"SampleId"] integerValue],[dict valueForKey:@"ReturnedQuantity"],dateto_string];
                           sample_Obj.JsonRequest = JsonRequest;
                           sample_Obj = [DataModel EditReturnSample:sample_Obj];
                           
                           if ([sample_Obj.response isEqualToString:@"true"]) {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Successfully Updated." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                               alert.tag = 1;
                               [alert show];
                               
                               
                               
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to return sample at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
                               [alert show];
                               
                           }
                           
                       }
                       
                       //NSLog(@" PRODUCT STRING %@",productString);
                       
                       [self removeActivityView];
                   });
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
    return [itemAtIndex objectForKey:@"SampleName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDictionary *itemAtIndex = (NSDictionary *)[ProductArray objectAtIndex:row];
    NSLog(@"ITEM AT INDEX %@",itemAtIndex);
    //NSString* productIdValue=[itemAtIndex objectForKey:@"SampleId"];
    NSString *product_namestring = @"   ";
    product_namestring = [product_namestring stringByAppendingString:[itemAtIndex objectForKey:@"SampleName"]];
    
    UITableViewCell *cell = [returnsample_table cellForRowAtIndexPath:rowIndex];
    
    UITextField *monthyeartextField = (UITextField *)[cell viewWithTag:1];
    
    UITextField *textField = (UITextField *)[cell viewWithTag:2];
    textField.text=[itemAtIndex objectForKey:@"SampleName"];
    
    
    UITextField *BatchtextField = (UITextField *)[cell viewWithTag:3];
    BatchtextField.text=[itemAtIndex objectForKey:@"BatchNo"];
    
    UITextField *ExpiryDatetextField = (UITextField *)[cell viewWithTag:4];
    ExpiryDatetextField.text=[itemAtIndex objectForKey:@"ExpiryDate"];
    
    UITextField *returnqtytextField = (UITextField *)[cell viewWithTag:5];
    
   // UITextField *returndatetextField = (UITextField *)[cell viewWithTag:6];
    
    //    UITextField *ReturnQtytextField = (UITextField *)[cell viewWithTag:5];
    //    ReturnQtytextField.text=[itemAtIndex objectForKey:@"Quantity"];
    //
    //    UITextField *ReturnDatetextField = (UITextField *)[cell viewWithTag:6];
    //    ReturnDatetextField.text=[itemAtIndex objectForKey:@"SampleName"];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateto_string = @"";
    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:[NSDate date]]]];
    
    Product_Picker.showsSelectionIndicator = YES;
    
    [Product_Dictionary removeObjectAtIndex:rowIndex.row];
    [Product_Dictionary insertObject:[NSDictionary dictionaryWithObjectsAndKeys:[itemAtIndex objectForKey:@"SampleId"],@"SampleId",[itemAtIndex objectForKey:@"SampleName"],@"SampleName",[itemAtIndex objectForKey:@"BatchNo"],@"BatchNo",[itemAtIndex objectForKey:@"ExpiryDate"],@"ExpiryDate",monthyeartextField.text,@"IssueMonth",returnqtytextField.text,@"ReturnedQuantity",[itemAtIndex objectForKey:@"AvailableQty"],@"AvailableQty",dateto_string,@"ReturnDate", nil] atIndex:rowIndex.row];
    
    [returnsample_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:rowIndex] withRowAnimation:UITableViewRowAnimationNone];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
