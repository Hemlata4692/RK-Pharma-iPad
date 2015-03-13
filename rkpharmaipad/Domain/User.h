//
//  User.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSString *username,*password,*latitude,*longitude;
}
@property (nonatomic, retain) NSString *username,*password,*latitude,*longitude;
@end
