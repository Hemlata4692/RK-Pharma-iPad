//
//  SampleRequestDomain.h
//  RKPharma
//
//  Created by shiv vaishnav on 02/08/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleRequestDomain : NSObject
@property(nonatomic,retain) NSString *JsonRequest,*response;
@property(nonatomic,retain) NSArray *Product_Array;
@property(nonatomic,retain) NSDictionary *dict;
@end
