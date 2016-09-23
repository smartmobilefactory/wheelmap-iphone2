//
//  WMCateogryFilterPopoverView.h
//  Wheelmap
//
//  Created by npng on 11/27/12.
//  Copyright (c) 2012 Sozialhelden e.V. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMNavigationControllerBase;

@protocol WMCategoryFilterPopoverViewDelegate <NSObject>
-(void)categoryFilterStatusDidChangeForCategoryID:(NSNumber*)categoryID selected:(BOOL)selected;
@end

@interface WMCategoryFilterPopoverView : UIView <UITableViewDelegate, UITableViewDataSource> {
    CGPoint refOrigin;
}

@property (nonatomic, strong) id<WMCategoryFilterPopoverViewDelegate>	delegate;

@property (strong, nonatomic) IBOutlet UIImageView *					backgroundImageView;
@property (strong, nonatomic) IBOutlet UITableView *					tableView;

@property (nonatomic, strong) NSArray*									categoryList;

- (id)initWithRefPoint:(CGPoint)refPoint andCategories:(NSArray*)categories;

- (void)refreshViewWithCategories:(NSArray*)categories;
- (void)refreshViewWithRefPoint:(CGPoint)refPoint andCategories:(NSArray *)categories;
@end
