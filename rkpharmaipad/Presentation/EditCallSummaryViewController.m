//
//  EditCallSummaryViewController.m
//  RKPharma
//
//  Created by Shivendra on 06/06/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "EditCallSummaryViewController.h"
#import "JSON.h"
#import "DejalActivityView.h"
#import "DailyPlan.h"
#import "DailyPlanManager.h"
#import "DailyPlanReportViewController.h"
#import "ProductManager.h"
#import "GlobalVariable.h"

NSString *editdatestring_selected = @"";
NSString *editcalltype_selected = @"";
NSString *editcallsummaryplandate_selected = @"";
NSString *editcallsummaryassistant_selected = @"0";
int editcallsummaryproductoffset = 0;

@interface EditCallSummaryViewController ()

@end

@implementation EditCallSummaryViewController
@synthesize product_table,date_picker,clinic_name,product_name,available_quantity,expiry_date,location_label,order_textview,remarks_textview,date_button,post_radio,current_radio,plan_id,location_string,clinicname_string,quantity,samplechitno,plan_date,call_assistant,back,summary_id,chitno,product_button;
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

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    product_picker.hidden = YES;
    date_picker.hidden = YES;
}

-(IBAction)ChangeDateLabel:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
   	[dateformatter setDateStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeStyle:NSDateFormatterNoStyle];
    [dateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *date_string = @"   ";
    date_string = [date_string stringByAppendingString:[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:date_picker.date]]];
    [date_button setTitle:date_string forState:UIControlStateNormal];
    editdatestring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:date_picker.date]];
}

