//
//  JMColumnMenuController.m
//  JMCollectionView
//
//  Created by JM on 2017/12/11.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "JMColumnMenu.h"
#import "JMColumnMenuCell.h"
#import "JMColumnMenuHeaderView.h"
#import "JMColumnMenuFooterView.h"
#import "JMColumnMenuModel.h"
#import "UIView+JM.h"
#import "JMConfig.h"
#import "interestModel1.h"
#define CELLID   @"CollectionViewCell"
#define HEADERID @"headerId"
#define FOOTERID @"footerId"
#define margin   kSCRATIO(5)
@interface JMColumnMenu ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
}

/** 导航栏的view */
@property (nonatomic, weak) UIView *navView;
/** navTitle */
@property (nonatomic, weak) UILabel *navTitle;
/** navColseBtn */
@property (nonatomic, weak) UIButton *navCloseBtn;
/** tags */
@property (nonatomic, strong) NSMutableArray *tagsArrM;
/** others */
@property (nonatomic, strong) NSMutableArray *otherArrM;
/** CollectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 头部视图 */
@property (nonatomic, weak) JMColumnMenuHeaderView *headerView;
/** 头部视图1 */
@property (nonatomic, weak) JMColumnMenuFooterView *footerView;
/** 长按手势 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
/** 引用headView编辑字符串 */
@property (nonatomic, copy) NSString *editBtnStr;

@property (nonatomic, assign) CGFloat marginTop;

@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *titBtn;
@property (nonatomic,assign)CGFloat lastOffSetY;

@end

@implementation JMColumnMenu

- (NSMutableArray *)tagsArrM
{
    if (!_tagsArrM) {
        _tagsArrM = [NSMutableArray array];
    }
    return _tagsArrM;
}

- (NSMutableArray *)otherArrM
{
    if (!_otherArrM) {
        _otherArrM = [NSMutableArray array];
    }
    return _otherArrM;
}

+ (instancetype)columnMenuWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Type:(JMColumnMenuType)type Delegate:(id<JMColumnMenuDelegate>)delegate
{
    return [[self alloc] initWithTagsArrM:tagsArrM OtherArrM:otherArrM Type:type Delegate:delegate];
}

- (instancetype)initWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Type:(JMColumnMenuType)type Delegate:(id<JMColumnMenuDelegate>)delegate
{
    if (self = [super init]) {
        self.type = type;
        self.delegate = delegate;
        self.editBtnStr = @"编辑";

        for (int i = 0; i < tagsArrM.count; i++) {
            JMColumnMenuModel *model = [[JMColumnMenuModel alloc] init];
            interestModel1 *model1 = tagsArrM[i];
            model.title = [NSString stringWithFormat:@"%@", model1.interestName];
            model.backgroundUrl = model1.backgroundUrl;

            model.interestId1 = model1.interestId;
            model.type = type;
            if (self.type == JMColumnMenuTypeTouTiao) {
                model.showAdd = NO;
                model.selected = NO;
                if (i == 0) {
                    model.resident = YES;
                }
            } else if (type == JMColumnMenuTypeTencent) {
                if (i >= 3) {
                    model.selected = YES;
                } else {
                    model.selected = NO;
                    model.resident = YES;
                }
            }
            [self.tagsArrM addObject:model];
        }
        for (int i = 0; i < otherArrM.count; i++) {
            JMColumnMenuModel *model = [[JMColumnMenuModel alloc] init];
            interestModel1 *model1 = otherArrM[i];
            model.title = [NSString stringWithFormat:@"%@", model1.interestName];
            model.backgroundUrl = model1.backgroundUrl;
            model.interestId1 = [NSString stringWithFormat:@"%@", model1.interestId];

//            if (self.type == JMColumnMenuTypeTouTiao) {
            model.showAdd = YES;
//            }
            model.type = type;
            model.selected = NO;
            [self.otherArrM addObject:model];
        }

        //初始化UI
        [self initColumnMenuUI];
        [self updateBlockArr];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 初始化UI
- (void)initColumnMenuUI
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kNavHeight)];
    navView.backgroundColor = [JMConfig colorWithHexString:@"#171226"];
    self.navView = navView;
