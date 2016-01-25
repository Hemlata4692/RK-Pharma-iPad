//
//  ViewReturnSample.m
//  RKPharma
//
//  Created by Shiven on 9/17/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "ViewReturnSample.h"
#import "JSON.h"
#import "Product.h"
#import "DejalActivityView.h"
#import "ProductManager.h"
#import "RKPharmaAppDelegate.h"

@interface ViewReturnSample ()
{
    IBOutlet UITableView *returnsample_table;
    UITextField *return_products,*returnQty,*returnDate,*BatchNo,*ExpDate,*monthyear;
    RKPharmaAppDelegate *AppDel;
}
@end

@implementation ViewReturnSample

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
    [super viewDidLoad];
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];

	// Do any additional setup after loading the view.
    
    returnsample_array = [[NSMutableArray alloc]init];
    
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
            [returnsample_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[var objectForKey:@"SampleId"],@"SampleId",[var objectForKey:@"SampleName"],@"SampleName",[var objectForKey:@"Unit"],@"Unit",[var objectForKey:@"Quantity"],@"Quantity",[var objectForKey:@"BatchNo"],@"BatchNo",[var objectForKey:@"ExpiryDate"],@"ExpiryDate",[var objectForKey:@"ReturnedQuantity"],@"ReturnedQuantity",[var objectForKey:@"ReturnDate"],@"ReturnDate",[var objectForKey:@"IssueMonth"],@"IssueMonth",[var objectForKey:@"IsAccepted"],@"IsAccepted",nil]];
            
        //}
    }
    
        NSLog(@" Main Array %d",returnsample_array.count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return returnsample_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return_products = (UITextField *)[cell viewWithTag:2];
    monthyear = (UITextField *)[cell viewWithTag:1];
    BatchNo = (UITextField *)[cell viewWithTag:3];
    ExpDate = (UITextField *)[cell viewWithTag:4];
    returnDate = (UITextField *)[cell viewWithTag:6];
    returnQty = (UITextField *)[cell viewWithTag:5];
    
    return_products.userInteractionEnabled = NO;
    returnQty.userInteractionEnabled = NO;
    returnDate.userInteractionEnabled = NO;
    BatchNo.userInteractionEnabled = NO;
    returnDate.userInteractionEnabled = NO;
    monthyear.userInteractionEnabled = NO;
    
    NSDictionary *ProductInfo = [returnsample_array objectAtIndex:indexPath.row];
    //NSLog(@"dictionary %@",ProductInfo);
    return_products.text = [ProductInfo valueForKey:@"SampleName"];
    ExpDate.text = [ProductInfo valueForKey:@"ExpiryDate"];
    returnQty.text = [ProductInfo valueForKey:@"ReturnedQuantity"];
    returnDate.text = [ProductInfo valueForKey:@"ReturnDate"];
    BatchNo.text = [ProductInfo valueForKey:@"BatchNo"];
    monthyear.text = [ProductInfo valueForKey:@"IssueMonth"];

    
    return cell;
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

- (IBAction)Back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Return Sample List",@"heading", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
