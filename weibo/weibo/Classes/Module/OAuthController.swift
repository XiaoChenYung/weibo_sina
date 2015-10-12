//
//  OAuthController.swift
//  weibo
//
//  Created by 杨晓晨 on 15/10/9.
//  Copyright © 2015年 yangxiaochen. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthController: UIViewController, UIWebViewDelegate {

    lazy var web: UIWebView = UIWebView()
    override func viewDidLoad() {
     //   view.backgroundColor
        super.viewDidLoad()
        view = web
        web.delegate = self
        title = "新浪微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        web.loadRequest(NSURLRequest(URL: NetTools.shareTools.oauthUrl()))
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString = request.URL!.absoluteString
        // 判断是否包含回调地址
        if !urlString.hasPrefix(NetTools.shareTools.redirectUri) {
            return true
        }
        
        print("判断参数")
        print(request.URL?.query)
        if let query = request.URL?.query where query.hasPrefix("code=") {
            print("获取授权码")
            // 从 query 中截取授权码
            let code = query.substringFromIndex("code=".endIndex)
            print(code)
            loadAccessToken(code)
        } else {
            close()
        }
        
        return false
    }
    
    private func loadAccessToken(code: String) {
        NetTools.shareTools.loadAccessToken(code) { (result, error) -> () in
            if error != nil || result == nil {
                SVProgressHUD.showInfoWithStatus("您的网络不给力")
                
                // 延时一段时间再关闭
                let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
                dispatch_after(when, dispatch_get_main_queue()) {
                    self.close()
                }
                
                return
            }
            
            // 字典转模型
           UserAccount(dict: result!).loadUserInfo({ (error) -> () in
            print(result!)
            if error != nil {
                print("网络错误")
                return
            }
            // 发送通知切换视图控制器
            NSNotificationCenter.defaultCenter().postNotificationName(YCRootViewControllerSwitchNotification, object: false)
            self.close()
           })
        }
    }
    
    /// 关闭界面
    func close() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
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
