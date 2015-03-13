//
//  OrderManager.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderManager : NSObject
{
    NSMutableData *responseData;
}
- (NSString*)RepeatDeliveryTerm:(id)order_object;
- (NSString*)RepeatProduct:(id)order_object;
- (NSString*)GetProductInfo:(id)order_object;
- (NSString*)GetOrderList:(id)order_object;
- (NSString*)GetOrderGtotal:(id)order_object;
- (NSString*)AddOrder:(id)product_object;
- (NSString*)getOrderData:(id)order_object;
@end
