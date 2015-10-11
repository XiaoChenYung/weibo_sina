//
//  WelcomeController.swift
//  weibo
//
//  Created by 杨晓晨 on 15/10/11.
//  Copyright © 2015年 yangxiaochen. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeController: UIViewController {
    /// 图像底部约束
    private var iconBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        let uinfo: UserAccount? = UserAccount.loadAccount()
        labelname.text = uinfo?.name
        
        iconView.sd_setImageWithURL(NSURL(string: (uinfo?.avatar_large!)!))


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 提示：修改约束不会立即生效，添加了一个标记，统一由自动布局系统更新约束
        iconBottomCons?.constant = UIScreen.mainScreen().bounds.height - iconBottomCons!.constant
        
        // 动画
        UIView.animateWithDuration(3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 强制更新约束
            self.view.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                // 发送通知，切换控制器
                NSNotificationCenter.defaultCenter().postNotificationName(YCRootViewControllerSwitchNotification, object: true)
        }
    }
    
    /// 准备界面
    private func prepareUI() {
        view.addSubview(backImageView)
        view.addSubview(iconView)
        view.addSubview(labelname)
        view.addSubview(label)
        
        // 自动布局
        // 1> 背景图片
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview": backImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview": backImageView]))
        
        // 2> 头像
        iconView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 90))
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 90))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 200))
        // 记录底边约束
        iconBottomCons = view.constraints.last

        // 3> 昵称
        labelname.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: labelname, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: labelname, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 36))
        
        // 4> 标签
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
    }
    
    // MARK: - 懒加载控件
    // 背景图片
    private lazy var backImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    /// 用户头像
    private lazy var iconView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 45
        
        return iv
        }()
    /// 消息文字
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.text = "欢迎归来"
        label.sizeToFit()
        
        return label
        }()
    
    /// 昵称
    private lazy var labelname: UILabel = {
        let label = UILabel()
        
         label.text = "新浪微博"
         label.sizeToFit()
        
        return label
        }()

}
