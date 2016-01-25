//
//  DataModel.h
//  RKPharma
//
//  Created by shiv vaishnav on 02/08/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SampleRequestDomain;

@interface DataModel : NSObject
//Common Method used for calling webservice
+ (DataModel*) manager : (NSDictionary *)JsonRequest;
+ (SampleRequestDomain *)AddSample: (SampleRequestDomain *)addSample_Obj;
+ (SampleRequestDomain *)ReturnSample: (SampleRequestDomain *)returnSample_Obj;
+ (SampleRequestDomain *)EditReturnSample: (SampleRequestDomain *)returnSample_Obj;
+ (SampleRequestDomain *)GetSampleDetail: (SampleRequestDomain *)addSample_Obj;
+ (SampleRequestDomain *)EditSample: (SampleRequestDomain *)addSample_Obj;
//EditSample
@end
