//
//  ProductManager.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductManager : NSObject
{
    NSMutableData *responseData;
}
- (NSString*)GetProductList;
//Added by rohit modi
- (NSString*)GetProductListUsingClinicId:(NSString*)clinicId;
//end
- (NSString*)GetDivisionList;
- (NSString*)GetAllProductList:(id)product_object;
- (NSString*)GetSampleRequestList:(id)product_object;
- (NSString*)GetSampleReturntList:(id)product_object;
- (NSString*)GetSampleDetails:(id)product_object;
- (NSString*)GetNewProductLists:(id)product_object;
@end
