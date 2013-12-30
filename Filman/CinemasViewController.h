//
//  CinemasViewController.h
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CinemasViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *cinemasTable;
@property (strong, nonatomic) NSMutableArray *cinemasList;
@property (strong, nonatomic) NSString *selectedCity;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cityButton;
@property (nonatomic, retain) NSMutableData* responseData;
@end
