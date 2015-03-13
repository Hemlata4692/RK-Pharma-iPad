
#import "CallSummaryViewController.h"
#import "JSON.h"
#import "DailyPlan.h"
#import "DailyPlanManager.h"
#import "DejalActivityView.h"
#import "DashboardViewController.h"
#import "DailyPlanReportViewController.h"
#import "DailyPlanListViewController.h"
#import "DailyClinicPlannedViewController.h"
#import "ProductManager.h"

NSString *datestring_selected = @"";
NSString *calltype_selected = @"";
NSString *callsummaryplandate_selected = @"";
NSString *callsummaryassistant_selected = @"0";
int callsummaryproductoffset = 0;

@interface CallSummaryViewController ()

@end

@implementation CallSummaryViewController
@synthesize product_table,date_picker,clinic_name,product_name,available_quantity,expiry_date,location_label,order_textview,remarks_textview,date_button,post_radio,current_radio,plan_id,location_string,clinicname_string,quantity,samplechitno,plan_date,call_assistant,back,product_button,product_picker_toolbar,date_picker_toolbar;
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
    date_picker.hidden = YES;
    product_picker.hidden = YES;
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
    datestring_selected = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:date_picker.date]];
}

- (void)ProductService
{
    // To find sample issue prodcuts
    
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
            [product_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"SampleName"],@"SampleName",[dictvar objectForKey:@"Quantity"],@"Quantity",[dictvar objectForKey:@"ExpiryDate"],@"ExpiryDate",[dictvar objectForKey:@"SampleId"],@"SampleId",nil]];
            
        }
        
        [total_value removeAllObjects];
        for (int i=0; i < product_array.count; i++)
        {
            [total_value addObject:@"0"];
        }
        [product_table reloadData];
        NSLog(@" Count Product Array %d",product_array.count);
        
        
        
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
    // To find assigned products
    
    //Create business manager class object
    ProductManager *product_business=[[ProductManager alloc]init];
    // To Get Location
    NSString *product_response=[product_business GetProductList];//call businessmanager method and handle response
    
    if (product_response.length !=0)
    {
        NSDictionary *product_var =  [product_response JSONValue];
        NSLog(@"dict Location List%@",product_var);
        
        
        for(NSDictionary *product_dictvar in product_var)
        {
            [assignedproduct_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"ProductId"],@"ProductId",[product_dictvar objectForKey:@"ProductName"],@"ProductName",nil]];
            
        }
        
        [product_picker reloadAllComponents];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@" Plan ID DID LOAD %@",plan_id);
    
    [back setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1]forState:UIControlStateNormal];
    
    calltype_selected=@"Current Call";
    date_button.hidden = YES;
    callsummaryassistant_selected = @"0";
    
    product_array = [[NSMutableArray alloc]init];
    total_value=[[NSMutableArray alloc]init];
    assignedproduct_array = [[NSMutableArray alloc]init];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                                   initWithTarget:self
    //                                   action:@selector(dismissKeyboard)];
    //
    //    [self.view addGestureRecognizer:tap];
    //    [tap setCancelsTouchesInView:NO];
    
    
    
    
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.product_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    
    
    // To create datepickers
    date_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(547,155+14,250,150)];
    date_picker.datePickerMode = UIDatePickerModeDate;
    date_picker.date = [NSDate date];
    [date_picker addTarget:self action:@selector(ChangeDateLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:date_picker];
    date_picker.hidden = YES;
    date_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    date_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(date_picker.frame.origin.x, 125,date_picker.frame.size.width,30+14)];
    //[location_picker_toolbar sizeToFit];
    date_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems2 addObject:flexSpace2];
    
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked2:)];
    
    [doneBtn2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    [barItems2 addObject:doneBtn2];
    [date_picker_toolbar setItems:barItems2 animated:YES];
    [self.view addSubview:date_picker_toolbar];
    /**********************/
    date_picker_toolbar.hidden = YES;
    
    
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
	product_picker = [[ALPickerView alloc] initWithFrame:CGRectMake(30, 395+14, 200, 100)];
	product_picker.delegate_ = self;
	[self.view addSubview:product_picker];
    product_picker.hidden = YES;
    product_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    product_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(30, 365,product_picker.frame.size.width,30+14)];
    //[location_picker_toolbar sizeToFit];
    product_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
    /************** toolbar custmzation *************/
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_clicked:)];
    
    [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                     nil]
                           forState:UIControlStateNormal];
    [barItems addObject:doneBtn];
    [product_picker_toolbar setItems:barItems animated:YES];
    [self.view addSubview:product_picker_toolbar];
    /**********************/
    product_picker_toolbar.hidden = YES;
    
    
}
-(IBAction)done_clicked:(id)sender
{
    product_picker.hidden=YES;
    product_picker_toolbar.hidden = YES;
}
-(IBAction)done_clicked2:(id)sender
{
    date_picker.hidden=YES;
    date_picker_toolbar.hidden = YES;
}
- (void) viewWillAppear:(BOOL)animated
{
    if(callsummarycontroller.view.tag==990)
    {
        NSLog(@"Check Tag If ");
    }
    else
    {
        NSLog(@"Check Tag  Else");
    }
    NSLog(@"Check Tag   %d",callsummarycontroller.view.tag);
    NSLog(@"Check Title   %@",callsummarycontroller.title);
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
    date_picker_toolbar.hidden = YES;
    
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
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
    location_label.text = location_string;
    clinic_name.text = clinicname_string;
    [self ProductService];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    NSLog(@"Check Method Cell");
    
    UITableViewCell *cell;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        cell=(UITableViewCell *)[[textField superview] superview];
        
    }
    else
    {
        cell =(UITableViewCell *)[[[textField superview] superview] superview];
        
    }
    
    NSLog(@"Check Method");
    
    //UITableView *table = (UITableView *)[cell superview];
    
    UITableView *table;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        table =(UITableView *)[cell superview];
        
    }
    
    else
        
    {
        
        
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
        
        NSLog(@"Before Range");
        NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        
        NSLog(@"Before Range If");
        
        if (range.length == 1)
        {
            return YES;
        }else
        {
            return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
        }
        
        NSLog(@"After Range");
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    
    expiry_date=(UILabel *)[cell viewWithTag:4];
    expiry_date.text = [itemAtIndex objectForKey:@"ExpiryDate"];
    
    UIImage *background_first = [UIImage imageNamed:@"tablebg.png"];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background_first];
    cellBackgroundView.image = background_first;
    cell.backgroundView = cellBackgroundView;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    date_picker.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
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
    NSLog(@" Assigned Product Name %@",[itemAtIndex objectForKey:@"ProductName"]);
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
        date_picker_toolbar.hidden = NO;
        
    }
    else
    {
        date_picker.hidden=YES;
        date_picker_toolbar.hidden = YES;
        
    }
}