//    self.navView.hidden = NO;
//    self.navView.alpha=0;
    [self.view addSubview:navView];

    UILabel *navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight + 11, kSCRATIO(170), 22)];
    navTitle.text = @"全部频道";
    navTitle.font = [UIFont boldSystemFontOfSize:18];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor whiteColor];
//    navTitle.hidden = YES;
    navTitle.alpha=0;
    navTitle.centerX = self.navView.centerX;
    self.navTitle = navTitle;
    [self.navView addSubview:navTitle];

//    self.titBtn=[[UIButton alloc]init];
//    self.titBtn.alpha=0;
//    [self.titBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [self.navView addSubview:self.titBtn];
//    [self.titBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(kStatusBarHeight +8);
//        make.right.mas_offset(kSCRATIO(-20));
//        make.width.mas_offset(kSCRATIO(30));
//        make.height.mas_offset(kSCRATIO(21));
//    }];
//    self.titBtn.font=[UIFont fontWithName:@"PingFangSC-Regular" size: kSCRATIO(15)];
//    [self.titBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
//    self.titBtn.hidden=YES;
    
    UIButton *navCloseBtn = [UIButton new];
    navCloseBtn.frame = CGRectMake(kSCRATIO(10), kStatusBarHeight + 7, 31, 31);

    [navCloseBtn setImage:[UIImage imageNamed:@"navCloseBtn"] forState:UIControlStateNormal];
    self.navCloseBtn = navCloseBtn;
    [navCloseBtn addTarget:self action:@selector(navCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navCloseBtn];

    //视图布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);

    //UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kSCRATIO(14), CGRectGetMaxY(self.navView.frame), self.view.width - kSCRATIO(14) * 2, self.view.height - self.navView.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [JMConfig colorWithHexString:@"#171226"];
    self.collectionView = collectionView;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kSCRATIO(19));
        make.top.mas_offset(kNavHeight);
        make.right.mas_offset(kSCRATIO(-19));
        make.bottom.mas_offset(0);
    }];
    //注册cell
    [self.collectionView registerClass:[JMColumnMenuCell class] forCellWithReuseIdentifier:CELLID];
    [self.collectionView registerClass:[JMColumnMenuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERID];
    [self.collectionView registerClass:[JMColumnMenuFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTERID];

    //添加长按的手势
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
//    if (self.type == JMColumnMenuTypeTencent) {
    [self.collectionView addGestureRecognizer:self.longPress];
//    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.lastOffSetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat i=scrollView.contentOffset.y;
//    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    showViewAnn.fromValue = [NSNumber numberWithFloat:0.0];
//    showViewAnn.toValue = [NSNumber numberWithFloat:1.0];
//    showViewAnn.duration = kAnimationDuration;
//    showViewAnn.fillMode = kCAFillModeForwards;
//    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    showViewAnn.removedOnCompletion = NO;
//    showViewAnn.delegate = self;
//    [contentLayer addAnimation:showViewAnn forKey:@"myShow"];
    if(i<34 && i>0){
        
        //            self.navTitle.hidden=YES;
        //            self.titBtn.hidden=YES;
        //            if (i==34/2) {
        //改变透明度即可实现效果
        self.navView.alpha=i/34;
        self.navTitle.alpha=i/34;
        self.titBtn.alpha=i/34;
        
        //            }
        
    }
    else if (i>=34) {
//        self.navTitle.hidden=NO;
//        self.titBtn.hidden=NO;
        self.navView.alpha=1;
        self.navTitle.alpha=1;
        self.titBtn.alpha=1;
    }else if (i<=0){
        self.navView.alpha=0;
        self.navTitle.alpha=0;
        self.titBtn.alpha=0;
    }
    if (scrollView.contentOffset.y - self.lastOffSetY > 0) {
        NSLog(@"正在向上滑动");
        
       
    }
    else {
        NSLog(@"正在向下滑动");
    }
    
    NSLog(@"%f",i);
}

#pragma mark - 手势识别
- (void)longPress:(UIGestureRecognizer *)longPress
{
    if ([self.editBtnStr containsString:@"编辑"] && self.type == JMColumnMenuTypeTouTiao) {
        self.editBtnStr = @"完成";
        for (int i = 0; i < self.tagsArrM.count; i++) {
            JMColumnMenuModel *model = self.tagsArrM[i];
            if (i != 0) {
                model.selected = YES;
            }
        }
//        NSIndexPath *indexPath = [NSIndexPath]
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
//        [self.collectionView reloadData];
    }
//    NSLog(@"长按手势开始");
    //获取点击在collectionView的坐标
    CGPoint point = [longPress locationInView:self.collectionView];
    //从长按开始
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    //判断是否可以移动
    //    if (indexPath.item == 0) {
    //        return;
    //    }

    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (indexPath.section == 0 && indexPath.item < 3) {
            return;
        }
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        //长按手势状态改变
//        NSLog(@"开始");
    } else if (longPress.state == UIGestureRecognizerStateChanged) {
        if (indexPath.section == 0 && indexPath.item < 3) {
            return;
        }
//        NSLog(@"改变");
        [self.collectionView updateInteractiveMovementTargetPosition:point];
        //长按手势结束
    } else if (longPress.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"结束");
        [self.collectionView endInteractiveMovement];
        //其他情况
    } else {
        [self.collectionView cancelInteractiveMovement];
    }
}

