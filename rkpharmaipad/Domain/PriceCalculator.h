//
//  PriceCalculator.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceCalculator : NSObject
{
    NSString *doctor_price,*main_quantity,*bonus_quantity,*unofficial_bonus;
}
@property (nonatomic, retain) NSString *doctor_price,*main_quantity,*bonus_quantity,*unofficial_bonus;
@end
