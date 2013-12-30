//
//  CityViewController.h
//  Filman
//
//  Created by Mateusz Grzyb on 05.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityViewController : UIViewController<UIPickerViewDelegate>
- (IBAction)okKlik:(id)sender;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) UIPickerView *picker;
@end
