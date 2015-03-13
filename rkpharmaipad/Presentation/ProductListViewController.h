//
//  ProductListViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *product_table;
    NSMutableData *responseData;
    NSMutableArray *product_array;
    IBOutlet UILabel *product_name,*batch_no,*doctor_price,*list_price,*main_stock_qty,*expiry_date,*sno;
    IBOutlet UIActivityIndicatorView *indicator;
    
}
@property(nonatomic,retain)UITableView *product_table;
@property(nonatomic,retain)UILabel *product_name,*batch_no,*doctor_price,*list_price,*main_stock_qty,*expiry_date,*sno;
@property(nonatomic,retain)UIActivityIndicatorView *indicator;

@end
