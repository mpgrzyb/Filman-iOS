//
//  MovieDetailsViewController.h
//  Filman
//
//  Created by Mateusz Grzyb on 06.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *message;

@property (strong, nonatomic) IBOutlet UILabel *movieTitle;
@property (strong, nonatomic) IBOutlet UILabel *rate;
@property (strong, nonatomic) IBOutlet UILabel *director;
@property (strong, nonatomic) IBOutlet UILabel *genres;
@property (strong, nonatomic) IBOutlet UILabel *runtime;
@property (strong, nonatomic) IBOutlet UILabel *releaseDate;
@property (strong, nonatomic) IBOutlet UILabel *description;

@property (strong, nonatomic) NSString *idMovie;
@property (strong, nonatomic) NSString *selectedCity;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) Movie *movie;

-(void) downloadMovieDetails;
@end
