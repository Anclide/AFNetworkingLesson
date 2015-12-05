//
//  ViewController.m
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "ViewController.h"
#import "PLCGoogleMapService.h"
#import "PLCPlace.h"
#import "ResultTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) PLCGoogleMapService *service;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [[PLCGoogleMapService alloc] init];
    self.placesSearchBar.delegate = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    self.items = nil;
    [self.table reloadData];
    [self loadPlacesWithTextRequest:searchBar.text];
}

- (void)loadPlacesWithTextRequest:(NSString *)textReqquest {
    [self.service getPlaceswithSearchRequest:textReqquest success:^(NSArray *result) {
        self.items = result;
        [self.table reloadData];
    } failure:^(NSError *error) {
        [self showAlertWithText:error.localizedDescription];
    }];
}

- (void)loadPlacesImages:(PLCPlace *)place {
    if (place.imageURL) {
        [self.service getPhotoOfPlaceWithPhotoReference:place.imageURL success:^(UIImage *image) {
            place.image = image;
            [self.table reloadData];
        }failure:^(NSError *error) {
            [self showAlertWithText:error.localizedDescription];
        }];
    }
}

- (void)showAlertWithText:(NSString *)errorText {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка загрузки!" message:errorText preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"Place_Cell"];
    PLCPlace *place = self.items[indexPath.row];
    cell.placeNameLabel.text = place.name;
    [self loadPlacesImages:place];
    cell.placeImage.image = place.image;
    //[cell.placeImage sd_setImageWithURL:[NSURL URLWithString:place.imageURL]];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