- (void)ProductService
{
    //Create domain class object
    DailyPlan *dailyplan_samples=[[DailyPlan alloc]init];
    
    NSLog(@"Check Plan ID %@",plan_id);
    dailyplan_samples.plan_id = plan_id;
    
    //Create business manager class object
    DailyPlanManager *dp_business=[[DailyPlanManager alloc]init];
    NSString *response=[dp_business GetSamples:dailyplan_samples];//call businessmanager method
    NSLog(@" Sample List response is %@",response);
    
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict result List%@",var);
        
        
        
        
        for(NSDictionary *dictvar in var)
        {
            int resetavailable_quantity = [[dictvar objectForKey:@"Quantity"] integerValue];
            int productid_int = 0;
            for (int j = 0; j < sample_array.count; j++)
            {
                if([[dictvar objectForKey:@"SampleId"] integerValue] == [[[sample_array objectAtIndex:j] objectForKey:@"SampleId"] intValue] )
                {
                    resetavailable_quantity = [[dictvar objectForKey:@"Quantity"] integerValue] + [[[sample_array objectAtIndex:j] objectForKey:@"Quantity"] intValue];
                    productid_int = [[[sample_array objectAtIndex:j] objectForKey:@"Id"] intValue];
                }
            }
           
           
            
            [product_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"SampleName"],@"SampleName",[NSString stringWithFormat: @"%d",resetavailable_quantity],@"Quantity",[dictvar objectForKey:@"ExpiryDate"],@"ExpiryDate",[dictvar objectForKey:@"SampleId"],@"SampleId",[NSString stringWithFormat: @"%d",productid_int],@"ProductId",nil]];
          
        }
        
        [total_value removeAllObjects];
        for (int i=0; i < product_array.count; i++)
        {
            NSString *filledquanty = @"0";
            NSLog(@" SAMPLE ARAY ACOUNT: %d",sample_array.count);
           
            for (int j = 0; j < sample_array.count; j++)
            {
                 NSLog(@" ProductE SAMPLE ID Value: %d",[[[product_array objectAtIndex:i] objectForKey:@"SampleId"] intValue]);
                NSLog(@"  SAMPLE ID Value: %d",[[[sample_array objectAtIndex:j] objectForKey:@"SampleId"] intValue]);
                if([[[product_array objectAtIndex:i] objectForKey:@"SampleId"] intValue]  == [[[sample_array objectAtIndex:j] objectForKey:@"SampleId"] intValue] )
                {
                    filledquanty = [NSString stringWithFormat: @"%@", [[sample_array objectAtIndex:j] objectForKey:@"Quantity"]];
                    NSLog(@"Filled Quantity %@",filledquanty);
                }
                
            }
             NSLog(@" Filled QUANTIT: %@",filledquanty);
            [total_value addObject:filledquanty];
            
        }
        [product_table reloadData];
        NSLog(@" Count Product Array %d",product_array.count);
        
        NSLog(@" Total Value  Array %@",total_value);
        NSLog(@" Product Value  Array %@",product_array);
        
        [product_picker reloadAllComponents];
        
        if(product_array.count == 0)
        {
            self.product_table.frame = CGRectMake(10,233,821,0);
        }
        else if(product_array.count == 1)
        {
            self.product_table.frame = CGRectMake(10,233,821,44);
        }
        else if(product_array.count == 2)
        {
            self.product_table.frame = CGRectMake(10,233,821,88);
        }
        else if(product_array.count == 3)
        {
            self.product_table.frame = CGRectMake(10,233,821,132);
        }
        else if(product_array.count >= 4)
        {
            self.product_table.frame = CGRectMake(10,233,821,176);
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@" Plan ID DID LOAD %@",plan_id);
    
    [back setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1]forState:UIControlStateNormal];
    
    editcalltype_selected=@"Current Call";
    date_button.hidden = YES;
    editcallsummaryassistant_selected = @"0";
    
    product_array = [[NSMutableArray alloc]init];
    total_value=[[NSMutableArray alloc]init];
    sample_array =  [[NSMutableArray alloc]init];
    assignedproduct_array = [[NSMutableArray alloc]init];
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.product_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    // To create datepickers
    date_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(547,125,250,150)];
    date_picker.datePickerMode = UIDatePickerModeDate;
    date_picker.date = [NSDate date];
    [date_picker addTarget:self action:@selector(ChangeDateLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:date_picker];
    date_picker.hidden = YES;
    date_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    
    UIView *QuantitypaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    samplechitno.leftView = QuantitypaddingView;
    samplechitno.leftViewMode = UITextFieldViewModeAlways;
    
    order_textview.delegate=self;
    remarks_textview.delegate=self;
    
    // To implement Multiple checkbox Product dropdown
    
    // Create some sample data
	entries = [[NSArray alloc] initWithObjects:@"Row 1", @"Row 2", @"Row 3", @"Row 4", @"Row 5", @"Row 6",@"Row 7", @"Row 8", @"Row 9", @"Row 10", @"Row 11", @"Row 12",@"Row 13", @"Row 14", @"Row 15", @"Row 16", @"Row 17", @"Row 18", @"Row 19", @"Row 20", @"Row 21", @"Row 22", @"Row 23", @"Row 24", @"Row 25", @"Row 26", @"Row 27", @"Row 28", @"Row 29", @"Row 30", @"Row 31", @"Row 32", @"Row 33", @"Row 34", @"Row 35", @"Row 36", @"Row 37", @"Row 38", @"Row 39", @"Row 40", @"Row 41", @"Row 42",@"Row 43", @"Row 44", @"Row 45", @"Row 46", @"Row 47", @"Row 48",@"Row 49", @"Row 50", @"Row 51", @"Row 52", @"Row 53", @"Row 54",@"Row 55", @"Row 56", @"Row 57", @"Row 58", @"Row 59", @"Row 60", @"Row 61", @"Row 62", @"Row 63", @"Row 64", @"Row 65", @"Row 66", @"Row 67", @"Row 68", @"Row 69", @"Row 70", @"Row 71", @"Row 72", @"Row 73", @"Row 74", @"Row 75", @"Row 76", @"Row 77", @"Row 78", @"Row 79", @"Row 80", @"Row 81", @"Row 82", @"Row 83", @"Row 84",@"Row 85", @"Row 86", @"Row 87", @"Row 88", @"Row 89", @"Row 90", @"Row 91", @"Row 92", @"Row 93", @"Row 94", @"Row 95", @"Row 96", @"Row 97", @"Row 98", @"Row 99", @"Row 100", @"Row 101", @"Row 102", @"Row 103", @"Row 104",@"Row 105", @"Row 106", @"Row 107", @"Row 108", @"Row 109", @"Row 110", @"Row 111", @"Row 112", @"Row 113", @"Row 114", @"Row 115", @"Row 116", @"Row 117", @"Row 118", @"Row 119",@"Row 120", @"Row 121", @"Row 122", @"Row 123",@"Row 124", @"Row 125", @"Row 126", @"Row 127", @"Row 128", @"Row 129", @"Row 130", @"Row 131", @"Row 132", @"Row 133", @"Row 134", @"Row 135", @"Row 136", @"Row 137", @"Row 138", @"Row 139", @"Row 140", @"Row 141", @"Row 142", @"Row 143", @"Row 144", @"Row 145", @"Row 146", @"Row 147", @"Row 148", @"Row 149", @"Row 150", nil];
    NSLog(@" Entries Array%@",entries);
    NSLog(@"entry count %d",entries.count);
	selectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in entries)
		[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
    
    NSLog(@" Selection Array%@",selectionStates);
	product_picker = [[ALPickerView alloc] initWithFrame:CGRectMake(30, 395, 200, 100)];
	product_picker.delegate_ = self;
	[self.view addSubview:product_picker];
    product_picker.hidden = YES;
    product_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
}

