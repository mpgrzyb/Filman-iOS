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
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *alphaView;

@end

@implementation MovieDetailsViewController
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
    [self.activityIndicator startAnimating];
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
    [self.movie setDescription:[movieData objectForKey:@"opis"]];
    [self.movie setPosterURL:[movieData objectForKey:@"plakat"]];

    [self showMovieDetails];
    [self.waitView setHidden:YES];
    [self.activityIndicator stopAnimating];
}

-(void) showMovieDetails{
    
    dispatch_queue_t downloadingPhoto = dispatch_queue_create("downloading events", NULL);
    dispatch_sync(downloadingPhoto, ^{
        NSURL *posterURL = [[NSURL alloc] initWithString:self.movie.posterURL];
        NSData *posterData = [[NSData alloc] initWithContentsOfURL:posterURL];
        UIImage *image = [[UIImage alloc] initWithData:posterData];
        [self.poster setImage:image];
    });
    [self.alphaView setHidden:NO];
    
    [self.movieTitle setText:self.movie.title];
    [self.rate setText:self.movie.rate];
    [self.director setText:self.movie.director];
    [self.genres setText:self.movie.genre];
    [self.runtime setText:self.movie.time];
    [self.releaseDate setText:self.movie.releaseDate];
    [self.description setText:self.movie.description];
    if ([self.description.text length] == 0) {
        [self.descriptionLabel setHidden:YES];
    }
}
@end