-(IBAction)togglecall
{
    radioBoxSelected=!radioBoxSelected;
    if (radioBoxSelected)
    {
        [post_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton1.png"] forState:UIControlStateNormal];
        [current_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton2.png"] forState:UIControlStateNormal];
        
        date_button.hidden = NO;
        calltype_selected = @"Post Call";
        NSLog(@"Post Call");
    }
    else
    {
        [post_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton2.png"] forState:UIControlStateNormal];
        [current_radio setBackgroundImage:[UIImage imageNamed:@"radiobutton1.png"] forState:UIControlStateNormal];
        
        date_button.hidden = YES;
        datestring_selected = @"";
        [date_button setTitle:@"  Select date" forState:UIControlStateNormal];
        calltype_selected = @"Current Call";
        NSLog(@"Current Call");
    }
}

-(IBAction)toggleassistant
{
    checkBoxSelected=!checkBoxSelected;
    if (checkBoxSelected)
    {
        [call_assistant setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
        
        callsummaryassistant_selected = @"1";
        NSLog(@"checked");
    }
    else
    {
        [call_assistant setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        callsummaryassistant_selected = @"0";
        NSLog(@"UnChecked");
    }
}




-(IBAction)SubmitCallSummary
{
    [self.view endEditing:YES];
    date_picker.hidden = YES;
    product_picker.hidden = YES;
    product_picker_toolbar.hidden = YES;
    NSLog(@"Total Value Array%@",total_value);
    
    if([calltype_selected isEqualToString:@"Current Call"])
    {
        NSLog(@" CC ");
    }
    else if([calltype_selected isEqualToString:@"Post Call"])
    {
        NSLog(@" PC ");
    }
    
    
    
    int condition_for_quantity=0;
    int condition_for_blank_quantity=0;
    for(int i = 0;i<product_array.count;i++)
    {
        int avail_Quantity=[[[product_array objectAtIndex:i] objectForKey:@"Quantity"] intValue];
        if([[total_value objectAtIndex:i] intValue]>0)
        {
            condition_for_blank_quantity=1;
            if ([[total_value objectAtIndex:i] intValue] > avail_Quantity)
            {
                condition_for_quantity=1;
            }
        }
        
    }
    
    if ((samplechitno.text == (id)[NSNull null] || samplechitno.text.length == 0 ))
        
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please fill in below required fields.\n Sample Chit No." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if(remarks_textview.text.length >500)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Remarks should not be greater than 500 letters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if([calltype_selected isEqualToString:@"Post Call"] && [datestring_selected length]==0)
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
                               NSString *post_string = [NSString stringWithFormat: @"%@-%@", SampleId, IssueQuantity];
                               
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
                           
                           int f = 0;
                           NSMutableArray *IdArray=[NSMutableArray new];
                           NSMutableString *productid_string = [NSMutableString string];
                           // To find KIV products
                           if(assignedproduct_array.count>0)
                           {
                               
                               NSLog(@"Selection States %d",selectionStates.count);
                               NSLog(@"Selection States %@",selectionStates);
                               for (int i = 0; i< assignedproduct_array.count; i++)
                               {
                                   NSLog(@"Check Row String %d",[[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue]);
                                   if ([[selectionStates objectForKey:[NSString stringWithFormat:@"Row %d",i+1]] intValue] == 1)
                                   {
                                       [IdArray addObject:[[assignedproduct_array objectAtIndex:i] objectForKey:@"ProductId"]];
                                       //NSLog(@"Clinic ID %@",[[clinic_array objectAtIndex:i] objectForKey:@"ClinicId"]);
                                       [productid_string appendString:[NSString stringWithFormat:@"%@,",[[assignedproduct_array objectAtIndex:i] objectForKey:@"ProductId"]]];
                                       f =1;
                                   }
                               }
                               
                           }
                           
                           if(f==1)
                           {
                               NSLog(@"Main String %@",productid_string);
                               dailyplan.kiv_products = [productid_string substringToIndex:[productid_string length] - 1];
                           }
                           else
                           {
                               dailyplan.kiv_products = @"";
                           }
                           
                           
                           dailyplan.plan_id = plan_id;
                           dailyplan.orderinfo = [order_textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                           dailyplan.remarks = [remarks_textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                           dailyplan.samplechitno = samplechitno.text;
                           dailyplan.postcalldate = datestring_selected;
                           dailyplan.assistant_selected = callsummaryassistant_selected;
                           
                           dailyplan.issue_quantity = [issuequantity_string substringToIndex:[issuequantity_string length] - 1];
                           dailyplan.calltype = calltype_selected;
                           //Create business manager class object
                           DailyPlanManager *dp_business=[[DailyPlanManager alloc]init];
                           NSString *response=[dp_business AddCallSummary:dailyplan];//call businessmanager method
                           NSLog(@" Add Summary response is %@",response);
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
                                   
                                   
                                   if(callsummarycontroller.view.tag==991)
                                   {
                                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                       dashboardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_screen"];
                                       dashboardcontroller.view.tag=990;
                                       dashboardcontroller.view.frame=CGRectMake(0,0, 841, 723);
                                       
                                       [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                                       [UIView beginAnimations:@"animateTableView" context:nil];
                                       [UIView setAnimationDuration:0.4];
                                       [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                                       [UIView commitAnimations];
                                       
                                       
                                       [self.view addSubview:dashboardcontroller.view];
                                   }
                                   else if(callsummarycontroller.view.tag==992)
                                   {
                                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                       plannedcliniccontroller = [storyboard instantiateViewControllerWithIdentifier:@"planned_clinic_screen"];
                                       plannedcliniccontroller.view.tag=990;
                                       plannedcliniccontroller.view.frame=CGRectMake(0,0, 841, 723);
                                       
                                       [plannedcliniccontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                                       [UIView beginAnimations:@"animateTableView" context:nil];
                                       [UIView setAnimationDuration:0.4];
                                       [plannedcliniccontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                                       [UIView commitAnimations];
                                       
                                       
                                       [self.view addSubview:plannedcliniccontroller.view];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Plan",@"heading", nil]];
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
            product_picker_toolbar.hidden = NO;
        }
        else
        {
            product_picker.hidden=YES;
            product_picker_toolbar.hidden = YES;
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
    clinicname_string=[dict objectForKey:@"clinic"];
    location_string=[dict objectForKey:@"location"];
    plan_date.text=[dict objectForKey:@"plandate"];
    callsummaryplandate_selected =[dict objectForKey:@"plandate"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *plandate=[formatter dateFromString:callsummaryplandate_selected];
    NSLog(@" MY PLAN DATE %@",callsummaryplandate_selected);
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
                       if(callsummarycontroller.view.tag==991)
                       {
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                           dashboardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_screen"];
                           dashboardcontroller.view.tag=990;
                           dashboardcontroller.view.frame=CGRectMake(0,0, 841, 723);
                           
                           [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                           [UIView beginAnimations:@"animateTableView" context:nil];
                           [UIView setAnimationDuration:0.4];
                           [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                           [UIView commitAnimations];
                           
                           
                           [self.view addSubview:dashboardcontroller.view];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Dashboard",@"heading", nil]];
                       }
                       else if(callsummarycontroller.view.tag==992)
                       {
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                           plannedcliniccontroller = [storyboard instantiateViewControllerWithIdentifier:@"planned_clinic_screen"];
                           plannedcliniccontroller.view.tag=990;
                           plannedcliniccontroller.view.frame=CGRectMake(0,0, 841, 723);
                           
                           [plannedcliniccontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                           [UIView beginAnimations:@"animateTableView" context:nil];
                           [UIView setAnimationDuration:0.4];
                           [plannedcliniccontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                           [UIView commitAnimations];
                           
                           
                           [self.view addSubview:plannedcliniccontroller.view];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Plan",@"heading", nil]];
                       }
                       else 
                       {
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                           dailyplanlistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"daily_plan_summary_report_list"];
                           dailyplanlistcontroller.view.tag=990;
                           dailyplanlistcontroller.view.frame=CGRectMake(0,0, 841, 723);
                           
                           [dailyplanlistcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
                           [UIView beginAnimations:@"animateTableView" context:nil];
                           [UIView setAnimationDuration:0.4];
                           [dailyplanlistcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
                           [UIView commitAnimations];
                           
                           
                           [self.view addSubview:dailyplanlistcontroller.view];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Daily Plan",@"heading", nil]];
                       }
                       [self removeActivityView];
                   });
}


@end
