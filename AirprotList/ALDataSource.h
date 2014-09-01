//
//  ALDataSource.h
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/2/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALAirportNameKey @"Airport name"
#define ALAirportLocalizedNameKey @"Localized Name"
#define ALIataKey @"IATA"
#define ALCityKey @"City"
#define ALCountryKey @"Country"
#define ALImageUrlKey @"Image URL"
#define ALWikiUrlKey @"Wikipedia URL"

@interface ALDataSource : NSObject  {
    NSArray *airportList;
}

+ (ALDataSource *) sharedDataSource;
- (void) cleanCache;
- (NSArray *) arrayWithCountry;
- (NSArray *) arrayWithAirportsInCountry: (NSString* ) countryName;
- (NSDictionary *) dictionaryWithAirportAtIndexPath: (NSIndexPath* ) IndexPath;
- (NSDictionary *) dictionaryWithAirportDetailByName: (NSString* ) AirportName;
@end
