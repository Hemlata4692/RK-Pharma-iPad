//
//  KIVViewController.m
//  RKPharma
//
//  Created by Shivendra on 09/07/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "KIVViewController.h"
#import "DejalActivityView.h"
#import "JSON.h"
#import "ClinicManager.h"
#import "QuartzCore/QuartzCore.h"
#import "Clinic.h"

NSString *KIVSeletedProduct = @"";
NSString *KIVSelectedArea = @"";

@interface KIVViewController ()

@end

@implementation KIVViewController

@synthesize KIV_table,clinicname,location,status,error,product,remarks,reset_button,search_button,datefrom_button,dateto_button,kivdate,staff_name_label,staff_username;
@synthesize area_picker_toolbar,Product_Picker_toolbar;
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
-(IBAction)SelectProduct:(id)sender
{
    [Product_Picker removeFromSuperview];
    [Product_Picker_toolbar removeFromSuperview];
    [area_picker removeFromSuperview];
    [area_picker_toolbar removeFromSuperview];
    Product_Picker = [[UIPickerView alloc] initWithFrame:CGRectMake(252,80+14,250,150)];
    Product_Picker.delegate = self;
    [self.view addSubview:Product_Picker];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideProductPicker:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [Product_Picker addGestureRecognizer:gestureRecognizer];
    Product_Picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    [Product_Picker reloadAllComponents];
    /** picker toolbar code **/
    
    Product_Picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(Product_Picker.frame.origin.x, 52,Product_Picker.frame.size.width,30+14)];
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
    
    
}
-(void)HideProductPicker:(UITapGestureRecognizer *)tap
{
    [Product_Picker removeFromSuperview];
    [Product_Picker_toolbar removeFromSuperview];
}

-(void)HideAreaPicker:(UITapGestureRecognizer *)tap
{
    [area_picker removeFromSuperview];
    [area_picker_toolbar removeFromSuperview];
}
-(IBAction)done_clicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag ==1)
    {
        [area_picker removeFromSuperview];
        [area_picker_toolbar removeFromSuperview];
    }
    else
    {
        [Product_Picker_toolbar removeFromSuperview];
        [Product_Picker removeFromSuperview];
    }
    
}
-(IBAction)SelectArea:(id)sender
{
    [Product_Picker removeFromSuperview];
    [Product_Picker_toolbar removeFromSuperview];
    [area_picker removeFromSuperview];
    [area_picker_toolbar removeFromSuperview];
    area_picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10,80+14,250,150)];
    area_picker.delegate = self;
    [self.view addSubview:area_picker];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideAreaPicker:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [area_picker addGestureRecognizer:gestureRecognizer];
    area_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    area_picker_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(area_picker.frame.origin.x, 50,area_picker.frame.size.width,30+14)];
    area_picker_toolbar.barStyle = UIBarStyleBlackTranslucent;
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
    [area_picker_toolbar setItems:barItems animated:YES];
    [self.view addSubview:area_picker_toolbar];
    
    [area_picker reloadAllComponents];
}
-(IBAction)GetKIVProduct
{
    //Create domain class object
    Clinic *clinic_domain=[[Clinic alloc]init];
    
    //daily_plan.plan_date = dailyplandatefromstring_selected;
    clinic_domain.datefrom_string = @"";
    clinic_domain.dateto_string = @"";
    clinic_domain.ProductId = KIVSeletedProduct;
    clinic_domain.LocationId = KIVSelectedArea;
    
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    // To Get Location
    NSString *KIV_response=[cm_business GetKIVProducts:clinic_domain];//call businessmanager Location method and handle response
    
    if (KIV_response.length !=0)
    {
        NSDictionary *var =  [KIV_response JSONValue];
        for(NSDictionary *dictvar in var)
        {
            [KIV_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Clinic"],@"Clinic",[dictvar objectForKey:@"Location"],@"Location",[dictvar objectForKey:@"PlanDate"],@"PlanDate",[dictvar objectForKey:@"Staff"],@"Staff",[dictvar objectForKey:@"Product"],@"Product",[dictvar objectForKey:@"Remark"],@"Remark",[dictvar objectForKey:@"Status"],@"Status",[dictvar objectForKey:@"PlanDate"],@"PlanDate",nil]];
            
        }
        
        [KIV_table reloadData];
        
        if(KIV_array.count == 0)
        {
            self.KIV_table.frame = CGRectMake(10,96,821,0);
        }
        else if(KIV_array.count == 1)
        {
            self.KIV_table.frame = CGRectMake(10,96,821,90);
        }
        else if(KIV_array.count == 2)
        {
            self.KIV_table.frame = CGRectMake(10,96,821,180);
        }
        else if(KIV_array.count == 3)
        {
            self.KIV_table.frame = CGRectMake(10,96,821,270);
        }
        else if(KIV_array.count == 4)
        {
            self.KIV_table.frame = CGRectMake(10,96,821,360);
        }
        else if(KIV_array.count == 5)
        {
            self.KIV_table.frame = CGRectMake(10,96,821,450);
        }
        else if(KIV_array.count == 6)
        {
            self.KIV_table.frame = CGRectMake(10,96,821,540);
        }
        else if(KIV_array.count >= 7)
        {
            self.KIV_table.frame = CGRectMake(10,96,821,630);
        }
        
        if(KIV_array.count == 0)
        {
            error.text = @"No Record Found !";
            error.textColor= [UIColor colorWithRed:(200/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        }
        else
        {
            error.text = @"";
        }
    }
}

- (void)resignPicker
{
    
}

- (void)viewDidLoad
{
    
    KIVSelectedArea = @"";
    KIVSeletedProduct = @"";
    ProductArray = [NSMutableArray new];
    ProductManager *pm_business=[[ProductManager alloc]init];
    NSString *response=[pm_business GetProductList];
    if (response.length !=0)
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Product List%@",var);
        
        [ProductArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ProductId",@"All",@"ProductName",nil]];
        for(NSDictionary *product_dictvar in var)
        {
            [ProductArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"ProductId"],@"ProductId",[product_dictvar objectForKey:@"ProductName"],@"ProductName",nil]];
            
        }
    }
    
    location_array = [NSMutableArray new];
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
    
    
    
    KIV_array = [[NSMutableArray alloc]init];
    
    KIV_table.layer.borderWidth = 1.0;
    KIV_table.layer.borderColor = [UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1].CGColor;
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.KIV_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    
    [self GetKIVProduct];
    
    CGRect frame = datefrom_button.frame;
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 250, 44)];
    toolbar.barStyle=UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
    [toolbar setItems:[NSArray arrayWithObject:doneButton]];
    toolbar.tag = 1;
    [self.view addSubview:toolbar];
    toolbar.hidden = YES;
    
    frame = toolbar.frame;
    
    
    CGRect frame_dateto = dateto_button.frame;
    toolbar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(frame_dateto.origin.x, frame_dateto.origin.y+frame_dateto.size.height, 250, 44)];
    toolbar1.barStyle=UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton_dateto = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
    [toolbar1 setItems:[NSArray arrayWithObject:doneButton_dateto]];
    toolbar1.tag = 2;
    [self.view addSubview:toolbar1];
    toolbar1.hidden = YES;
    
    frame_dateto = toolbar1.frame;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return KIV_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1]];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KIV_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary *itemAtIndex = (NSDictionary *)[KIV_array objectAtIndex:indexPath.row];
    
    
    
    clinicname=(UILabel *)[cell viewWithTag:1];
    clinicname.text =[itemAtIndex objectForKey:@"Clinic"];
    
    location=(UILabel *)[cell viewWithTag:2];
    location.text = [itemAtIndex objectForKey:@"Location"];
    
    remarks=(UITextView *)[cell viewWithTag:4];
    remarks.text = [itemAtIndex objectForKey:@"Remark"];
    
    status=(UILabel *)[cell viewWithTag:5];
    status.text = [itemAtIndex objectForKey:@"Status"];
    
    product=(UILabel *)[cell viewWithTag:3];
    product.text = [itemAtIndex objectForKey:@"Product"];
    
    kivdate=(UILabel *)[cell viewWithTag:6];
    kivdate.text = [itemAtIndex objectForKey:@"PlanDate"];
    
    staff_username=(UILabel *)[cell viewWithTag:8];
    staff_username.text = [itemAtIndex objectForKey:@"Staff"];
    
    staff_name_label=(UILabel *)[cell viewWithTag:7];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"ROLE %@",[defaults objectForKey:@"Role"]);
    
    if([[defaults objectForKey:@"Role"] isEqualToString:@"Manager"])
    {
        staff_username.hidden = NO;
        staff_name_label.hidden = NO;
    }
    else
    {
        staff_username.hidden = YES;
        staff_name_label.hidden = YES;
    }
    
    
    
    
    if (indexPath.row % 2 == 0)
    {
        remarks.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        remarks.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    }
    
    
    // To show custom separator
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableseparator_large.png"]];
    [self.KIV_table setSeparatorColor:color];
    
    return cell;
}


