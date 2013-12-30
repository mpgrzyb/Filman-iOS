//
//  Movie.h
//  Filman
//
//  Created by Mateusz Grzyb on 12.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property (nonatomic, strong) NSString *idMovie;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *posterURL;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *cast;
@property (nonatomic, strong) NSString *description;
@end
