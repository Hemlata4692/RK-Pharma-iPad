//
//  ReturnSample.m
//  RKPharma
//
//  Created by Shiven on 8/28/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "ReturnSample.h"
#import "ProductManager.h"
#import "DailyPlanManager.h"
#import "DailyPlan.h"
#import "JSON.h"
#import "CustomTextField.h"

@interface ReturnSample ()
{
    IBOutlet UITableView *returnsample_table;
    UITextField *BatchNo,*ExpDate,*monthyearweb;
  //  UITextField *monthyear,*return_products,*returnQty;
    UIButton *Delete;
    IBOutlet UIButton *AddMore;
    
    NSMutableArray *ProductArray;
    NSMutableArray *Product_Dictionary;
    int rows;
}
@end

@implementation ReturnSample
@synthesize  toolbar_product,toolbar_date,Product_Picker_toolbar;
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
    rows = 2;
    ProductArray = [NSMutableArray new];
    Product_Dictionary = [NSMutableArray new];
    [Product_Dictionary addObject:@""];
    [Product_Dictionary addObject:@""];
    
//    ProductManager *pm_business=[[ProductManager alloc]init];
//    NSString *response=[pm_business GetProductList];
//    if (response.length !=0)
//    {
//        NSDictionary *var =  [response JSONValue];
//        NSLog(@"dict Product List%@",var);
//        
//        for(NSDictionary *product_dictvar in var)
//        {
//            [ProductArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"SampleId"],@"SampleId",[product_dictvar objectForKey:@"SampleName"],@"SampleName",[product_dictvar objectForKey:@"Unit"],@"Unit",[product_dictvar objectForKey:@"Unit"],@"Unit",[product_dictvar objectForKey:@"Quantity"],@"Quantity",[product_dictvar objectForKey:@"BatchNo"],@"BatchNo",[product_dictvar objectForKey:@"ExpiryDate"],@"ExpiryDate",nil]];
//            
//        }
//    }
    
    [AddMore addTarget:self action:@selector(AddRows:) forControlEvents:UIControlEventTouchUpInside];
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    
   CustomTextField *monthyear = (CustomTextField *)[cell viewWithTag:1];
    monthyear.delegate = self;
    monthyear.Tag1 = (int)indexPath.row;
    
    CustomTextField *return_products = (CustomTextField *)[cell viewWithTag:2];
    return_products.delegate = self;
    return_products.Tag1 = (int)indexPath.row;
    
    BatchNo = (UITextField *)[cell viewWithTag:3];
    ExpDate = (UITextField *)[cell viewWithTag:4];
    
    CustomTextField *returnQty = (CustomTextField *)[cell viewWithTag:5];
    returnQty.delegate = self;
    returnQty.Tag1 = (int)indexPath.row;
    
    BatchNo.userInteractionEnabled = NO;
    ExpDate.userInteractionEnabled = NO;
    
    if ([[Product_Dictionary objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *ProductInfo = [Product_Dictionary objectAtIndex:indexPath.row];
        NSLog(@"dictionary %@",ProductInfo);
        return_products.text = [ProductInfo valueForKey:@"SampleName"];
        ExpDate.text = [ProductInfo valueForKey:@"ExpiryDate"];
        returnQty.text = [ProductInfo valueForKey:@"returnQty"];
        BatchNo.text = [ProductInfo valueForKey:@"BatchNo"];
        monthyear.text = [ProductInfo valueForKey:@"monthyear"];
    }
    else
    {
        return_products.text = @"";
        ExpDate.text = @"";
        returnQty.text = @"";
        BatchNo.text = @"";
        monthyear.text = @"";
    }
    
    Delete = (UIButton *)[cell viewWithTag:7];
    
    
    [Delete addTarget:self action:@selector(DeleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

- (IBAction)DeleteCell:(UIButton *)sender
{
    NSLog(@"ROWSSS %d",rows);
    if(rows>1)
    {
        //NSIndexPath *indexPath =[returnsample_table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        CGPoint center= sender.center;
        CGPoint rootViewPoint = [sender.superview convertPoint:center toView:returnsample_table];
        NSIndexPath *indexPath = [returnsample_table indexPathForRowAtPoint:rootViewPoint];
        
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


- (IBAction)Back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Sample Request",@"heading", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
}

- (void)HideProductPicker:(UITapGestureRecognizer*)gestureRecognizer
{
    Product_Picker.hidden=YES;
    Product_Picker_toolbar.hidden = YES;
}


- (IBAction)SelectDateLabel:(id)sender
{
    NSLog(@" ROW INDEX %d",rowIndex.row);
    
    NSLog(@"Check Hide");
//    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
//   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
//    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
//    [dateformatter setDateFormat:@"MMM-yyyy"];
//    NSString *dateto_string = @"   ";
//    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:DatePicker.date]]];
//    NSLog(@"DatePicker%@",dateto_string);
    
    //[toolbar_date removeFromSuperview];
    //[DatePicker removeFromSuperview];
}

- (void)HideDateLabel:(UIButton *)sender
{
    NSLog(@" ROW INDEX %ld",(long)rowIndex.row);
    [toolbar_date removeFromSuperview];
    [DatePicker removeFromSuperview];
    
    
       NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
      	[dateformatter setDateStyle:NSDateFormatterShortStyle];
       [dateformatter setTimeStyle:NSDateFormatterNoStyle];
       [dateformatter setDateFormat:@"MMM-yyyy"];
        NSString *dateto_string = @"";
        dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:[DatePicker date]]]];
    NSLog(@"DatePicker%@",dateto_string);
    
    NSDateFormatter *dateformatterweb = [[NSDateFormatter alloc] init];
    [dateformatterweb setDateStyle:NSDateFormatterShortStyle];
    [dateformatterweb setTimeStyle:NSDateFormatterNoStyle];
    [dateformatterweb setDateFormat:@"dd-MMM-yyyy"];
    NSString *datetoweb_string = @"";
    datetoweb_string = [datetoweb_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatterweb stringFromDate:[DatePicker date]]]];
    NSLog(@"DatePicker Web%@",datetoweb_string);
    
    
    [Product_Dictionary removeObjectAtIndex:rowIndex.row];
    [Product_Dictionary insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"SampleId",@"",@"SampleName",@"",@"BatchNo",@"",@"ExpiryDate",@"",@"returnQty",@"",@"AvailableQty",@"",@"returnDate",dateto_string,@"monthyear",datetoweb_string,@"monthyearweb", nil] atIndex:rowIndex.row];
    
    NSLog(@" Hide DAte Label %@",Product_Dictionary);
    
    [returnsample_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:rowIndex] withRowAnimation:UITableViewRowAnimationNone];

}



