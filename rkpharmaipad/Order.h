//
//  Order.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
{
    NSString *clinic_name,*product_name,*order_quantity,*date,*invoice_no,*bonus,*unofficial_bonus,*status,*dateto_string,*datefrom_string,*location_id,*specialization_id,*offset,*product_id,*clinic_id,*order_id;
    //NSMutableArray *doctors,*Business_hours;
}
@property (nonatomic, retain) NSString *clinic_name,*product_name,*order_quantity,*date,*invoice_no,*bonus,*unofficial_bonus,*status,*dateto_string,*datefrom_string,*location_id,*specialization_id,*offset,*product_id,*clinic_id,*order_id;


@end
