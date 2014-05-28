//
//  LocationItemsMainViewController.h
//  LocationItems
//
//  Created by TakahisaFuruta on 2014/05/23.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "LocationItemsFlipsideViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationItemsMainViewController : UIViewController <LocationItemsFlipsideViewControllerDelegate,CBPeripheralDelegate,UITextFieldDelegate>

@end
