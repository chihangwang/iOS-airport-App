//
//  ALMap.h
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/22/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ALDataSource.h"

#define ALLatitude @"Latitude"
#define ALLongitude @"Longitude"

@interface ALMap : NSObject

@property (nonatomic, strong, readonly) NSArray * airports;
+ (NSArray* )arrayWithAirportsMapAndDetail;

@end




@interface  ALAirport : MKPointAnnotation

@property (strong, nonatomic, readonly) NSDictionary *airportDict;
+ (instancetype)airportWithAirportDict:(NSDictionary *)airportDict;

@end