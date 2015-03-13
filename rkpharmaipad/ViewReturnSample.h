//
//  ViewReturnSample.h
//  RKPharma
//
//  Created by Shiven on 9/17/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewReturnSample : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *returnsample_array;
}

- (IBAction)Back:(id)sender;
@end