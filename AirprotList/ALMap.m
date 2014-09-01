//
//  ALMap.m
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/22/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import "ALMap.h"

@interface ALMap ()

@property (nonatomic, readwrite, strong) NSArray * airports;

@end

@implementation ALMap

+ (NSArray*) arrayWithAirportsMapAndDetail {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AirportList" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *err = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    NSMutableArray *buffer = [[NSMutableArray alloc] init];
    for (NSDictionary *airportDic in array){
        [buffer addObject:[ALAirport airportWithAirportDict:airportDic]];
    }
    return buffer;
}

#pragma mark - Cache

+ (NSCache *)sharedCache {
    static NSCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}


@end


@interface ALAirport ()

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite, strong) NSDictionary *airportDictionary;

@end

@implementation ALAirport

+ (instancetype) airportWithAirportDict:(NSDictionary *)airportDict {
    ALAirport *airport = [[ALMap sharedCache] objectForKey: airportDict[ALAirportNameKey]];
    if(!airport){
    
        airport = [[ALAirport alloc] init];
        airport.coordinate = CLLocationCoordinate2DMake([airportDict[ALLatitude] doubleValue],
                                                        [airportDict[ALLongitude] doubleValue]);
        airport.title = airportDict[ALAirportNameKey];
        airport.subtitle = airportDict[ALIataKey];
        airport.airportDictionary = airportDict;
        
        [[ALMap sharedCache] setObject:airportDict forKey:airportDict[ALAirportNameKey]];
    }
    return airport;
}

@end