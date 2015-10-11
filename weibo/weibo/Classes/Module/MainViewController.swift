//
//  MainViewController.swift
//  weibo1
//
//  Created by 杨晓晨 on 15/10/7.
//  Copyright © 2015年 yangxiaochen. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addChildViewController(HomeTableViewController(), title: "首页", imageString: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imageString: "tabbar_message_center")
        addChildViewController(UIViewController())
        addChildViewController(DiscoverTableViewController(), title: "发现", imageString: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我的", imageString: "tabbar_profile")
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        tabBar.addSubview(composeBtn)
        let w = tabBar.bounds.width/5.0
        let rect = CGRect(x: w*2, y: 0, width: w, height: tabBar.bounds.height)
        composeBtn.frame = rect
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(event)
    }
    
    private func addChildViewController(childController: UIViewController, title: String, imageString: String ) {
        tabBar.tintColor = UIColor.orangeColor()
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageString)
        let nav = UINavigationController(rootViewController: childController)
        addChildViewController(nav)
        
    }
    
    lazy var composeBtn: UIButton = {
        let btn = UIButton()
        btn.userInteractionEnabled = true
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        btn.addTarget(self, action: "clickBtn", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    func clickBtn() {
        print("beidianla")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
