//
//  DataModel.m
//  RKPharma
//
//  Created by shiv vaishnav on 02/08/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "DataModel.h"
#import "WebService.h"
#import "SampleRequestDomain.h"
#import "JSON.h"

static DataModel *manager = nil;
static NSString *responseString;

@implementation DataModel

//Common Method used for calling webservice
+(DataModel*) manager : (NSDictionary *)JsonRequest{
	@synchronized (self){
        manager = nil;
		if (manager == nil) {
            manager = [[self alloc] init];
            WebService *ws=[[WebService alloc] init];
            responseString = [ws call_Webservice:JsonRequest];
		}else {
            return manager;
        }
    }
	return manager;
}
+ (SampleRequestDomain *)AddSample: (SampleRequestDomain *)addSample_Obj
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:addSample_Obj.JsonRequest,@"json",@"AddSampleRequest",@"method_name", nil];
    [self manager:dict];
    NSDictionary *dict1 =[responseString JSONValue];
    addSample_Obj.response = [dict1 valueForKey:@"IsSuccess"]?@"true":@"false";
    return addSample_Obj;
}
+ (SampleRequestDomain *)ReturnSample:(SampleRequestDomain *)returnSample_Obj
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:returnSample_Obj.JsonRequest,@"json",@"ReturnSamples",@"method_name", nil];
    [self manager:dict];
    NSDictionary *dict1 =[responseString JSONValue];
    if(![[dict1 objectForKey:@"IsSuccess"] boolValue])
    {
        // this is the YES case
        returnSample_Obj.response = @"false";
    } else {
        // we end up here in the NO case **OR** if isSuccessNumber is nil
        returnSample_Obj.response = @"true";
    }
    //returnSample_Obj.response = [dict1 valueForKey:@"IsSuccess"]?@"true":@"false";
    return returnSample_Obj;
}
+ (SampleRequestDomain *)EditReturnSample:(SampleRequestDomain *)returnSample_Obj
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:returnSample_Obj.JsonRequest,@"json",@"EditReturnSamples",@"method_name", nil];
    [self manager:dict];
    NSDictionary *dict1 =[responseString JSONValue];
    returnSample_Obj.response = [dict1 valueForKey:@"IsSuccess"]?@"true":@"false";
    return returnSample_Obj;
}


+ (SampleRequestDomain *)GetSampleDetail: (SampleRequestDomain *)addSample_Obj
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:addSample_Obj.JsonRequest,@"json",@"GetsampleRequest",@"method_name", nil];
    [self manager:dict];
    NSDictionary *OuterDict = [responseString JSONValue];
    addSample_Obj.dict = OuterDict;
    return addSample_Obj;
}
+ (SampleRequestDomain *)EditSample: (SampleRequestDomain *)addSample_Obj
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:addSample_Obj.JsonRequest,@"json",@"UpdateSampleRequest",@"method_name", nil];
    [self manager:dict];
    NSLog(@"response %@",responseString);
    NSDictionary *dict1 =[responseString JSONValue];
    addSample_Obj.response = [dict1 valueForKey:@"IsSuccess"]?@"true":@"false";
    return addSample_Obj;
}
@end