- (IBAction)Submit:(id)sender
{
    [self displayActivityView];
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        
        int condition = 0;
        
        for (int i = 0; i < rows; i++)
        {
            if ([[Product_Dictionary objectAtIndex:i] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = [Product_Dictionary objectAtIndex:i];
                NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:dict];
                NSLog(@" RETURN DICT %@",[dict1 objectForKey:@"returnQty"]);
                 NSLog(@" Available DICT %@",[dict1 objectForKey:@"AvailableQty"]);
                if ([[dict1 objectForKey:@"returnQty"] isEqualToString:@""] || [[dict1 objectForKey:@"returnQty"] length] == 0)
                {
                    condition = 2;
                    break;
                }
                else if([[dict1 objectForKey:@"AvailableQty"] integerValue] < [[dict1 objectForKey:@"returnQty"] integerValue])
                {
                    condition = 3;
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
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateStyle:NSDateFormatterShortStyle];
            [dateformatter setTimeStyle:NSDateFormatterNoStyle];
            [dateformatter setDateFormat:@"dd-MMM-yyyy"];
            NSString *dateto_string = @"";
            dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:[DatePicker date]]]];
            
            NSString *productString=@"";
            for (int i = 0; i < rows; i++) {
                NSDictionary *dict = [Product_Dictionary objectAtIndex:i];
                productString = [productString stringByAppendingFormat:@"%@~%@~%@,",[dict valueForKey:@"SampleId"],[dict valueForKey:@"returnQty"],[dict valueForKey:@"monthyearweb"]];
            }
            
            if ( [productString length] > 0)
                productString = [productString substringToIndex:[productString length] - 1];
            
            SampleRequestDomain *sample_Obj = [SampleRequestDomain new];
            NSString *JsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"SampleDetails\":\"%@\"}",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],productString];
            NSLog(@"skjson %@",JsonRequest);
            sample_Obj.JsonRequest = JsonRequest;
            sample_Obj = [DataModel ReturnSample:sample_Obj];
            
            NSLog(@"SAMPLE RETURN RESPONSE %@",sample_Obj.response);
            
            if ([sample_Obj.response isEqualToString:@"true"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Successfully added." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Sample Request",@"heading", nil]];
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

