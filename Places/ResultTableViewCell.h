//
//  ResultTableViewCell.h
//  Places
//
//  Created by Victor on 05.12.15.
//  Copyright © 2015 azat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *placeImage;
@property (nonatomic, weak) IBOutlet UILabel *placeNameLabel;

@end
