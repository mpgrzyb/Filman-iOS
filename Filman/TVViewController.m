//
//  TVViewController.m
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import "TVViewController.h"

@interface TVViewController ()

@end

@implementation TVViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tvChannelsList = self.downladTV;
    if ([self.tvChannelsList count] == 0) {
        [self.message setText:@"Brak wyników..."];
        self.tvChannelsTable.hidden = YES;
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    self.title = @"Wybór kanału TV";
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Cinemas TableView

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int number = [self.tvChannelsList count];
    return number;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    int number = 1;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.tvChannelsList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Download TV Channels

-(void) downloadTVChannels:(NSString*) data{
//    //    NSString *post = [NSString stringWithFormat:@"&miasto=%@", city];
//    NSString *post = [NSString stringWithFormat:@"&data=%@", [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://filman.pl/ios/cinemas/"]]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
//    [request setHTTPBody:postData];
//    self.conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

#pragma mark - Server Connection

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [self.responseData appendData:data];
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
//    self.cinemasList = [dictionary objectForKey:@"cinemas"];
//    [self.cinemasTable reloadData];
//    
//    if ([self.cinemasList count] == 0) {
//        [self.message setText:@"Brak wyników..."];
//    }
//    else{
//        [self.tableView setHidden:NO];
//    }
//    [self.activityIndicator stopAnimating];
//}


@end
