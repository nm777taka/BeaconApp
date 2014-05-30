//
//  LIBeacon.h
//  LocationItems
//
//  Created by 古田貴久 on 2014/05/30.
//  Copyright (c) 2014年 古田貴久. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "LIBeaconRegion.h"

typedef enum  {
    kLIBeaconMonitoringStatusDisabld,
    kLIBeaconMonitoringStatusStopped,
    kLIBeaconMonitoringStatusMonitoring,
} LIBeaconMonitoringStatus;

@interface LIBeacon : NSObject <CLLocationManagerDelegate,CBPeripheralManagerDelegate>

@property NSMutableArray *regions;

+ (LIBeacon *)sharedManager;

- (void)startMonitoring;
- (void)stopMonitoring;
- (void)requestUpdateForStatus;

- (void)unregisterAllRegion;

@end