- (void) viewWillAppear:(BOOL)animated
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [[event allTouches] anyObject];
    UITouch *touch = [[event allTouches] anyObject];
    if ([order_textview isFirstResponder] && [touch view] != order_textview)
    {
        [order_textview resignFirstResponder];
    }
    if ([remarks_textview isFirstResponder] && [touch view] != remarks_textview)
    {
        [remarks_textview resignFirstResponder];
    }
    if ([samplechitno isFirstResponder] && [touch view] != samplechitno)
    {
        [samplechitno resignFirstResponder];
    }
    if ([quantity isFirstResponder] && [touch view] != quantity)
    {
        [quantity resignFirstResponder];
    }
    [self.view endEditing:YES];
    date_picker.hidden=YES;
    product_picker.hidden = YES;
    [super touchesBegan:touches withEvent:event];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = -250; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //[total_value replaceObjectAtIndex:textFieldIndexPath.row withObject:textField.text];
    [self animateTextField: textField up: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return TRUE;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    //    [self.product_table scrollToRowAtIndexPath:[self.product_table indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self animateTextField: textField up: YES];
}

- (void) animateTextFieldUItextview: (UITextView*) textField up: (BOOL) up
{
    const int movementDistance = -250; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self animateTextFieldUItextview: textView up: YES];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [self animateTextFieldUItextview: textView up: NO];
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Sumary ID : %@",summary_id);
    
    //Create domain class object
    DailyPlan *callsummary=[[DailyPlan alloc]init];
    
    callsummary.summaryId = summary_id;
    
    //Create business manager class object
    DailyPlanManager *dp_business=[[DailyPlanManager alloc]init];
    NSString *response=[dp_business GetMeetingSummaryDetails:callsummary];//call businessmanager method
    NSLog(@" Summary Details response is %@",response);
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@" Plan ID Before For : %@",[var objectForKey:@"PlanId"]);
        order_textview.text = [var objectForKey:@"OrderInfo"];
        remarks_textview.text = [var objectForKey:@"Remarks"];
        chitno.text=[var objectForKey:@"ChitNo"];
        
        NSLog(@" CLINIC ASSISTANT %@",[var objectForKey:@"ClinicAssistant"]);
        
        if ([[var objectForKey:@"CallType"] isEqualToString:@"Post Call"])
        {
            [post_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton1.png"] forState:UIControlStateNormal];
            [current_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton2.png"] forState:UIControlStateNormal];
            
            date_button.hidden = NO;
            editcalltype_selected = @"Post Call";
            NSLog(@"Post Call");
            editdatestring_selected = [var objectForKey:@"CallDate"];
            NSString *date_string = @"   ";
            date_string = [date_string stringByAppendingString:[NSString stringWithFormat:@"%@",[var objectForKey:@"CallDate"]]];
            [date_button setTitle:date_string forState:UIControlStateNormal];
        }
        else
        {
            [post_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton2.png"] forState:UIControlStateNormal];
            [current_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton1.png"] forState:UIControlStateNormal];
            
            date_button.hidden = YES;
            editdatestring_selected = @"";
            [date_button setTitle:@"  Select date" forState:UIControlStateNormal];
            editcalltype_selected = @"Current Call";
            NSLog(@"Current Call");
        }
        
        if([[var objectForKey:@"ClinicAssistant"] integerValue]==1)
        {
            [call_assistant setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
            editcallsummaryassistant_selected = @"1";
            NSLog(@"checked");
        }
        else
        {
            [call_assistant setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
            editcallsummaryassistant_selected = @"0";
            NSLog(@"UnChecked");
        }
        
        for(NSDictionary *dictvar in [var objectForKey:@"Products"])
        {
            NSLog(@"Sample Array: %@",[dictvar objectForKey:@"Product"]);
            [sample_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Product"],@"Product",[dictvar objectForKey:@"ProductUnit"],@"ProductUnit",[dictvar objectForKey:@"Quantity"],@"Quantity",[dictvar objectForKey:@"SampleId"],@"SampleId",[dictvar objectForKey:@"Id"],@"Id",nil]];
        }
        
        
        
        editproduct_array=[[NSMutableArray alloc]init];
        
        for(NSDictionary *dictvar in [var objectForKey:@"ProductKIV"])
        {
            [editproduct_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictvar,@"ProductId" ,nil]];
        }
        
        // To find assigned products
        
        //Create business manager class object
        ProductManager *product_business=[[ProductManager alloc]init];
        
        NSString *product_response=[product_business GetProductList];//call businessmanager method and handle response
        
        if (product_response.length !=0)
        {
            NSDictionary *product_var =  [product_response JSONValue];
            NSLog(@"dict Location List%@",product_var);
            
            int editproduct = 0;
            
            for(NSDictionary *product_dictvar in product_var)
            {
                NSLog(@" Edit Product Array Count %d",editproduct_array.count);
                for (int k = 0; k < editproduct_array.count; k++)
                {
                    NSLog(@" Compare Product Array SampleID  %@",[product_dictvar objectForKey:@"ProductId"]);
                    NSLog(@" Compare Product Array ProductID  %@",[[editproduct_array objectAtIndex:k] objectForKey:@"ProductId"]);
                    NSLog(@" -----  ");
                    if([[product_dictvar objectForKey:@"ProductId"] integerValue] == [[[editproduct_array objectAtIndex:k] objectForKey:@"ProductId"] intValue])
                    {
                        [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[entries objectAtIndex:editproduct]];
                    }
                }
                
                [assignedproduct_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"ProductId"],@"ProductId",[product_dictvar objectForKey:@"ProductName"],@"ProductName",nil]];
                editproduct++;
            }
        }
        
        
        
        NSLog(@" Sample Array : %@",sample_array);
        NSLog(@" Sample KIV Array : %@",editproduct_array);
    }
    
    location_label.text = location_string;
    clinic_name.text = clinicname_string;
    [self ProductService];
    
    NSLog(@"Sumary ID View Did Appear: %@",summary_id);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    
    UITableViewCell *cell;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        cell=(UITableViewCell *)[[textField superview] superview];
        
    }
    else
    {
        cell =(UITableViewCell *)[[[textField superview] superview] superview];
        
    }
    
    //UITableView *table = (UITableView *)[cell superview];
    
    UITableView *table;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        NSLog(@" iOS6 and Below");
        
        table =(UITableView *)[cell superview];
        
    }
    
    else
        
    {
        NSLog(@" iOS7 ");
        
        table =(UITableView *)[[cell superview] superview];
        
    }
    
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    
    
    
    
    [total_value removeObjectAtIndex:textFieldIndexPath.row];
    [total_value insertObject:[textField.text stringByReplacingCharactersInRange:range withString:string] atIndex:textFieldIndexPath.row];
    
    //samplechitno
    if (textField == samplechitno)
    {
        return YES;
    }
    else
    {
        NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        
        if (range.length == 1)
        {
            return YES;
        }else
        {
            return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return product_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* const CellIdentifier = @"product_cell";
    //  static NSString *CellIdentifier = @"product_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:indexPath.row];
    
    product_name=(UILabel *)[cell viewWithTag:1];
    product_name.text = [itemAtIndex objectForKey:@"SampleName"];
    
    //available_quantity=(UILabel *)[cell viewWithTag:3];
    //available_quantity.text = [itemAtIndex objectForKey:@"Quantity"];
    
    UIView *QuantitypaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 17)];
    
    quantity=(UITextField *)[cell viewWithTag:2];
    quantity.leftView = QuantitypaddingView;
    quantity.leftViewMode = UITextFieldViewModeAlways;
    quantity.delegate=self;
    
    quantity.keyboardType=UIKeyboardTypeNumberPad;
    
    if ([[total_value objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        quantity.text=@"";
    }
    else {
        quantity.text=[total_value objectAtIndex:indexPath.row];
    }
    
    available_quantity=(UILabel *)[cell viewWithTag:3];
    NSInteger main_stock_quantity_int = [[itemAtIndex objectForKey:@"Quantity"] integerValue];
    available_quantity.text = [NSString stringWithFormat:@"%d",main_stock_quantity_int];
    
//    for (int i = 0; i < sample_array.count; i++)
//    {
//        NSDictionary *itemAtIndexSample = (NSDictionary *)[sample_array objectAtIndex:i];
//        if([[itemAtIndex objectForKey:@"SampleId"] integerValue] == [[itemAtIndexSample objectForKey:@"SampleId"] integerValue] )
//        {
//            quantity.text = [NSString stringWithFormat: @"%@", [itemAtIndexSample objectForKey:@"Quantity"]];
//            NSLog(@" ISSUE QUANTiTY : %@",[itemAtIndexSample objectForKey:@"Quantity"]);
//            
//            NSInteger edit_stock_quantity_int = [[itemAtIndexSample objectForKey:@"Quantity"] integerValue];
//            available_quantity.text = [NSString stringWithFormat:@"%d",main_stock_quantity_int+edit_stock_quantity_int];
//        }
//    }
    
    expiry_date=(UILabel *)[cell viewWithTag:4];
    expiry_date.text = [itemAtIndex objectForKey:@"ExpiryDate"];
    
    UIImage *background_first = [UIImage imageNamed:@"tablebg.png"];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background_first];
    cellBackgroundView.image = background_first;
    cell.backgroundView = cellBackgroundView;
    
    
    
    return cell;
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"Will begin dragging");
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"Did Scroll");
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    date_picker.hidden = YES;
    product_picker.hidden = YES;
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
	//return [entries count];
    NSLog(@"Product Count Array : %d",assignedproduct_array.count);
    return assignedproduct_array.count;
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
    //NSLog(@" Text %@",[entries objectAtIndex:row]);
	//return [entries objectAtIndex:row];
    NSDictionary *itemAtIndex = (NSDictionary *)[assignedproduct_array objectAtIndex:row];
    NSLog(@" SAmple Name %@",[itemAtIndex objectForKey:@"ProductName"]);
    return  [itemAtIndex objectForKey:@"ProductName"];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
    NSLog([[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue] ? @"Yes" : @"No");
    //NSLog(@" Selection State %d",[[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue]);
	return [[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
	// Check whether all rows are checked or only one
	if (row == -1)
		for (id key in [selectionStates allKeys])
			[selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
	else
		[selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[entries objectAtIndex:row]];
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
	// Check whether all rows are unchecked or only one
	if (row == -1)
		for (id key in [selectionStates allKeys])
			[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	else
		[selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[entries objectAtIndex:row]];
}

-(IBAction)GetDate
{
    if([date_picker isHidden])
    {
        date_picker.hidden=NO;
    }
    else
    {
        date_picker.hidden=YES;
    }
}

-(IBAction)togglecall
{
    
    if ([editcalltype_selected isEqualToString:@"Current Call"])
    {
        [post_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton1.png"] forState:UIControlStateNormal];
        [current_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton2.png"] forState:UIControlStateNormal];
        
        date_button.hidden = NO;
        editcalltype_selected = @"Post Call";
        NSLog(@"Post Call");
    }
    else
    {
        [post_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton2.png"] forState:UIControlStateNormal];
        [current_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton1.png"] forState:UIControlStateNormal];
        
        date_button.hidden = YES;
        editdatestring_selected = @"";
        [date_button setTitle:@"  Select date" forState:UIControlStateNormal];
        editcalltype_selected = @"Current Call";
        NSLog(@"Current Call");
    }
}

-(IBAction)toggleassistant
{
    //checkBoxSelected=!checkBoxSelected;
    if ([editcallsummaryassistant_selected isEqualToString:@"0"])
    {
        [call_assistant setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
        
        editcallsummaryassistant_selected = @"1";
        NSLog(@"checked");
    }
    else
    {
        [call_assistant setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        editcallsummaryassistant_selected = @"0";
        NSLog(@"UnChecked");
    }
}

-(IBAction)UpdateCallSummary
{
    [self.view endEditing:YES];
    date_picker.hidden = YES;
    product_picker.hidden = YES;
    NSLog(@"Total Value Array%@",total_value);
    
 
    
    if([editcalltype_selected isEqualToString:@"Current Call"])
    {
        NSLog(@" CC ");
    }
    else if([editcalltype_selected isEqualToString:@"Post Call"])
    {
        NSLog(@" PC ");
    }
    
    int condition_for_quantity=0;
    int condition_for_blank_quantity=0;
    for(int i = 0;i<product_array.count;i++)
    {
        
        int avail_Quantity=[[[product_array objectAtIndex:i] objectForKey:@"Quantity"] intValue];
//        for (int j = 0; j < sample_array.count; j++)
//        {
//            if([[[product_array objectAtIndex:i] objectForKey:@"SampleId"] intValue] == [[[sample_array objectAtIndex:j] objectForKey:@"SampleId"] intValue] )
//            {
//                avail_Quantity=[[[product_array objectAtIndex:i] objectForKey:@"Quantity"] intValue] + [[[sample_array objectAtIndex:i] objectForKey:@"Quantity"] intValue];
//            }
//        }
        
        if([[total_value objectAtIndex:i] intValue]>0)
        {
            condition_for_blank_quantity=1;
            if ([[total_value objectAtIndex:i] intValue] > avail_Quantity)
            {
                condition_for_quantity=1;
            }
        }
        
    }
    
    if([editcalltype_selected isEqualToString:@"Post Call"] && [editdatestring_selected length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select post call date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (condition_for_blank_quantity == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please insert quantity for atleast one sample." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (condition_for_quantity ==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"You can't insert issue quantity more than available quantity." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self displayActivityView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            NSMutableString *issuequantity_string = [[NSMutableString alloc]init];
            for(int i = 0;i<product_array.count;i++)
            {
                NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:i];
                
                
                NSLog(@" Issue Quantity %@",[total_value objectAtIndex:i]);
                NSLog(@" SampleId %@",[itemAtIndex objectForKey:@"SampleId"]);
                
                NSString *IssueQuantity = [total_value objectAtIndex:i];
                NSString *SampleId = [itemAtIndex objectForKey:@"SampleId"];
                 NSString *ProductId = [itemAtIndex objectForKey:@"ProductId"];
                NSString *post_string = [NSString stringWithFormat: @"%@-%@-%@", ProductId,SampleId,IssueQuantity];
                
                if([[total_value objectAtIndex:i] intValue]>0)
                {
                    [issuequantity_string appendString:[NSString stringWithFormat:@"%@,",post_string]];
                }
                
            }
            
            NSLog(@"Sample Quantity%@",[issuequantity_string substringToIndex:[issuequantity_string length] - 1]);
            NSLog(@"Orderinfo%@",order_textview.text);
            NSLog(@"Remarks%@",remarks_textview.text);
            NSLog(@"SampleChit%@",samplechitno.text);
            //Create domain class object
            DailyPlan *dailyplan=[[DailyPlan alloc]init];
            
            // To find KIV products
            if(assignedproduct_array.count>0)
            {
                //NSMutableArray *IdArray=[NSMutableArray new];
                NSMutableString *productid_string = [NSMutableString string];
                NSLog(@"Selection States %d",selectionStates.count);
                NSLog(@"Selection States %@",selectionStates);
                for (int i = 0; i< assignedproduct_array.count; i++)
                {
                    NSLog(@"Check Row String %d",[[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue]);
                    //            if ([[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue] == 1)
                    //            {
                    //                [IdArray addObject:[[product_array objectAtIndex:i] objectForKey:@"SampleId"]];
                    //                //NSLog(@"Clinic ID %@",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]);
                    //                [productid_string appendString:[NSString stringWithFormat:@"%@,",[[product_array objectAtIndex:i] objectForKey:@"SampleId"]]];
                    //            }
                    
                    NSString *KIVSampleId = [[assignedproduct_array objectAtIndex:i] objectForKey:@"ProductId"];
                    NSString *KIVStatus = [selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]];
                    NSString *KIVpost_string = [NSString stringWithFormat: @"%@-%@", KIVSampleId,KIVStatus];
                    
                    [productid_string appendString:[NSString stringWithFormat:@"%@,",KIVpost_string]];
                    
                }
                
                NSLog(@"Main KIV String %@",productid_string);
                dailyplan.kiv_products = [productid_string substringToIndex:[productid_string length] - 1];
            }
            dailyplan.plan_id = plan_id;
            dailyplan.orderinfo = order_textview.text;
            dailyplan.remarks = remarks_textview.text;
            dailyplan.samplechitno = chitno.text;
            dailyplan.postcalldate = editdatestring_selected;
            dailyplan.assistant_selected = editcallsummaryassistant_selected;
            
            
            dailyplan.issue_quantity = [issuequantity_string substringToIndex:[issuequantity_string length] - 1];
            dailyplan.calltype = editcalltype_selected;
            dailyplan.summaryId = summary_id;
            //Create business manager class object
            DailyPlanManager *dp_business=[[DailyPlanManager alloc]init];
            NSString *response=[dp_business EditMeetingSummary:dailyplan];//call businessmanager method
            NSLog(@" Edit Summary response is %@",response);
            if (response.length !=0)
            {
                NSDictionary *var =  [response JSONValue];
                NSLog(@"dict result List%@",var);
                [self removeActivityView];
                NSLog(@" Chit Exist%d",[[var objectForKey:@"ChitExist"] intValue]);
                if([[var objectForKey:@"IsSuccess"] intValue]==0)
                {
                    if([[var objectForKey:@"ChitExist"] intValue]==1)
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Failed: Smaple chit no. already exist." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    else if([[var objectForKey:@"Locked"] intValue]==1)
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Failed: Admin has locked this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    else if([[var objectForKey:@"TimeOver"] intValue]==1)
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Failed: Limit of 72 hours has been passed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                }
                else
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                    dailyplanreportcontroller = [storyboard instantiateViewControllerWithIdentifier:@"daily_plan_summary_report_list"];
                    dailyplanreportcontroller.view.tag=990;
                    dailyplanreportcontroller.view.frame=CGRectMake(0,0, 841, 723);
                    
                    [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                    [UIView beginAnimations:@"animateTableView" context:nil];
                    [UIView setAnimationDuration:0.4];
                    [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                    [UIView commitAnimations];
                    
                    
                    [self.view addSubview:dailyplanreportcontroller.view];
                    
                }
            }
        });
    }
}

-(IBAction)Get_Product
{
    if(product_array.count>0)
    {
        if([product_picker isHidden])
        {
            product_picker.hidden=NO;
        }
        else
        {
            product_picker.hidden=YES;
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"You have no sample product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)PassValue:(NSDictionary *)dict
{
    plan_id=[dict objectForKey:@"planid"];
    summary_id=[dict objectForKey:@"summaryid"];
    clinicname_string=[dict objectForKey:@"clinic"];
    location_string=[dict objectForKey:@"location"];
    plan_date.text=[dict objectForKey:@"plandate"];
    editcallsummaryplandate_selected =[dict objectForKey:@"plandate"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *plandate=[formatter dateFromString:editcallsummaryplandate_selected];
    NSLog(@" MY PLAN DATE %@",editcallsummaryplandate_selected);
    NSLog(@" MY Summary Id %@",summary_id);
    self.date_picker.minimumDate = plandate;
    
    self.date_picker.maximumDate = [NSDate date];
}

-(IBAction)backbtn_clicked
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        NSLog(@"Back Button clicked");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:plan_date.text  forKey:@"PlanDate"];
        NSLog(@"Back Button Plan Date Value %@",plan_date.text);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        dailyplanreportcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dailyreport_screen"];
        dailyplanreportcontroller.view.tag=990;
        dailyplanreportcontroller.view.frame=CGRectMake(0,0, 841, 723);
        
        [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [dailyplanreportcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        
        
        [self.view addSubview:dailyplanreportcontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Report",@"heading", nil]];
        
        [self removeActivityView];
    });
}

@end
