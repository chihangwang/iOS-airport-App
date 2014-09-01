//
//  ALAirportDetailViewController.h
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/2/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALDataSource.h"
#import "ALAirportDetailViewController.h"

@interface ALAirportDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *airportDetailFromSegue; //Dictionary of the selected airport from sender.

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *localName;
@property (weak, nonatomic) IBOutlet UILabel *itatNumber;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *country;

@property (weak, nonatomic) IBOutlet UIImageView *image;

- (IBAction)clickShareButton:(id)sender;
- (IBAction)seeWikipedia:(id)sender;

@end