-(IBAction)SearchKIV
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [KIV_array removeAllObjects];
                       [self GetKIVProduct];
                       [self removeActivityView];
                   });
}
-(IBAction)resetKIV:(id)sender
{
    [datefrom_button setTitle:@"   Select by Area" forState:UIControlStateNormal];
    [dateto_button setTitle:@"   Select by product" forState:UIControlStateNormal];
    KIVSeletedProduct = @"";
    KIVSelectedArea = @"";
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [KIV_array removeAllObjects];
                       [self GetKIVProduct];
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
    if (pickerView == Product_Picker) {
        return ProductArray.count;
    }
    else
    {
        return location_array.count;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == Product_Picker) {
        
        NSDictionary *itemAtIndex = (NSDictionary *)[ProductArray objectAtIndex:row];
        return [itemAtIndex objectForKey:@"ProductName"];
    }
    else
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
        return [itemAtIndex objectForKey:@"LocationName"];
        
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == Product_Picker) {
        NSDictionary *itemAtIndex = (NSDictionary *)[ProductArray objectAtIndex:row];
        NSString* productIdValue=[itemAtIndex objectForKey:@"ProductId"];
        KIVSeletedProduct = productIdValue;
        NSString *product_namestring = @"   ";
        product_namestring = [product_namestring stringByAppendingString:[itemAtIndex objectForKey:@"ProductName"]];
        if (product_namestring.length > 50) {
            product_namestring = [product_namestring substringToIndex:[product_namestring length] - ([product_namestring length]-53)];
            product_namestring = [product_namestring stringByAppendingString:@"..."];
        }
        [dateto_button setTitle:product_namestring forState:UIControlStateNormal];
    }
    else
    {
        NSDictionary *itemAtIndex = (NSDictionary *)[location_array objectAtIndex:row];
        NSString* productIdValue=[itemAtIndex objectForKey:@"LocationId"];
        KIVSelectedArea = productIdValue;
        [datefrom_button setTitle:[@"   " stringByAppendingString:[itemAtIndex objectForKey:@"LocationName"]] forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
