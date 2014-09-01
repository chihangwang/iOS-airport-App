//
//  ALDataSource.m
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/2/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import "ALDataSource.h"

@interface ALDataSource () {
    NSCache *cache;
}

@end

@implementation ALDataSource

+ (ALDataSource* )sharedDataSource {
    static ALDataSource *sharedInstance;
    static dispatch_once_t oncetoken;
    dispatch_once (&oncetoken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (ALDataSource*)init {
    if(self = [super init]){
        NSString *path = [[NSBundle mainBundle] pathForResource: @"AirportList" ofType: @"json"];
        NSData *data = [NSData dataWithContentsOfFile: path];
        NSError *err = nil;
        
        airportList = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        cache = [[NSCache alloc] init];
    }
    return self;
}

- (void)cleanCache {
    [cache removeAllObjects];
}

- (NSArray* ) arrayWithCountry {
    NSString* cacheKey = @"arrayWithCountry";
    NSArray *result = [cache objectForKey:cacheKey];
    
    if (!result) {
        NSMutableSet *CountrySet = [NSMutableSet set];
        for (NSDictionary *AirportInCountry in airportList){
            if ([CountrySet containsObject:AirportInCountry[ALCountryKey]]){
                continue;
            }
            [CountrySet addObject:AirportInCountry[ALCountryKey]];
        }
        result = [CountrySet allObjects];
        result = [result sortedArrayUsingComparator:^NSComparisonResult(NSString *airport1, NSString *airport2){
            return [airport1 compare:airport2];
        }];
        [cache setObject:result forKey:cacheKey];
    }
    
    return result;
}

- (NSArray* ) arrayWithAirportsInCountry:(NSString *)countryName {
    NSString *cacheKey = [NSString stringWithFormat:@"arrayWithAirportIn-%@", countryName];
    NSArray *result = [cache objectForKey:cacheKey];
    
    if (!result) {
        NSMutableSet *AirportInCountrySet = [NSMutableSet set];
        for (NSDictionary *AirportInCountry in airportList){
            if (AirportInCountry[ALCountryKey]==countryName){
                [AirportInCountrySet addObject:AirportInCountry[ALAirportNameKey]];
            }
        }
        result = [AirportInCountrySet allObjects];
        result = [result sortedArrayUsingComparator:^NSComparisonResult(NSString *airport1, NSString *airport2){
            return [airport1 compare:airport2];
        }];
        [cache setObject:result forKey:cacheKey];
    }
    
    return result;
}

- (NSDictionary* ) dictionaryWithAirportAtIndexPath:(NSIndexPath *)IndexPath { //never been used here...
    NSString *countryName = [self arrayWithCountry][IndexPath.section];
    NSDictionary *airport = [self arrayWithAirportsInCountry:countryName][IndexPath.row];
    return airport;
}

- (NSDictionary* ) dictionaryWithAirportDetailByName:(NSString* )AirportName {
    NSDictionary *selectedAirport = [[NSDictionary alloc] init];
    for (NSDictionary *airport in airportList){
        if([airport[ALAirportNameKey] isEqualToString:AirportName]){
            selectedAirport = airport;
            break;
        }
    }
    return selectedAirport;
}

@end