#pragma mark - UICollectionViewDataSource
//一共有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.otherArrM) {
        return 2;
    } else {
        return 1;
    }
}

//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.tagsArrM.count;
    } else {
        return self.otherArrM.count;
    }
}

//每一个cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMColumnMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];

    if (indexPath.section == 0) {
        JMColumnMenuModel *model = self.tagsArrM[indexPath.item];
        cell.model = model;
//        if (indexPath.item == 0) { //第一个按钮样式区别
//            cell.title.textColor = [UIColor redColor];
//        }
    } else {
        JMColumnMenuModel *model = self.otherArrM[indexPath.item];
        cell.model = model;
    }
    //关闭按钮点击事件
    cell.closeBtn.tag = indexPath.item;
    [cell.closeBtn addTarget:self action:@selector(colseBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

//和tableView差不多, 可设置头部和尾部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JMColumnMenuHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADERID forIndexPath:indexPath];
//        headerView.backgroundColor=[UIColor redColor];
        if (indexPath.section == 0) {
            self.allLabel = [UILabel new];
            [headerView addSubview:self.allLabel];
            self.allLabel.textColor = [UIColor whiteColor];
            self.allLabel.text = @"全部频道";
            self.allLabel.font = [UIFont boldSystemFontOfSize:kSCRATIO(30)];
            [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(kSCRATIO(4));
                make.top.mas_offset(kSCRATIO(74) - kNavHeight);
                make.width.mas_offset(kSCRATIO(130));
                make.height.mas_offset(kSCRATIO(42));
            }];
//            self.allBtn = [[UIButton alloc]init];
//            [headerView addSubview:self.allBtn];
//            [self.allBtn setTitle:@"保存" forState:UIControlStateNormal];
//            [self.allBtn setTitleColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
//            self.allBtn.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kSCRATIO(18)];
//            self.allBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//            [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_offset(kSCRATIO(78 - kNavHeight + 12));
////                make.centerX.mas_equalTo(self.allBtn);
//                make.right.mas_offset(kSCRATIO(-2));
//                make.height.mas_offset(kSCRATIO(25));
//                make.width.mas_offset(kSCRATIO(40));
//            }];
            [headerView.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.allLabel.mas_bottom).offset(kSCRATIO(25));
                make.left.mas_offset(kSCRATIO(4));
                make.width.mas_offset(kSCRATIO(70));
                make.height.mas_offset(kSCRATIO(22));
            }];
            headerView.title.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:kSCRATIO(16)];
            [headerView.detail mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.allLabel.mas_bottom).offset(kSCRATIO(28));
                make.left.mas_equalTo(headerView.title.mas_right).offset(kSCRATIO(kSCRATIO(10)));
                make.width.mas_offset(kSCRATIO(100));
                make.height.mas_offset(kSCRATIO(18));
            }];
            headerView.titleStr = @"我的频道";

            headerView.detailStr = @"长按拖动可排序";
            if (self.type == JMColumnMenuTypeTouTiao) {
                [headerView.editBtn setTitle:self.editBtnStr forState:UIControlStateNormal];
                headerView.editBtn.hidden = NO;
                [headerView.editBtn addTarget:self action:@selector(headViewEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        self.headerView = headerView;
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        JMColumnMenuFooterView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FOOTERID forIndexPath:indexPath];
//        footerView.backgroundColor=[UIColor greenColor];

        if (indexPath.section == 0) {
            footerView.titleStr = @"推荐频道";
            
            footerView.detailStr = @"点击频道添加";
        }
        self.footerView = footerView;
        [self updateBlockArr];

        return footerView;
    }
    return nil;
}

