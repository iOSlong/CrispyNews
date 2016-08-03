//
//  CNNewsThemeSetViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNewsThemeSetViewController.h"

@interface CNNewsThemeSetViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CNNewsThemeSetViewController

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
    //设置每一个item的大小
    layout.itemSize     = CGSizeMake(150, 180);
    //设置分区的EdgeInset
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    
    //创建一个collectionView，通过布局策略来创建
    self.collectionView    = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    //设置代理
    self.collectionView.dataSource      = self;
    self.collectionView.delegate        = self;
    self.collectionView.allowsSelection = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.allowsMultipleSelection = YES;

    //注册item类型，这里使用系统的cell类型(注意：collectionView在完成代理之前必须要注册一个cell)
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.view addSubview:self.collectionView];
}


#pragma mark CollectionView 的代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //注意，collectionView只有一种实现cell回调的方法，就是只能从复用池中返回cell而不能返回新建的cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
    
    
    //使用下面的方法会导致崩溃
#if 0
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;
#endif
    
}
//返回分区的条数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
//返回每一个分区的item数目
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

//设置每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %2== 0) {
        return CGSizeMake(100, 100);
    }else{
        return CGSizeMake(50, 50);
    }
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    return [collectionView dequeueReusableSupplementaryViewOfKind:@"thiskind" withReuseIdentifier:@"suppementId" forIndexPath:indexPath];
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected indexPath = %@",indexPath);
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
