//
//  ClinicManager.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "ClinicManager.h"
#import "WebService.h"

@implementation ClinicManager

- (NSString*)GetClinicList:(id)clinic_object
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetClinicList:clinic_object];
    return string;//get and return webservice response 
}

- (NSString*)GetClinicNameList:(id)clinic_object
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetClinicNameList:clinic_object];
    return string;//get and return webservice response 
}

- (NSString*)GetAllClinicList
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetAllClinicList];
    return string;//get and return webservice response
}

- (NSString*)GetClinicDetail:(id)clinic_object
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetClinicDetail:clinic_object];
    return string;//get and return webservice response 
}

- (NSString*)GetSpecialization
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetSpecialization];
    return string;//get and return webservice response 
}

- (NSString*)GetKIVProducts:(id)KIV_object
{
    //Call webservice method of Clinic
    WebService *web=[[WebService alloc]init];
    NSString *string=[web GetProductsKIV:KIV_object];
    return string;//get and return webservice response
}



@end
