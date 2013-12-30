//
//  MovieDetailsViewController.m
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "Movie.h"

@interface MovieDetailsViewController ()
@property (nonatomic, strong) NSURLConnection *conn;
-(void) showMovieDetails;
-(void) updateSizeOfElements;
-(void) refreshElements;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation MovieDetailsViewController

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.autoresizesSubviews = YES;
    self.scrollView.contentMode = UIViewContentModeScaleToFill;
    self.contentView.autoresizesSubviews = YES;
    self.contentView.contentMode = UIViewContentModeScaleToFill;
    
    self.date = @"2013-12-29";
    self.selectedCity = @"Radom";
    self.idMovie = @"6168";
//    self.idMovie = @"6817";
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.message setText:@"Proszę czekać..."];
    [self.message setHidden:NO];
    self.movie = [[Movie alloc] init];
    [self downloadMovieDetails];
}

#pragma mark - Download Movie Details

-(void) downloadMovieDetails{
    NSString *post = [NSString stringWithFormat:@"&miasto=%@&id_pozycja=%@&data=%@", [self.selectedCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [self.idMovie stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.date];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://filman.pl/ios/movie/"]]];
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
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *tmpArray = [dictionary objectForKey:@"movies"];
    NSDictionary *movieData = [tmpArray objectAtIndex:0];

    [self.movie setTitle:[movieData objectForKey:@"tytul_pl"]];
    [self.movie setRate:[movieData objectForKey:@"ocena"]];
    [self.movie setDirector:[movieData objectForKey:@"nazwa_rezyser"]];
    [self.movie setGenre:[movieData objectForKey:@"gatunek"]];
    [self.movie setTime:[movieData objectForKey:@"czas_trwania"]];
    [self.movie setReleaseDate:[movieData objectForKey:@"rok_produkcji"]];
    [self.movie setCast:[movieData objectForKey:@"obsada"]];
    [self.movie setDescription:[movieData objectForKey:@"opis"]];

    
    [self.activityIndicator stopAnimating];
    [self.message setHidden:YES];
    [self.activityIndicator setHidden:YES];
    [self showMovieDetails];
}

-(void) showMovieDetails{
    [self.movieTitle setText:self.movie.title];
    [self.rate setText:self.movie.rate];
    [self.director setText:self.movie.director];
    [self.genres setText:self.movie.genre];
    [self.runtime setText:self.movie.time];
    [self.releaseDate setText:self.movie.releaseDate];
    [self.cast setText:self.movie.cast];
    [self.description setText:self.movie.description];
    [self updateSizeOfElements];
}

-(void) updateSizeOfElements{
    [self refreshElements];
    float heightOfAllElemets = self.description.frame.origin.y + self.description.frame.size.height + [[self.navigationController navigationBar] frame].size.height + self.cast.frame.size.height;
    [self.scrollView setContentSize:(CGSizeMake(self.scrollView.frame.size.width, heightOfAllElemets))];
    [self refreshElements];
}

-(void) refreshElements{
    self.movieTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.movieTitle.autoresizesSubviews = YES;
    self.movieTitle.numberOfLines = 0;
    [self.movieTitle sizeToFit];
    
    self.cast.lineBreakMode = NSLineBreakByWordWrapping;
    self.cast.autoresizesSubviews = YES;
    self.cast.numberOfLines = 0;
    [self.cast sizeToFit];
    
    self.description.lineBreakMode = NSLineBreakByTruncatingTail;
    self.description.autoresizesSubviews = YES;
    self.description.numberOfLines = 20;
    [self.description sizeToFit];
}


@end
