//
//  MoviesViewController.m
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "Event.h"
#import "MovieDetailsViewController.h"

@interface MoviesViewController ()
@property (nonatomic, strong) NSURLConnection *conn;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [self.activityIndicator setHidden:NO];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.responseData = [[NSMutableData alloc] init];
    self.title = @"Wybór filmu";
    [self.tableView setHidden:YES];
    self.moviesList = [[NSMutableArray alloc] init];
    [self.activityIndicator startAnimating];
    [self downloadMoviesList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"goToMovieDetails"]){
        NSDate *todaysDate = [[NSDate alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *date = [dateFormatter stringFromDate:todaysDate];
        
        MovieDetailsViewController *movieDetailsViewController = [segue destinationViewController];
        NSInteger selectedRow = [[self.tableView indexPathForSelectedRow] row];
        
        [movieDetailsViewController setIdMovie:[(Event*)[self.moviesList objectAtIndex:selectedRow] idMovie]];
        [movieDetailsViewController setSelectedCity:[self selectedCity]];
        [movieDetailsViewController setDate:date];
    }
}

#pragma mark - Movies TableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    int number = 1;
    return number;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int number = [self.moviesList count];
    return number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"Cell";
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    
    cell.title.text = [(Event*)[self.moviesList objectAtIndex:indexPath.row] title];
    cell.description.text = [(Event*)[self.moviesList objectAtIndex:indexPath.row] description];
    cell.time.text = [(Event*)[self.moviesList objectAtIndex:indexPath.row] time];
    cell.poster.image = [(Event*)[self.moviesList objectAtIndex:indexPath.row] poster];
    
    return cell;
}

#pragma mark - Download Movies

-(void) downloadMoviesList{
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [DateFormatter stringFromDate:[NSDate date]];

    NSString *post = [NSString stringWithFormat:@"&miasto=%@&miejsce=%@&data=%@", [self.selectedCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [self.cinemaName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], date];

    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://filman.pl/ios/events/"]]];
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
    NSArray *tmpArray = [dictionary objectForKey:@"movies"];
    
    dispatch_queue_t downloadingEvents = dispatch_queue_create("downloading events", NULL);
    dispatch_sync(downloadingEvents, ^{
        for(NSDictionary *tmpDictionary in tmpArray){
//            NSLog(@"%@", tmpDictionary);
            Event *event = [[Event alloc] init];
            event.idMovie = [tmpDictionary objectForKey:@"id_pozycja"];
            event.description = [[[tmpDictionary objectForKey:@"czas_trwania"] stringByAppendingString:@" - "] stringByAppendingString:[tmpDictionary objectForKey:@"gatunek"]];
            event.time = [tmpDictionary objectForKey:@"godziny"];
            event.title = [tmpDictionary objectForKey:@"nazwa_wydarzenie"];
            
            NSURL *posterURL = [NSURL URLWithString:[tmpDictionary objectForKey:@"plakat_mini"]];
            NSData *data = [NSData dataWithContentsOfURL:posterURL];
            UIImage *poster = [UIImage imageWithData:data];
            event.poster = poster;
            
            [self.moviesList addObject:event];
        }
        
        [self.tableView reloadData];
        
        if ([self.moviesList count] == 0) {
            [self.message setText:@"Brak wyników..."];
            [self.activityIndicator setHidden:YES];
        }
        else{
            [self.tableView setHidden:NO];
            [self.message setText:@""];
        }
        [self.activityIndicator stopAnimating];
    });
    
    
}

@end
