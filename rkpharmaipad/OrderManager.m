//
//  OrderManager.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "OrderManager.h"
#import "WebService.h"

@implementation OrderManager

- (NSString*)RepeatDeliveryTerm:(id)order_object
{
    //Call webservice method of Order
    WebService *web=[[WebService alloc]init];
    NSString *string=[web RepeatDeliveryTerm:order_object];
    return string;//get and return webservice response
}
- (NSString*)GetOrderList:(id)order_object
{
    //Call webservice method of Order
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetOrderList:order_object];
    return string;//get and return webservice response 
}

- (NSString*)GetOrderGtotal:(id)order_object
{
    //Call webservice method of Order
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetOrdersTotal:order_object];
    return string;//get and return webservice response 
}
- (NSString*)GetProductInfo:(id)order_object
{
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetProductInfo:order_object];
    return string;//get and return webservice response
}
- (NSString*)RepeatProduct:(id)order_object
{
    WebService *web=[[WebService alloc]init];
    NSString *string=[web RepeatProductInfo:order_object];
    return string;//get and return webservice response
}
- (NSString*)AddOrder:(id)product_object
{
    
    
    WebService *web=[[WebService alloc]init];
    NSString *str=[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderId"];
    NSString *string;
    if(str.length!=0)
    {
        string=[web EditOrder:product_object];
    }
    else{
        string=[web AddOrder:product_object];
    }
    return string;//get and return webservice response

    
}
- (NSString*)getOrderData:(id)order_object
{
    WebService *web=[[WebService alloc]init];
    NSString *string=[web getOrderData:order_object];
    return string;//get and return webservice response
}
@end
