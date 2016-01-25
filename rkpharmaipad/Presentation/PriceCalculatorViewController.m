//
//  PriceCalculatorViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "PriceCalculatorViewController.h"
#import "ProductManager.h"
#import "JSON.h"
#import "PriceCalculator.h"
#import "PriceCalculatorManager.h"

NSString *calc_productid_selected = @"";
float doctprice;
float calculate_result;
@interface PriceCalculatorViewController ()

@end

@implementation PriceCalculatorViewController
@synthesize product_picker,product_button,main_quantity,unofficial_bonus,bonus_quantity,calculate_button,result_label,doctor_price_label,next_button,previous_button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    toolbar.hidden = YES;
    product_picker.hidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    main_quantity.delegate=self;
    bonus_quantity.delegate=self;
    unofficial_bonus.delegate=self;
    
    next_button.hidden = YES;
    previous_button.hidden = YES;
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Initialize array
    product_array = [[NSMutableArray alloc]init];
    
    
    // To Show Product Picker
    product_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(34,155,300,150)];
    
    // To Show Product Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [product_picker addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:product_picker];
    
    [product_picker setDelegate:self];
    [product_picker setDataSource:self];
    product_picker.hidden = YES;
    product_picker.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
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
            [product_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[product_dictvar objectForKey:@"ProductId"],@"ProductId",[product_dictvar objectForKey:@"ProductName"],@"ProductName",[product_dictvar objectForKey:@"DoctorPrice"],@"DoctorPrice",nil]];
            
        }
    }
    
    //    if(product_array.count>0)
    //    {
    //        // To Show Product Picker
    //        product_picker=[[UIPickerView alloc]initWithFrame:CGRectMake(34,110,300,150)];
    //
    //        // To Show Product Picker View
    //        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    //        gestureRecognizer.cancelsTouchesInView = NO;
    //
    //        [product_picker addGestureRecognizer:gestureRecognizer];
    //        [self.view addSubview:product_picker];
    //
    //        [product_picker setDelegate:self];
    //        [product_picker setDataSource:self];
    //    }
    
    // To hide keyboard when tap
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //                                   initWithTarget:self
    //                                   action:@selector(dismissKeyboard)];
    //    [self.view addGestureRecognizer:tap];
    //    [tap setCancelsTouchesInView:NO];
    
    
    CGRect frame = product_button.frame;
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, 300, 44)];
    toolbar.barStyle=UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(resignPicker)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"HelveticaNeue" size:15], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    [barItems addObject:doneButton];
    [toolbar setItems:barItems];
    
    toolbar.tag = 1;
    [self.view addSubview:toolbar];
    toolbar.hidden = YES;
    
    frame = toolbar.frame;
    
}

- (void)resignPicker
{
    toolbar.hidden = YES;
    product_picker.hidden = YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([main_quantity isFirstResponder] && [touch view] != main_quantity)
    {
        [main_quantity resignFirstResponder];
    }
    if ([bonus_quantity isFirstResponder] && [touch view] != bonus_quantity)
    {
        [bonus_quantity resignFirstResponder];
    }
    if ([unofficial_bonus isFirstResponder] && [touch view] != unofficial_bonus)
    {
        [unofficial_bonus resignFirstResponder];
    }
    product_picker.hidden = YES;
    toolbar.hidden = YES;
    [super touchesBegan:touches withEvent:event];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil)
    {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 250, 150);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:13.0]];
        
    }
    NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:row];
    
    //picker view array is the datasource
    [pickerLabel setText:[itemAtIndex objectForKey:@"ProductName"]];
    
    return pickerLabel;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Here we are setting the number of rows in the pickerview to the number of objects of the NSArray. You should understand this since we covered it in the tableview tutorial.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return product_array.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:row];
    calc_productid_selected=[itemAtIndex objectForKey:@"ProductId"];
    NSString *product_name = @"   ";
    product_name = [product_name stringByAppendingString:[itemAtIndex objectForKey:@"ProductName"]];
    
    doctprice=[[itemAtIndex objectForKey:@"DoctorPrice"] floatValue];
    //doctor_price_label.text =[NSString stringWithFormat: @"%.2f", doctprice];
    doctor_price_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    NSString *sing_dollar = @"S$";
    doctor_price_label.text=[sing_dollar stringByAppendingString:[NSString stringWithFormat: @"%.2f", doctprice]];
    
    [product_button setTitle:product_name forState:UIControlStateNormal];
    product_picker.showsSelectionIndicator = YES;
    product_picker.hidden= NO;
    toolbar.hidden = NO;
    
}

- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    product_picker.hidden=YES;
    toolbar.hidden = YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = product_picker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, product_picker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
    }
}

-(IBAction)Get_product
{
    if([product_picker isHidden])
    {
        toolbar.hidden = NO;
        product_picker.hidden=NO;
    }
    else
    {
        toolbar.hidden = YES;
        product_picker.hidden=YES;
    }
}

-(IBAction)calculate_btn_clicked
{
    [main_quantity resignFirstResponder];
    [bonus_quantity resignFirstResponder];
    [unofficial_bonus resignFirstResponder];
    product_picker.hidden = YES;
    toolbar.hidden = YES;
    NSLog(@" Product Button %@",product_button.titleLabel.text);
    NSLog(@"main qty%u",[main_quantity.text length]);
    if(([main_quantity.text length] == 2) || ([bonus_quantity.text length] == 2) || ([product_button.titleLabel.text isEqualToString:@"   Search By Product"]))
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please fill in all the fields to calculate price" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        if([unofficial_bonus.text length] == 2)
        {
            next_button.hidden = YES;
            previous_button.hidden = YES;
        }
        else
        {
            next_button.hidden = YES;
            previous_button.hidden = NO;
        }
        
        [self.view endEditing:YES];
        float main_qty=[main_quantity.text floatValue];
        float bonus_qty=[bonus_quantity.text floatValue];
        float un_bonus=[unofficial_bonus.text floatValue];
        calculate_result = (doctprice*main_qty)/(main_qty+bonus_qty+un_bonus);
        //NSLog(@"Result:%f",calculate_result);
        NSString *sing_dollar = @"S$";
        
        NSString *result =[NSString stringWithFormat: @"%.2f", calculate_result];
        result_label.text=[sing_dollar stringByAppendingString:result];
        result_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
        
    }
}

-(IBAction)next_btn_clicked
{
    previous_button.hidden = NO;
    next_button.hidden = YES;
    float main_qty=[main_quantity.text floatValue];
    float bonus_qty=[bonus_quantity.text floatValue];
    float un_bonus=[unofficial_bonus.text floatValue];
    calculate_result = (doctprice*main_qty)/(main_qty+bonus_qty+un_bonus);
    //NSLog(@"Result:%f",calculate_result);
    NSString *sing_dollar = @"S$";
    
    NSString *result =[NSString stringWithFormat: @"%.2f", calculate_result];
    result_label.text=[sing_dollar stringByAppendingString:result];
    result_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
}

-(IBAction)previous_btn_clicked
{
    next_button.hidden = NO;
    previous_button.hidden = YES;
    float main_qty=[main_quantity.text floatValue];
    float bonus_qty=[bonus_quantity.text floatValue];
    float un_bonus = 0;
    calculate_result = (doctprice*main_qty)/(main_qty+bonus_qty+un_bonus);
    //NSLog(@"Result:%f",calculate_result);
    NSString *sing_dollar = @"S$";
    
    NSString *result =[NSString stringWithFormat: @"%.2f", calculate_result];
    result_label.text=[sing_dollar stringByAppendingString:result];
    result_label.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
}


// Function to allow only numbers on keyboard
- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string
{
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if (range.length == 1)
    {
        return YES;
    }
    else
    {
        return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = -70; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationLandscapeRight;
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


@end