#pragma mark - 头部编辑按钮点击事件
- (void)headViewEditBtnClick
{
    if ([self.editBtnStr containsString:@"编辑"]) {
        self.editBtnStr = @"完成";
        [self.headerView.editBtn setTitle:@"完成" forState:UIControlStateNormal];

//        [self.collectionView addGestureRecognizer:self.longPress];

        for (int i = 0; i < self.tagsArrM.count; i++) {
            JMColumnMenuModel *model = self.tagsArrM[i];
            if (i == 0) {
                model.selected = NO;
            } else {
                model.selected = YES;
            }
        }
    } else {
        self.editBtnStr = @"编辑";
        [self.headerView.editBtn setTitle:@"编辑" forState:UIControlStateNormal];

//        [self.collectionView removeGestureRecognizer:self.longPress];

        for (int i = 0; i < self.tagsArrM.count; i++) {
            JMColumnMenuModel *model = self.tagsArrM[i];
            if (i == 0) {
                model.selected = NO;
            } else {
                model.selected = NO;
            }
        }
    }
    [self.collectionView reloadData];
}

//每一个分组的上左下右间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

//头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(self.view.width, kSCRATIO(175 - kNavHeight+kSCRATIO(2) ));
    } else {
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(self.view.width, kSCRATIO(72)-kSCRATIO(14));
    } else {
        return CGSizeMake(0, 0);
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSCRATIO(158), kSCRATIO(66));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return margin * 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return margin;
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMColumnMenuModel *model;
    if (indexPath.section == 0) {
        model = self.tagsArrM[indexPath.item];
        //判断是否是编辑状态
        if ([self.editBtnStr containsString:@"编辑"]) {
            //判断是否是头条,是就直接回调出去
            if (model.type == JMColumnMenuTypeTouTiao) { //头条
                if ([self.delegate respondsToSelector:@selector(columnMenuDidSelectTitle:Index:)]) {
                    [self.delegate columnMenuDidSelectTitle:model.title Index:indexPath.item];
                }
                [self navCloseBtnClick];
                return;
            }
        }

        //判断是否可以删除
        if (model.resident) {
            return;
        }

        model.selected = NO;
        if (model.type == JMColumnMenuTypeTencent) {
            model.showAdd = YES;
        } else if (model.type == JMColumnMenuTypeTouTiao) {
            model.showAdd = YES;
        }
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];

        [self.tagsArrM removeObjectAtIndex:indexPath.item];
        [self.otherArrM insertObject:model atIndex:0];

        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    } else if (indexPath.section == 1) {
        JMColumnMenuCell *cell = (JMColumnMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.closeBtn.hidden = YES;
        model = self.otherArrM[indexPath.item];
        if (model.type == JMColumnMenuTypeTencent) {
            model.selected = YES;
        } else if (model.type == JMColumnMenuTypeTouTiao) {
            if ([self.editBtnStr containsString:@"编辑"]) {
                model.selected = NO;
            } else {
                model.selected = YES;
            }
        }
        model.showAdd = NO;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];

        [self.otherArrM removeObjectAtIndex:indexPath.item];
        [self.tagsArrM addObject:model];

        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:self.tagsArrM.count - 1 inSection:0];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }

    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

