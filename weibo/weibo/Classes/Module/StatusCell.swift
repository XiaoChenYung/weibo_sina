//
//  StatusCell.swift
//  weibo
//
//  Created by 杨晓晨 on 15/10/13.
//  Copyright © 2015年 yangxiaochen. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {

    var status: Status? {
        didSet {
            topView.status = status
            contentLabel.text = status?.text ?? ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置界面
    private func setupUI() {
        // 1. 添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        
        // 2. 设置布局
        // 1> 顶部视图
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
        
        // 2> 内容标签
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 8, y: 8))
        // 宽度
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -16))
        
        // 3> 底部视图
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -8, y: 8))
        // 底部约束
        contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
    }
    
    // MARK: - 懒加载控件
    /// 顶部视图
    private lazy var topView: StatusTopView = StatusTopView()
    /// 内容标签
    private lazy var contentLabel: UILabel = {
        let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        
        return label
        }()
    /// 底部视图
    private lazy var bottomView: StatusBottumView = StatusBottumView()

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
