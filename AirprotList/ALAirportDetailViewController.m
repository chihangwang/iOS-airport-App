//
//  ALAirportDetailViewController.m
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/2/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import "ALAirportDetailViewController.h"
#import <Social/Social.h>

@interface ALAirportDetailViewController ()

@end

@implementation ALAirportDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.airportDetailFromSegue[ALAirportNameKey];
    self.name.text = self.airportDetailFromSegue[ALAirportNameKey];
    self.country.text = self.airportDetailFromSegue[ALCountryKey];
    self.city.text = self.airportDetailFromSegue[ALCityKey];
    self.itatNumber.text = self.airportDetailFromSegue[ALIataKey];
    self.localName.text = self.airportDetailFromSegue[ALAirportLocalizedNameKey];
    
    NSString *imgURL = self.airportDetailFromSegue[ALImageUrlKey];
    NSURL *url = [NSURL URLWithString:imgURL];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];//asycronizationally download the picture!!!
    [NSURLConnection
     sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if(!error){
             UIImage *AirportImage = [UIImage imageWithData:data];
             self.image.image = AirportImage;
         }else{
             NSLog(@"%@", error);
         }
     }];
}

- (IBAction)clickShareButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a sharing method"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook", @"Twitter", @"More", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        // Facebook
        [self shareToSocialNetwork:SLServiceTypeFacebook];
    } else if (buttonIndex==1) {
        // Twitter
        [self shareToSocialNetwork:SLServiceTypeTwitter];
    } else if (buttonIndex==2) {
        // More
        [self shareToMoreServices];
    }
}

#pragma mark - Share methods

- (void)shareToSocialNetwork:(NSString *)serviceType {
    SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    [composer setInitialText:self.airportDetailFromSegue[ALAirportNameKey]];
    [composer addImage:self.image.image];
    
    composer.completionHandler = ^(SLComposeViewControllerResult result) {
        NSString *title = nil;
        if (serviceType==SLServiceTypeFacebook)
            title = @"Post to Facebook";
        else if (serviceType==SLServiceTypeTwitter)
            title = @"Post to Twitter";
        
        NSString *message = nil;
        if (result==SLComposeViewControllerResultCancelled) message = @"Canceled.";
        else if (result==SLComposeViewControllerResultDone) message = @"Posted!";
        else message = @"Unknown";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    };
    [self presentViewController:composer animated:YES completion:nil];
}

- (void)shareToMoreServices {
    NSArray *activities = @[self.airportDetailFromSegue[ALAirportNameKey], self.image.image];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:activities
                                                        applicationActivities:nil];
    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSLog(@"%@, %@", activityType, completed?@"Success":@"Faile");
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}


- (IBAction)seeWikipedia:(id)sender
{
    NSString *WikiURL = self.airportDetailFromSegue[ALWikiUrlKey];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: WikiURL]];
}

@end
