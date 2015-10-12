//
//  AppDelegate.swift
//  weibo
//
//  Created by 杨晓晨 on 15/10/8.
//  Copyright © 2015年 yangxiaochen. All rights reserved.
//

import UIKit
let YCRootViewControllerSwitchNotification = "YCRootViewControllerSwitchNotification"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupAppearance()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchViewController:", name: YCRootViewControllerSwitchNotification, object: nil)
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }
    /// 程序被销毁才会执行
    deinit {
        // 注销通知 - 只是一个习惯
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /// 切换控制器，记住：一定在 AppDelegate 中统一修改！
    func switchViewController(n: NSNotification) {
        print("切换控制器 \(n)")
        let mainVC = n.object as! Bool
        window?.rootViewController = mainVC ? MainViewController() : WelcomeController()
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
    
    /// 返回启动默认的控制器
    private func defaultViewController() -> UIViewController {
        
        // 1. 判断用户是否登录，如果没有登录返回主控制器
        if !UserAccount.userLogon {
            return MainViewController()
        }
        
        // 2. 判断是否新版本，如果是，返回新特性，否则返回欢迎
        return isNewUpdate() ? NewFeatureController() : WelcomeController()
    }
    
    /// 检查是否有新版本
    private func isNewUpdate() -> Bool {
        // 1. 获取程序当前的版本
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2. 获取程序`之前`的版本，偏好设置
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = NSUserDefaults.standardUserDefaults().stringForKey(sandboxVersionKey)
        
        // 3. 将当前版本保存到偏好设置
        NSUserDefaults.standardUserDefaults().setValue(currentVersion, forKey: sandboxVersionKey)
        // iOS 7.0 之后，就不需要同步了，iOS 6.0 之前，如果不同步不会第一时间写入沙盒
        NSUserDefaults.standardUserDefaults().synchronize()
        if sandboxVersion == nil {
            return true
        }
        // 4. 返回比较结果
        let result = currentVersion.compare(sandboxVersion!)
        return result == NSComparisonResult.OrderedDescending
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