- (BOOL)textFieldShouldBeginEditing:(CustomTextField *)textField
{
    if (textField.tag == 1)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
            //rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
            NSLog(@"%d",textField.Tag1);
            rowIndex =[NSIndexPath indexPathForRow:textField.Tag1 inSection:0];
            
        }
        [toolbar_date removeFromSuperview];
        [DatePicker removeFromSuperview];
        
        
        // To create datepickers
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        }
        else
        {
           // rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
            NSLog(@"%d",textField.Tag1);
            rowIndex =[NSIndexPath indexPathForRow:textField.Tag1 inSection:0];
        }
        if(rowIndex.row<5)
            DatePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(textField.frame.origin.x+10,textField.frame.origin.y+164+(rowIndex.row)*61,250,150)];
        else
            DatePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(textField.frame.origin.x+10,textField.frame.origin.y+164+4*61,250,150)];
        toolbar_date = [[UIToolbar alloc] initWithFrame:CGRectMake(DatePicker.frame.origin.x, DatePicker.frame.origin.y-50, 250, 50)];
        toolbar_date.barStyle=UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(HideDateLabel:)];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems addObject:flexSpace];
        
        [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                            [UIColor whiteColor], NSForegroundColorAttributeName,
                                            nil]
                                  forState:UIControlStateNormal];
        [barItems addObject:doneButton];
        [toolbar_date setItems:barItems];        toolbar_date.tag = 1;
        [self.view addSubview:toolbar_date];
        
        DatePicker.datePickerMode = UIDatePickerModeDate;
        DatePicker.date = [DatePicker date];
        [DatePicker addTarget:self action:@selector(SelectDateLabel:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:DatePicker];
        DatePicker.hidden = NO;
        DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
        DatePicker.maximumDate = [NSDate date];

        
        return NO;
    }
    else if(textField.tag == 2)
    {
        //rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
           // rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
            NSLog(@"%d",textField.Tag1);
            rowIndex =[NSIndexPath indexPathForRow:textField.Tag1 inSection:0];
        }
        
        NSLog(@" ROW INDEX %ld",(long)rowIndex.row);
        UITableViewCell *cell = [returnsample_table cellForRowAtIndexPath:rowIndex];
        CustomTextField *textField = (CustomTextField *)[cell viewWithTag:1];
        
        NSLog(@"Textfield 2 %@",textField.text);
        
       NSLog(@"Textfield 2 Length %lu",(unsigned long)[textField.text length]);
        
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
            
            NSLog(@"Product COUNT %lu",(unsigned long)ProductArray.count);

            
            [Product_Picker removeFromSuperview];
             [Product_Picker_toolbar removeFromSuperview];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
                rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            }
            else
            {
               // rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
                NSLog(@"%d",textField.Tag1);
                rowIndex =[NSIndexPath indexPathForRow:textField.Tag1 inSection:0];
                
            }
            if(rowIndex.row<5)
                Product_Picker = [[UIPickerView alloc] initWithFrame: CGRectMake(textField.frame.origin.x+100,(textField.frame.origin.y+104+(rowIndex.row)*61)+44,250,150)];
            else
                Product_Picker = [[UIPickerView alloc] initWithFrame: CGRectMake(textField.frame.origin.x+100,(textField.frame.origin.y+104+4*61)+44,250,150)];
            NSLog(@"product picker %f %f",textField.frame.origin.x,textField.frame.origin.y+82+(rowIndex.row)*14);
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
- (void)resignPicker
{
    [Product_Picker_toolbar removeFromSuperview];
    [Product_Picker removeFromSuperview];
}
- (BOOL)textField:(CustomTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"TeFe");
    if (textField.tag == 5)
    {
        NSLog(@"TExtfield 5");
        //rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            
            rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
            
        }
        else
        {
           // rowIndex =[returnsample_table indexPathForCell:(UITableViewCell *)[[[textField superview] superview] superview]];
            NSLog(@"%d",textField.Tag1);
            rowIndex =[NSIndexPath indexPathForRow:textField.Tag1 inSection:0];

        }
        
        if ([[Product_Dictionary objectAtIndex:rowIndex.row] isKindOfClass:[NSDictionary class]])
        {
            
            NSDictionary *dict1 = [Product_Dictionary objectAtIndex:rowIndex.row];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
            
            NSCharacterSet *nonNumberSet ;
            nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
//            [dict removeObjectForKey:@"returnQty"];
//            [dict setObject:[textField.text stringByAppendingString:[string stringByTrimmingCharactersInSet:nonNumberSet]] forKey:@"returnQty"];
            
            
//            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//            
//            NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
//            
//            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
//                                                                                   options:NSRegularExpressionCaseInsensitive
//                                                                                     error:nil];
//            NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
//                                                                options:0
//                                                                  range:NSMakeRange(0, [newString length])];
           
            
            [dict removeObjectForKey:@"returnQty"];
            [dict setObject:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:@"returnQty"];
            
            NSLog(@" RETQQQT%@",[textField.text stringByReplacingCharactersInRange:range withString:string] );
            [Product_Dictionary removeObjectAtIndex:rowIndex.row];
            [Product_Dictionary insertObject:dict atIndex:rowIndex.row];
            
//            if (numberOfMatches == 0)
//                return NO;
            
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
    Product_Picker_toolbar.hidden = YES;
    [super touchesBegan:touches withEvent:event];
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
    
    CustomTextField *monthyeartextField = (CustomTextField *)[cell viewWithTag:1];
    
    CustomTextField *textField = (CustomTextField *)[cell viewWithTag:2];
    textField.text=[itemAtIndex objectForKey:@"SampleName"];
    
    
    UITextField *BatchtextField = (UITextField *)[cell viewWithTag:3];
    BatchtextField.text=[itemAtIndex objectForKey:@"BatchNo"];
    
    UITextField *ExpiryDatetextField = (UITextField *)[cell viewWithTag:4];
    ExpiryDatetextField.text=[itemAtIndex objectForKey:@"ExpiryDate"];
    
    CustomTextField *returnqtytextField = (CustomTextField *)[cell viewWithTag:5];
    
//    UITextField *ReturnQtytextField = (UITextField *)[cell viewWithTag:5];
//    ReturnQtytextField.text=[itemAtIndex objectForKey:@"Quantity"];
//    
//    UITextField *ReturnDatetextField = (UITextField *)[cell viewWithTag:6];
//    ReturnDatetextField.text=[itemAtIndex objectForKey:@"SampleName"];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"MMM-yyyy"];
    NSString *dateto_string = @"";
    dateto_string = [dateto_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:[DatePicker date]]]];
    
    NSDateFormatter *dateformatterweb = [[NSDateFormatter alloc] init];
    [dateformatterweb setDateStyle:NSDateFormatterShortStyle];
    [dateformatterweb setTimeStyle:NSDateFormatterNoStyle];
    [dateformatterweb setDateFormat:@"dd-MMM-yyyy"];
    NSString *datetoweb_string = @"";
    datetoweb_string = [datetoweb_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatterweb stringFromDate:[DatePicker date]]]];
    NSLog(@"DatePicker Web%@",datetoweb_string);
    
    Product_Picker.showsSelectionIndicator = YES;
    
    [Product_Dictionary removeObjectAtIndex:rowIndex.row];
    [Product_Dictionary insertObject:[NSDictionary dictionaryWithObjectsAndKeys:[itemAtIndex objectForKey:@"SampleId"],@"SampleId",[itemAtIndex objectForKey:@"SampleName"],@"SampleName",[itemAtIndex objectForKey:@"BatchNo"],@"BatchNo",[itemAtIndex objectForKey:@"ExpiryDate"],@"ExpiryDate",monthyeartextField.text,@"monthyear",returnqtytextField.text,@"returnQty",[itemAtIndex objectForKey:@"AvailableQty"],@"AvailableQty",dateto_string,@"returnDate",datetoweb_string,@"monthyearweb", nil] atIndex:rowIndex.row];
    NSLog(@" Picker Did Select %@",Product_Dictionary);
    [returnsample_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:rowIndex] withRowAnimation:UITableViewRowAnimationNone];
    

    
}

- (IBAction)ChangeDate:(UIButton *)sender
{
    [toolbar_date removeFromSuperview];
    [DatePicker removeFromSuperview];
    
    // To create datepickers
    DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(580,45,250,150)];
    DatePicker.datePickerMode = UIDatePickerModeDate;
    DatePicker.date = [DatePicker date];
    [DatePicker addTarget:self action:@selector(ChangeDateToLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:DatePicker];
    DatePicker.hidden = YES;
    DatePicker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
