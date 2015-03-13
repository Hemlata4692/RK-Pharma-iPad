//
//  RKPharmaAdoptingAnAnnotation.h
//  RKPharma
//
//  Created by shiv vaishnav on 17/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface RKPharmaAdoptingAnAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coord1;
}
@property(nonatomic) CLLocationCoordinate2D coord1;
//-(CLLocationCoordinate2D) coordinate :(CLLocationCoordinate2D)coord;
@end
