//
//  LocationItemsFlipsideViewController.h
//  LocationItems
//
//  Created by TakahisaFuruta on 2014/05/23.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class LocationItemsFlipsideViewController;

@protocol LocationItemsFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(LocationItemsFlipsideViewController *)controller;
@end

@interface LocationItemsFlipsideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) id <LocationItemsFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
