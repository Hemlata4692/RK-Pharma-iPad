//
//  ViewSample.m
//  RKPharma
//
//  Created by shiv vaishnav on 16/08/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "ViewSample.h"
#import "ProductManager.h"
#import "JSON.h"

@interface ViewSample ()
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

@implementation ViewSample
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Sample Request",@"heading", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didappear" object:nil];
    [self.view removeFromSuperview];
}
- (void)viewDidLoad
{
    AppDel = (RKPharmaAppDelegate *)[UIApplication sharedApplication].delegate;
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
        // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];

    [super viewDidLoad];
        // Do any additional setup after loading the view.
}
- (void)getData: (NSDictionary *)dict
{
    passDict = dict;
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

    batchNo.userInteractionEnabled = NO;
    expiryDate.userInteractionEnabled = NO;

    if ([[Product_Dictionary objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *ProductInfo = [Product_Dictionary objectAtIndex:indexPath.row];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
