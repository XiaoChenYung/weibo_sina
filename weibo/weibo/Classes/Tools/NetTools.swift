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
private let clientId = "3696368993"
private let appSecret = "86d4e36ca93bb288966df28373e2f812"
/// 回调地址
let redirectUri = "https://www.baidu.com"
/// 网络访问错误信息 - 枚举，是定义一组类似的值
/// Swift 中枚举可以定义函数和属性，跟`类`有点像
enum YCNetworkError: Int {
    case emptyDataError = -1
    case emptyTokenError = -2
    
    /// 错误描述
    private var errorDescrption: String {
        switch self {
        case .emptyDataError: return "空数据"
        case .emptyTokenError: return "Token 为空"
        }
    }
    /// 根据枚举类型，返回对应的错误
    private func error() -> NSError {
        return NSError(domain: YCErrorDomainName, code: rawValue, userInfo: [YCErrorDomainName: errorDescrption])
    }
}

/// 网络访问方法
enum YCNetworkMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class NetTools:  AFHTTPSessionManager {
    static let shareTools:  NetTools = {
        let baseURL = NSURL(string: "https://api.weibo.com/")
        let tools = NetTools(baseURL: baseURL)
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        return tools
    }()
    
    func loadStatus(finished: YCNetFinishedCallBack) {
        let urlStr = "2/statuses/home_timeline.json"
        let params = ["access_token": loadToken() as! AnyObject]
        request(YCNetworkMethod.GET, urlString: urlStr, params: params, finished: finished)
    }
    
    /// 返回 OAuth 授权地址
    func oauthUrl() -> NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)"
        
        return NSURL(string: urlString)!
    }
    /// 加载touken
    func loadToken() -> String? {
        if UserAccount.loadAccount()?.access_token == nil {
            print("token 为空,请检查代码")
            return nil
        }else {
            print(UserAccount.loadAccount()?.access_token)
            return UserAccount.loadAccount()?.access_token
        }
        
    }
    
    //MARK: 加载用户信息
    func loadUserInfo(uid: String, finished: YCNetFinishedCallBack) {
        let urlString = "2/users/show.json"
        let params: [String: AnyObject] = ["access_token": UserAccount.loadAccount()!.access_token!, "uid": uid]
        request(YCNetworkMethod.GET, urlString: urlString, params: params, finished: finished)
    }
    
    /// 加载 Token
    func loadAccessToken(code: String, finished: YCNetFinishedCallBack) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": clientId,
            "client_secret": appSecret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectUri]
        
        // 测试代码-设置返回的数据格式
        // responseSerializer = AFHTTPResponseSerializer()
       request(YCNetworkMethod.POST, urlString: urlString, params: params, finished: finished)
    }
    
    // MARK: - 封装 AFN 网络方法，便于替换网络访问方法，第三方框架的网络代码全部集中在此
    /// 网络回调类型别名
    typealias YCNetFinishedCallBack = (result: [String: AnyObject]?, error: NSError?)->()
    
    /// GET 请求
    ///
    /// :param: urlString URL 地址
    /// :param: params    参数字典
    /// :param: finished  完成回调
    func request(methord: YCNetworkMethod, urlString: String, params: [String: AnyObject], finished: YCNetFinishedCallBack) {
        
        let successCallBack: (NSURLSessionDataTask!,  AnyObject!) -> Void = { (_, JSON) -> Void in
            
            if let result = JSON as? [String: AnyObject] {
                // 有结果的回调
                finished(result: result, error: nil)
            }else {
                finished(result: nil, error: YCNetworkError.emptyDataError.error())
            }
        }
        
        let failedCallBack: (NSURLSessionDataTask!,  NSError!) -> Void = { (_, error) -> Void in
            finished(result: nil, error: error)
        }
        
        switch methord {
        case .GET:
            GET(urlString, parameters: params, success: successCallBack, failure: failedCallBack)
        case .POST:
            POST(urlString, parameters: params, success: successCallBack, failure: failedCallBack)
        }
    }
}
