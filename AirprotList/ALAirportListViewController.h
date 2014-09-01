//
//  ALAirportListViewController.h
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/2/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALCountryListViewController.h"
#import "ALDataSource.h"
#import "ALAirportDetailViewController.h"

@interface ALAirportListViewController : UITableViewController {
    NSMutableArray *ArrayWithInitials;
    NSString *SelectedAirportFromSender;
}

@property (strong, nonatomic) NSString* CountryFromSegue;

@end
