//
//  Product.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
{
    NSString *product_name,*doctor_price,*list_price,*quantity,*expiry_date,*batch_no,*offset,*dateto_string,*datefrom_string,*sampleid;
}
@property (nonatomic, retain) NSString *product_name,*doctor_price,*list_price,*quantity,*expiry_date,*batch_no,*offset,*dateto_string,*datefrom_string,*sampleid;

@end
