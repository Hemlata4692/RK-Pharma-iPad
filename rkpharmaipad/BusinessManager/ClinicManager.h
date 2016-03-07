//
//  ClinicManager.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClinicManager : NSObject
{
    NSMutableData *dailyplan_responseData;
}
- (NSString*)GetClinicList:(id)clinic_object;
- (NSString*)GetClinicNameList:(id)clinic_object;
- (NSString*)GetClinicDetail:(id)clinic_object;
- (NSString*)GetSpecialization;
- (NSString*)GetKIVProducts:(id)KIV_object;
- (NSString*)GetAllClinicList;
@end
