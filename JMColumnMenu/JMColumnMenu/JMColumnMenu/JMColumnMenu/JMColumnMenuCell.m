//
//  JMColumnMenuCell.m
//  JMCollectionView
//
//  Created by 刘俊敏 on 2017/12/7.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "JMColumnMenuCell.h"
#import "UIView+JM.h"
#import "JMConfig.h"
#import "UIImageView+AFNetworking.h"

@interface JMColumnMenuCell()

/** 空View */
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation JMColumnMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //空View
        
        self.emptyView = [[UIView alloc] initWithFrame:CGRectZero];
        self.emptyView.backgroundColor = [JMConfig colorWithHexString:@"#251E38"];
        self.emptyView.layer.cornerRadius=kSCRATIO(12);
        self.emptyView.layer.masksToBounds=YES;
        [self.contentView addSubview:self.emptyView];
        
        self.imageView=[UIImageView new];
        self.imageView.layer.cornerRadius=kSCRATIO(19);
        self.imageView.layer.masksToBounds=YES;
        [self.contentView addSubview:self.imageView];

        //标题
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.font = [UIFont systemFontOfSize:kSCRATIO(15)];
        self.title.textColor=[UIColor whiteColor];
        self.title.textAlignment = NSTextAlignmentCenter;
//        self.title.layer.masksToBounds = YES;
//        self.title.layer.cornerRadius = 5.f;
//        self.title.backgroundColor = [JMConfig colorWithHexString:@"#f4f4f4"];
        [self.emptyView addSubview:self.title];
        
        //关闭按钮
       
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setImage:[UIImage imageNamed:@"closeBtn"] forState:UIControlStateNormal];

        self.closeBtn.hidden = YES;
        [self.emptyView addSubview:self.closeBtn];
        
        //添加按钮
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [self.addBtn setImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
        self.addBtn.hidden = YES;
        [self.emptyView addSubview:self.addBtn];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(kSCRATIO(38));
            make.centerY.equalTo(self.emptyView);
            make.left.mas_offset(kSCRATIO(14));
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(kSCRATIO(21));
            make.height.mas_lessThanOrEqualTo(kSCRATIO(45));
            make.centerY.equalTo(self.emptyView);
            make.left.equalTo(self.imageView.mas_right).mas_offset(kSCRATIO(14));
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(kSCRATIO(20));
            make.centerY.equalTo(self.emptyView);
            make.right.mas_offset(-kSCRATIO(10));
        }];
        //    self.addBtn.size = CGSizeMake(10, 10);
        //    self.addBtn.centerY = self.title.centerY;
        //    self.addBtn.x = CGRectGetMinX(self.title.frame) - 12;
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(kSCRATIO(20));
            make.centerY.equalTo(self.contentView);
            make.right.mas_offset(-kSCRATIO(10));
        }];
    }
    return self;
}

- (void)updateAllFrame:(JMColumnMenuModel *)model {
//    self.emptyView.frame = CGRectMake(5, 6.5, self.contentView.width - 10, self.contentView.height - 13);
//    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
//    self.title.size = [self returnTitleSize];

//    if (model.showAdd) {
//        self.title.center = CGPointMake(self.contentView.width / 2 + 6, self.contentView.height / 2);
//    } else {
//        self.title.center = CGPointMake(self.contentView.width / 2, self.contentView.height / 2);
//    }

//    self.closeBtn.frame = CGRectMake(self.contentView.width - 16, 0, 18, 18);
//    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_offset(17);
//        make.centerY.equalTo(self.emptyView);
//        make.right.mas_offset(-12);
//    }];
////    self.addBtn.size = CGSizeMake(10, 10);
////    self.addBtn.centerY = self.title.centerY;
////    self.addBtn.x = CGRectGetMinX(self.title.frame) - 12;
//    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_offset(17);
//        make.centerY.equalTo(self.contentView);
//        make.right.mas_offset(-12);
//    }];
}

- (void)setModel:(JMColumnMenuModel *)model {
    _model = model;
    
    //标题文字处理
    if (model.title.length == 2) {
        self.title.font = [UIFont systemFontOfSize:kSCRATIO(15)];
    } else if (model.title.length == 3) {
        self.title.font = [UIFont systemFontOfSize:kSCRATIO(14)];
    } else if (model.title.length == 4) {
        self.title.font = [UIFont systemFontOfSize:kSCRATIO(13)];
    } else if (model.title.length > 4) {
        self.title.font = [UIFont systemFontOfSize:kSCRATIO(12)];
    }
    
    if (model.type == JMColumnMenuTypeTencent) {
        self.title.text = model.title;
        self.closeBtn.hidden = !model.selected;
    } else if (model.type == JMColumnMenuTypeTouTiao) {
        self.closeBtn.hidden = !model.selected;
        self.title.text = [NSString stringWithFormat:@"%@",model.title];
       
    }
    [self.imageView setImageWithURL:[NSURL URLWithString:model.backgroundUrl] placeholderImage:[UIImage imageNamed:@"headImage1"]];
    if (model.showAdd) {
        self.addBtn.hidden = NO;
    } else {
        self.addBtn.hidden = YES;
    }
    [self updateAllFrame:model];
}

//- (CGSize)returnTitleSize {
//    CGFloat maxHeight = self.emptyView.width - 12;
//    CGSize size = [self.title.text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
//                                                options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
//                                             attributes:@{NSFontAttributeName:self.title.font}
//                                                context:nil].size;
//    return size;
//}


@end
