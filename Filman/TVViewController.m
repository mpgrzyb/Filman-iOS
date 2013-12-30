//
//  TVViewController.m
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import "TVViewController.h"
#import "MoviesViewController.h"

@interface TVViewController ()
@property (nonatomic, strong) NSURLConnection *conn;
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
    self.responseData = [[NSMutableData alloc] init];
    [self downloadTVChannels];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    self.title = @"Wybór kanału TV";
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - Prepere for segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToMovieListTV"]){
        MoviesViewController *moviesViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tvChannelsTable indexPathForSelectedRow];
        NSDictionary *tmpDictionary = [self.tvChannelsList objectAtIndex:indexPath.row];
        [moviesViewController setSelectedCity:@"tv"];
        [moviesViewController setCinemaName:[tmpDictionary objectForKey:@"nazwa_kanalu"]];
    }
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
    NSDictionary *tmpDictionary = [self.tvChannelsList objectAtIndex:indexPath.row];
    cell.textLabel.text = [tmpDictionary objectForKey:@"nazwa_kanalu"];
    return cell;
}

#pragma mark - Download TV Channels GET METHOD

-(void) downloadTVChannels{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.selectedCity = [userDefaults objectForKey:@"city"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://filman.pl/ios/channels/"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    self.conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

#pragma mark - Server Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
    
    self.tvChannelsList = [dictionary objectForKey:@"channels"];

    if ([self.tvChannelsList count] == 0) {
        [self.message setText:@"Brak wyników..."];
        self.tvChannelsTable.hidden = YES;
    }else{
        [self.tvChannelsTable reloadData];
        [self.message setHidden:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }
}


@end
