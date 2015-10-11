//
//  UserAccount.swift
//  我的微博
//
//  Created by teacher on 15/7/29.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// 用户模型
class UserAccount: NSObject {
    /// 用户是否登录标记
    class var userLogon: Bool {
        return loadAccount() != nil
    }
    ///用户账户属性
    private static var userAccount: UserAccount?
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    /// access_token的生命周期，单位是秒数 - 准确的数据类型是`数值`
    var expires_in: NSTimeInterval = 0 {
        didSet {
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expiresDate: NSDate?
    /// 当前授权用户的UID
    var uid: String?
    ///昵称
    var name: String?
    ///用户头像
    var avatar_large: String?
    
    func loadUserInfo(finished: (error: NSError?) -> ()) {
        NetTools.shareTools.loadUserInfo(uid!) { (result, error) -> () in
            if error != nil {
                // 提示：error一定要传递！
                finished(error: error)
                return
            }
            
            // 设置用户信息
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            
            // 保存用户信息
            self.saveAccount()
            print(self)
            // 完成回调
            finished(error: nil)
        }
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        UserAccount.userAccount = self
        print(self)
    }
    
    /// 保存用户账号
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static private let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "\\account.plist"
    class func loadAccount() -> UserAccount? {
        if userAccount == nil {
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
        }
        if let date = userAccount?.expiresDate where date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            userAccount = nil
        }
        return userAccount
    }
    
    /// 对象描述信息
    override var description: String {
        let properties = ["access_token", "expires_in", "uid", "expiresDate", "name", "avatar_large"]
        
        return "\(dictionaryWithValuesForKeys(properties))"
    }
    // MARK: - NSCoding
    /// `归`档 -> 保存，将自定义对象转换成二进制数据保存到磁盘
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    /// `解`档 -> 恢复 将二进制数据从磁盘恢复成自定义对象
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
}
