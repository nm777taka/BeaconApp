//
//  LIBeaconRegion.h
//  LocationItems
//
//  Created by 古田貴久 on 2014/05/30.
//  Copyright (c) 2014年 古田貴久. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface LIBeaconRegion : CLBeaconRegion

@property BOOL rangingEnabled;
@property BOOL isMonitoring;
@property BOOL hasEntered;
@property BOOL isRanging;

@property NSUInteger failCount;

@property NSArray *beacons;

- (void)clearFlags;

@end
