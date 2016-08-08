//
//  CNNewsThemeSetViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNewsThemeSetViewController.h"
#import "CNThemeCollectionViewCell.h"
#import "CNThemeCollectionReusableView.h"

@interface CNNewsThemeSetViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isCellShouldShake;
//@property (nonatomic, strong) NSMutableArray *muArrRecommended;

@end

@implementation CNNewsThemeSetViewController

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

//- (NSMutableArray *)muArrRecommended {
//    if (!_muArrRecommended) {
//        NSArray *muArr = @[@"banana",@"apple",@"pease",@"unbremna",@"peak",@"tortate",@"new money",@"helloMan",@"spider",@"pig",@"dog",@"elephant",@"lion",@"big cat",@"showman",@"superPob",@"healer"];
//        _muArrRecommended = [NSMutableArray arrayWithArray:muArr];
//    }
//    return _muArrRecommended;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR_HEX(0xfefefe);
    
    
    /// 2. 设置导航条上的字体颜色
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    
    [self setNavigationBarItem];
    
    [self configureCollectionView];
}

- (void)setNavigationBarItem {
    
    self.title = @"CrispyNews";
    
    
    CNBarButtonItem *editItem = [[CNBarButtonItem alloc] barButtomItem:@"<<"];
    [editItem barBlock:^(CNBarButtonItem *barBItem) {
        NSLog(@"Edit Click");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpaceItem.width =  iPhone6Plus? -15:-8;
    self.navigationItem.leftBarButtonItems = @[rightSpaceItem,editItem];
    
}

- (void)configureCollectionView {
    
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局滚动方向为 Horizontal-水平滚动   Vertical-垂直滚动
    //注意：如果是Vertical的则cell是水平布局排列，如果是Horizontal则cell是垂直布局排列 （这个就叫做流式布局）
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 35);//头部
    //设置每一个item的大小
    layout.itemSize     = CGSizeMake(85, 38);
    //设置分区的EdgeInset
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    
    
    //创建一个collectionView，通过布局策略来创建
    self.collectionView    = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    //设置代理
    self.collectionView.dataSource      = self;
    self.collectionView.delegate        = self;
    self.collectionView.allowsSelection = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.allowsMultipleSelection = YES;
    
    //注册item类型，这里使用系统的cell类型(注意：collectionView在完成代理之前必须要注册一个cell)
    [self.collectionView registerClass:[CNThemeCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerClass:[CNThemeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [self.collectionView registerClass:[CNThemeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    
    [self.view addSubview:self.collectionView];
    
    
    
    
    //    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_collectionView addGestureRecognizer:longGesture];
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            BOOL canMove = [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            NSLog(@"canMove = %d",canMove);
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //    id objc = [self.muArrRecommend objectAtIndex:sourceIndexPath.item];
    //    //从资源数组中移除该数据
    //    [self.muArrRecommend removeObject:objc];
    //    //将数据插入到资源数组中的目标位置上
    //    [self.muArrRecommend insertObject:objc atIndex:destinationIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark CollectionView 的代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //注意，collectionView只有一种实现cell回调的方法，就是只能从复用池中返回cell而不能返回新建的cell
    CNThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    [cell stopShake];
    if (indexPath.section == 0 && self.isCellShouldShake) {
        [cell startShake];
    }
    
    if (indexPath.section == 1){
        cell.themeBtn.themeTitle = self.muArrRecommend[indexPath.row].themeName;
    }else if (indexPath.section == 0){
        cell.themeBtn.themeTitle = self.muArrChannelTheme[indexPath.row].themeName;
    }
    
    [cell themeCellBlock:^(CNThemeEvent themeEvent) {
        if (indexPath.section == 1 && themeEvent == CNThemeEventItemClick)
        {
            [self.muArrChannelTheme addObject:self.muArrRecommend[indexPath.row]];
            [self.muArrRecommend removeObjectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 0 && themeEvent == CNThemeEventDelete)
        {
            [self.muArrRecommend addObject:self.muArrChannelTheme[indexPath.row]];
            [self.muArrChannelTheme removeObjectAtIndex:indexPath.row];
        }
        [collectionView reloadData];
    }];
    
    return cell;
    
    //使用下面的方法会导致崩溃
#if 0
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;
#endif
    
}
//返回分区的条数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
//返回每一个分区的item数目
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.muArrChannelTheme.count;
    }else if (section == 1){
        return self.muArrRecommend.count;
    }
    return 0;
}

//设置每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(85, 38);
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CNThemeCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if (headerView == nil){
            headerView = [CNThemeCollectionReusableView new];
        }
        
        if (indexPath.section == 0) {
            headerView.barType = CNThemeBarTypeHeaderMyChannels;
        }else if (indexPath.section == 1){
            headerView.barType = CNThemeBarTypeHeaderRecommended;
        }
        
        [headerView themeBar:^(CNThemeBarState themeState) {
            NSLog(@"click - >");
            if (themeState == CNThemeBarStateEditing) {
                self.isCellShouldShake = YES;
            }else{
                self.isCellShouldShake = NO;
            }
            [collectionView reloadData];
            [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (tapCollectionView)]];
        }];
        if (self.isCellShouldShake == NO) {
            headerView.themeState = CNThemeBarStateNormal;
        }else{
            headerView.themeState = CNThemeBarStateEditing;
        }
        
        
        return headerView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        CNThemeCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        if (footerView == nil)
        {
            footerView = [CNThemeCollectionReusableView new];
        }
        footerView.barType = CNThemeBarTypeFooter;
        return footerView;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected indexPath = %@",indexPath);
    self.isCellShouldShake = NO;
    [self.collectionView reloadData];
}
- (void)tapCollectionView{
    self.isCellShouldShake = NO;
    [self.collectionView reloadData];
    [self.collectionView removeGestureRecognizer:self.collectionView.gestureRecognizers.lastObject];
}



#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){SCREENW,44};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){SCREENW,2};
}












@end