#pragma mark - item关闭按钮点击事件
- (void)colseBtnClick:(UIButton *)sender
{
    JMColumnMenuModel *model = self.tagsArrM[sender.tag];
    model.selected = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];

    [self.tagsArrM removeObjectAtIndex:sender.tag];
    [self.otherArrM insertObject:model atIndex:0];

    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];

    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

//在开始移动是调动此代理方法
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row < 3) {
            return NO;
        }
    }
//    NSLog(@"开始移动");
    return YES;
}

//在移动结束的时候调用此代理方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    NSLog(@"结束移动");
    JMColumnMenuModel *model;
    if (sourceIndexPath.section == 0) {
        model = self.tagsArrM[sourceIndexPath.item];
        [self.tagsArrM removeObjectAtIndex:sourceIndexPath.item];
    } else {
        model = self.otherArrM[sourceIndexPath.item];
        [self.otherArrM removeObjectAtIndex:sourceIndexPath.item];
    }

    if (destinationIndexPath.section == 0) {
        model.selected = YES;
        [self.tagsArrM insertObject:model atIndex:destinationIndexPath.item];
    } else if (destinationIndexPath.section == 1) {
        model.selected = NO;
        [self.otherArrM insertObject:model atIndex:destinationIndexPath.item];
    }

    [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];

    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

#pragma mark - 刷新tag
- (void)refreshDelBtnsTag
{
    for (JMColumnMenuCell *cell in self.collectionView.visibleCells) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        cell.closeBtn.tag = indexPath.item;
    }
}

#pragma mark - 更新block数组
- (void)updateBlockArr
{
    NSMutableArray *tempTagsArrM = [NSMutableArray array];
    NSMutableArray *tempOtherArrM = [NSMutableArray array];
    for (JMColumnMenuModel *model in self.tagsArrM) {
        [tempTagsArrM addObject:model.interestId1];
    }
    for (JMColumnMenuModel *model in self.otherArrM) {
        [tempOtherArrM addObject:model.interestId1];
    }

    if ([self.delegate respondsToSelector:@selector(columnMenuTagsArr:OtherArr:)]) {
        [self.delegate columnMenuTagsArr:tempTagsArrM OtherArr:tempOtherArrM];
    }
    if (self.otherArrM.count <= 0) {
        self.footerView.hidden = YES;
    } else {
        self.footerView.hidden = NO;
    }
}

#pragma mark - 导航栏右侧关闭按钮点击事件
- (void)navCloseBtnClick
{
    if (self.menubackblock) {
        self.menubackblock();
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavTitleStr:(NSString *)navTitleStr
{
    _navTitleStr = navTitleStr;
    self.navTitle.text = navTitleStr;
}

- (void)setNavBackgroundColor:(UIColor *)navBackgroundColor
{
    _navBackgroundColor = navBackgroundColor;
    self.navView.backgroundColor = navBackgroundColor;
}

- (void)setNavTitleColor:(UIColor *)navTitleColor
{
    _navTitleColor = navTitleColor;
    self.navTitle.textColor = navTitleColor;
}

- (void)setNavRightIV:(UIImage *)navRightIV
{
    _navRightIV = navRightIV;
    [self.navCloseBtn setImage:navRightIV forState:UIControlStateNormal];
}

@end
