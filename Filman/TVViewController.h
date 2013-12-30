//
//  TVViewController.h
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tvChannelsTable;
@property (strong, nonatomic) NSArray *tvChannelsList;
@property (strong, nonatomic) IBOutlet UILabel *message;
-(void) downloadTVChannels:(NSString*) data;
@end
