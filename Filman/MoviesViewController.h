//
//  MoviesViewController.h
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *moviesList;
@property (strong, nonatomic) NSString *cinemaName;
@property (strong, nonatomic) NSString *selectedCity;
@property (nonatomic, retain) NSMutableData* responseData;
-(void) downloadMoviesList;
@end