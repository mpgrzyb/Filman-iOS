//
//  CinemasViewController.m
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import "CinemasViewController.h"
#import "MoviesViewController.h"

@interface CinemasViewController ()
@property (nonatomic, strong) NSURLConnection *conn;
@end

@implementation CinemasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.tabBarController.tabBar setHidden:NO];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Wybór kina";
    
    [self.tableView setHidden:YES];
    [self.activityIndicator startAnimating];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.selectedCity = [userDefaults objectForKey:@"city"];
    
    //    Sprawdzenie czy jest już wybrane wcześniej przez użytkownika miasto czy nie
    if([self.selectedCity length] == 0){
        [self performSegueWithIdentifier:@"pickCity" sender:self];
    };
    
    [self downloadCinemasList:self.selectedCity];
    [self.cityButton setTitle:self.selectedCity];
    self.responseData = [[NSMutableData alloc] init];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"goToMoviesList"]){
        MoviesViewController *moviesViewController = [segue destinationViewController];
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        NSDictionary *dict = [self.cinemasList objectAtIndex:selectedRow.row];
        [moviesViewController setCinemaName:[dict objectForKey:@"nazwa_kina"]];
        [moviesViewController setSelectedCity:self.selectedCity];
    }
}

#pragma mark - Cinemas TableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    int number = 1;
    return number;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int number = [self.cinemasList count];
    number = [self.cinemasList count];
    return number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [self.cinemasList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"nazwa_kina"];
    return cell;
}

#pragma mark - Download Cinemas

-(void) downloadCinemasList:(NSString*) city{
    NSString *post = [NSString stringWithFormat:@"&miasto=%@", [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://filman.pl/ios/cinemas/"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
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
    self.cinemasList = [dictionary objectForKey:@"cinemas"];
    [self.cinemasTable reloadData];
    
    if ([self.cinemasList count] == 0) {
        [self.message setText:@"Brak wyników..."];
    }
    else{
        [self.tableView setHidden:NO];
    }
    [self.activityIndicator stopAnimating];
}

@end
