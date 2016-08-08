//
//  CNContentTableView.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/4.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNContentTableView.h"
#import "CNNoIconCell.h"
#import "CNBigIconCell.h"
#import "CNIconsCell.h"
#import "CNSingleIconCell.h"
#import "CNNewsType.h"


static NSString * const noIconCell = @"CNNoIconCell";
static NSString * const bigIconCell = @"CNBigIconCell";
static NSString * const iconsCell = @"CNIconsCell";
static NSString * const singleIconCell = @"CNSingleIconCell";

@interface CNContentTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *newsArray;

@end


@implementation CNContentTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    [self setupBasic];
        
        
    }
    return self;
}

- (void)setupBasic
{
    self.dataSource = self;
    
    self.delegate = self;
    
//    self.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.showsVerticalScrollIndicator = NO;
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([CNNoIconCell class]) bundle:nil] forCellReuseIdentifier:noIconCell];
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([CNBigIconCell class]) bundle:nil] forCellReuseIdentifier:bigIconCell];
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([CNIconsCell class]) bundle:nil] forCellReuseIdentifier:iconsCell];
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([CNSingleIconCell class]) bundle:nil] forCellReuseIdentifier:singleIconCell];
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 238;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CNNewsType *news = self.newsArray[indexPath.row];
//    
//    if (news.newsType == NewsTypeNoIconCell) {
//        
//        CNNoIconCell *cell = [tableView dequeueReusableCellWithIdentifier:noIconCell];
//        
//        return cell;
//        
//    }else if (news.newsType == NewsTypeBigIconCell) {
//        
        CNBigIconCell *cell = [tableView dequeueReusableCellWithIdentifier:bigIconCell];
    
        return cell;
//
//    }else if (news.newsType == NewsTypeIconsCell) {
//    
//        CNIconsCell *cell = [tableView dequeueReusableCellWithIdentifier:iconsCell];
//        
//        return cell;
//        
//    }else {
//    
//        CNSingleIconCell *cell = [tableView dequeueReusableCellWithIdentifier:singleIconCell];
////        cell.backgroundColor = RandomColor;
//        return cell;
//    }
}




@end
