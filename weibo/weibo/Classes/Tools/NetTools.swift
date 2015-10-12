//
//  NetTools.swift
//  weibo
//
//  Created by 杨晓晨 on 15/10/9.
//  Copyright © 2015年 yangxiaochen. All rights reserved.
//

import UIKit
import AFNetworking
private let YCErrorDomainName = "YCErrorDomainName"
class NetTools:  AFHTTPSessionManager {
    static let shareTools:  NetTools = {
        let baseURL = NSURL(string: "https://api.weibo.com/")
        let tools = NetTools(baseURL: baseURL)
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        return tools
    }()
    
    // MARK: - OAuth授权https://api.weibo.com/oauth2/authorize?client_id=3696368993&redirect_uri=https://www.baidu.com
    private let clientId = "3696368993"
    private let appSecret = "86d4e36ca93bb288966df28373e2f812"
    /// 回调地址
    let redirectUri = "https://www.baidu.com"
    
    /// 返回 OAuth 授权地址
    func oauthUrl() -> NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)"
        
        return NSURL(string: urlString)!
    }
    
    //MARK: 加载用户信息
    func loadUserInfo(uid: String, finished: YCNetFinishedCallBack) {
        
        if UserAccount.loadAccount()?.access_token == nil {
            print("token 为空,请检查代码")
            return
        }
        let urlString = "2/users/show.json"
        let params: [String: AnyObject] = ["access_token": UserAccount.loadAccount()!.access_token!, "uid": uid]
        requestGET(urlString, params: params, finished: finished)
    }
    
    /// 加载 Token
    func loadAccessToken(code: String, finished: (result: [String: AnyObject]?, error: NSError?)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": clientId,
            "client_secret": appSecret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectUri]
        
        // 测试代码-设置返回的数据格式
        // responseSerializer = AFHTTPResponseSerializer()
        
        POST(urlString, parameters: params, success: { (_, JSON) -> Void in
            // {"access_token":"2.00ml8IrFX6ZhGE09ce0ebf870fPkb1","remind_in":"157679999","expires_in":157679999,"uid":"5365823342"}
            // 没有引号的值在反序列化的时候，会变成 NSNumber
            // print(NSString(data: JSON as! NSData, encoding: NSUTF8StringEncoding))
            
            finished(result: JSON as? [String: AnyObject], error: nil)
            }) { (_, error) -> Void in
                print(error)
                finished(result: nil, error: error)
        }
    }
    
    // MARK: - 封装 AFN 网络方法，便于替换网络访问方法，第三方框架的网络代码全部集中在此
    /// 网络回调类型别名
    typealias YCNetFinishedCallBack = (result: [String: AnyObject]?, error: NSError?)->()
    
    /// GET 请求
    ///
    /// :param: urlString URL 地址
    /// :param: params    参数字典
    /// :param: finished  完成回调
    func requestGET(urlString: String, params: [String: AnyObject], finished: YCNetFinishedCallBack) {
        
        GET(urlString, parameters: params, success: { (_, JSON) -> Void in
            
            if let result = JSON as? [String: AnyObject] {
                // 有结果的回调
                finished(result: result, error: nil)
            } else {
                // 没有错误，同时没有结果
                print("没有数据 GET Request \(urlString)")
                
                /**
                domain: 错误的范围/大类别，定义一个常量字符串
                code: 错误代号，有些公司会专门定义一个特别大的.h，定义所有的错误编码，通常是负数
                userInfo: 可以传递一些附加的错误信息
                */
                let error = NSError(domain: YCErrorDomainName, code: -1, userInfo: ["errorMessage": "空数据"])
                
                finished(result: nil, error: error)
            }
            
            }) { (_, error) -> Void in
                print(error)
                
                finished(result: nil, error: error)
        }
    }
}
