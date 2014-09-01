//
//  ALAirportListViewController.m
//  AirprotList
//
//  Created by Wang Chih-Ang on 11/2/13.
//  Copyright (c) 2013 Chih-Ang Wang. All rights reserved.
//

#import "ALAirportListViewController.h"

@interface ALAirportListViewController () 

@end

@implementation ALAirportListViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
// 
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   //debug done!!!
{
    ArrayWithInitials = [[NSMutableArray alloc] init];
    NSArray *AirportArray = [[ALDataSource sharedDataSource] arrayWithAirportsInCountry: self.CountryFromSegue];
    NSMutableSet *nameSet = [NSMutableSet set];
    for (NSString *airportName in AirportArray) {
        unichar a = [airportName characterAtIndex:0];
        NSString *initial = [NSString stringWithCharacters:&a length:1];
        if (![nameSet containsObject: initial]){
            [ArrayWithInitials addObject:initial];
            [nameSet addObject:initial];
        }
    }
    return [ArrayWithInitials count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  //debug done!!!
{
    NSArray *AirportArray = [[ALDataSource sharedDataSource] arrayWithAirportsInCountry:self.CountryFromSegue];
    NSInteger count = 0;
    for (NSString *airportName in AirportArray){
        unichar a = [airportName characterAtIndex:0];
        NSString *initial = [NSString stringWithCharacters:&a length:1];
        if ([initial isEqualToString: [ArrayWithInitials objectAtIndex:section]]){
            count++;
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath //debug done!!!
{
    static NSString *CellIdentifier = @"AirportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *LableOfAirportName = (UILabel*)[cell viewWithTag:2001];
    NSString *InitialOfSection = [ArrayWithInitials objectAtIndex:indexPath.section];
    NSArray *AirportArray = [[ALDataSource sharedDataSource] arrayWithAirportsInCountry:self.CountryFromSegue];
    NSInteger count = 0;
    for (NSString *name in AirportArray) {
        unichar a = [name characterAtIndex:0];
        NSString *initial = [NSString stringWithCharacters:&a length:1];
        if([initial isEqualToString:InitialOfSection]){
            count++;
        }
        if (count == indexPath.row+1){
            LableOfAirportName.text = name;
            break;
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [ArrayWithInitials objectAtIndex:section];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AirportDetailCell"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSString *InitialOfSection = [ArrayWithInitials objectAtIndex:indexPath.section];
        NSArray *AirportArray = [[ALDataSource sharedDataSource] arrayWithAirportsInCountry:self.CountryFromSegue];
        NSInteger count = 0;
        for (NSString *name in AirportArray) {
            unichar a = [name characterAtIndex:0];
            NSString *initial = [NSString stringWithCharacters:&a length:1];
            if([initial isEqualToString:InitialOfSection]){
                count++;
            }
            if (count == indexPath.row+1){
                SelectedAirportFromSender = name;
                break;
            }
        }
        
        NSDictionary *airportDetail = [[NSDictionary alloc] init];
        airportDetail = [[ALDataSource sharedDataSource] dictionaryWithAirportDetailByName:SelectedAirportFromSender];
        
        ALAirportDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.airportDetailFromSegue = airportDetail;
        //NSLog(@"Detail of the airport:%@", airportDetail);
    }



}



@end
