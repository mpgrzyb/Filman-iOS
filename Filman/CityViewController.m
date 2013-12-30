//
//  CityViewController.m
//  Filman
//
//  Created by Mateusz Grzyb on 05.11.2013.
//  Copyright (c) 2013 Mateusz Grzyb. All rights reserved.
//

#import "CityViewController.h"
#import "CinemasViewController.h"

@interface CityViewController ()
-(void) createPickerView;
@end

@implementation CityViewController

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
    [self.navigationController.navigationBar setHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createPickerView];
    self.cities = [NSArray arrayWithObjects:@"Radom", @"Warszawa", @"Łódź", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PickerView

-(void) createPickerView{
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 120, 280, 220)];
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    [self.view addSubview:self.picker];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = [self.cities count];
    return numRows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [self.cities objectAtIndex:row];
    
    return title;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    int width = 220;
    return width;
}

#pragma mark - User Defaults

- (IBAction)okKlik:(id)sender {
    int selectedRowIndex = [self.picker selectedRowInComponent:0];
    NSString *selectedCity = [self.cities objectAtIndex:selectedRowIndex];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:selectedCity forKey:@"city"];
}
@end
