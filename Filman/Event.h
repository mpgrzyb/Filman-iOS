//
//  Event.h
//  Filman
//
//  Created by Mateusz Grzyb on 15.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
@property (nonatomic, strong) NSString *idMovie;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) UIImage *poster;
@end
