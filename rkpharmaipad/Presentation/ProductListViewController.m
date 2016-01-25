//
//  ProductListViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "ProductListViewController.h"
#import "JSON.h"
#import "ProductManager.h"
#import "Product.h"

int productoffset = 0;

@interface ProductListViewController ()

@end

@implementation ProductListViewController
@synthesize product_table;
@synthesize product_name,batch_no,doctor_price,list_price,main_stock_qty,expiry_date,indicator,sno;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)ProductService
{
    //Create domain class object
    Product *product=[[Product alloc]init];
    NSString *offsetstring = [NSString stringWithFormat:@"%d",productoffset];
    product.offset = offsetstring;
    
    //Create business manager class object
    ProductManager *product_business=[[ProductManager alloc]init];
    NSString *response=[product_business GetAllProductList:product];//call businessmanager method
    NSLog(@" Products List response is %@",response);
    
    if (response.length !=0) 
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict result List%@",var);
        
        for(NSDictionary *dictvar in var)
        {
            float list_price_float = [[dictvar objectForKey:@"ListPrice"] floatValue];
            if (list_price_float == (float)0) {
                
                
            }
            else{
                
            [product_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"ProductName"],@"ProductName",[dictvar objectForKey:@"BatchNo"],@"BatchNo",[dictvar objectForKey:@"DoctorPrice"],@"DoctorPrice",[dictvar objectForKey:@"ListPrice"],@"ListPrice",[dictvar objectForKey:@"Quantity"],@"Quantity",[dictvar objectForKey:@"ExpiryDate"],@"ExpiryDate",nil]];
            }
        }
        [product_table reloadData];
        NSLog(@" Count Product Array %d",product_array.count);
        
        if(product_array.count == 0)
        {
            self.product_table.frame = CGRectMake(10,7,821,0); 
        }
        else if(product_array.count == 1)
        {
            self.product_table.frame = CGRectMake(10,7,821,102); 
        }
        else if(product_array.count == 2)
        {
            self.product_table.frame = CGRectMake(10,7,821,204); 
        }
        else if(product_array.count == 3)
        {
            self.product_table.frame = CGRectMake(10,7,821,306); 
        }
        else if(product_array.count == 4)
        {
            self.product_table.frame = CGRectMake(10,7,821,408); 
        }
        else if(product_array.count == 5)
        {
            self.product_table.frame = CGRectMake(10,7,821,510); 
        }
        else if(product_array.count == 6)
        {
            self.product_table.frame = CGRectMake(10,7,821,612); 
        }
        else if(product_array.count >= 7)
        {
            self.product_table.frame = CGRectMake(10,7,821,714); 
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    productoffset = 0;
    product_array = [[NSMutableArray alloc]init];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //To Hide Extra separators at the footer of tableview
    self.product_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    [self ProductService];
    
    indicator.hidden = YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height) 
    {
        if(product_array.count >= productoffset && product_array.count >= 20)
        {
            indicator.hidden = NO;
            [self.indicator startAnimating];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
            {
                productoffset = productoffset + 20;
                [self ProductService];    
                [self.indicator stopAnimating];
                indicator.hidden = YES;
            });
        }
	}
    
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
    return 102;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"productlist_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row == 0)
    {
        UIImage *background_first = [UIImage imageNamed:@"listingbg_top.png"];
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background_first];
        cellBackgroundView.image = background_first;
        cell.backgroundView = cellBackgroundView;
        
    }
    else
    {
        UIImage *background = [UIImage imageNamed:@"listingbg_new.png"];
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
        cellBackgroundView.image = background;
        cell.backgroundView = cellBackgroundView;
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[product_array objectAtIndex:indexPath.row];
    
    product_name=(UILabel *)[cell viewWithTag:1];
    product_name.text = [itemAtIndex objectForKey:@"ProductName"];
    product_name.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    batch_no=(UILabel *)[cell viewWithTag:2];
    batch_no.text = [itemAtIndex objectForKey:@"BatchNo"];
    batch_no.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    doctor_price=(UILabel *)[cell viewWithTag:3];
    float doctor_price_float = [[itemAtIndex objectForKey:@"DoctorPrice"] floatValue];
    doctor_price.text =[NSString stringWithFormat: @"%.2f", doctor_price_float];
    doctor_price.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    UILabel *label=(UILabel*)[cell viewWithTag:8];
    list_price=(UILabel *)[cell viewWithTag:4];
    float list_price_float = [[itemAtIndex objectForKey:@"ListPrice"] floatValue];
    if (list_price_float == (float)0) {
        list_price.hidden = YES;
        label.hidden=YES;
        
    }
    else{
        list_price.hidden = NO;
        label.hidden=NO;
    }
    list_price.text =[NSString stringWithFormat: @"%.2f", list_price_float];
    list_price.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
//    main_stock_qty=(UILabel *)[cell viewWithTag:5];
//    NSInteger main_stock_quantity_int = [[itemAtIndex objectForKey:@"Quantity"] integerValue];
//    main_stock_qty.text = [NSString stringWithFormat:@"%d",main_stock_quantity_int];
//    main_stock_qty.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
//    
    expiry_date=(UILabel *)[cell viewWithTag:6];
    expiry_date.text = [itemAtIndex objectForKey:@"ExpiryDate"];
    expiry_date.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    sno=(UILabel *)[cell viewWithTag:7];
    NSString *sno_string = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    sno_string = [sno_string stringByAppendingString:@"."];
    sno.text = sno_string;
    sno.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    return cell;
}

@end