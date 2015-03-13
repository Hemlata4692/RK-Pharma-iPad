//
//  ProductManager.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "ProductManager.h"
#import "WebService.h"

@implementation ProductManager

- (NSString*)GetProductList
{
    //Call webservice method of Order
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetProductList];
    return string;//get and return webservice response 
}

- (NSString*)GetAllProductList:(id)product_object
{
    
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetAllProductList:product_object];
    return string;//get and return webservice response
}

- (NSString*)GetSampleRequestList:(id)product_object
{
    //Call webservice method of Order
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetSampleRequestList:product_object];
    return string;//get and return webservice response
}

- (NSString*)GetSampleDetails:(id)product_object
{
    //Call webservice method of Order
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetSampleDetails:product_object];
    return string;//get and return webservice response
}

- (NSString*)GetSampleReturntList:(id)product_object
{
    //Call webservice method of Order
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetSampleReturnList:product_object];
    return string;//get and return webservice response
}

- (NSString*)GetNewProductLists:(id)product_object
{
    
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetNewProductsLists:product_object];
    return string;//get and return webservice response
}

@end
