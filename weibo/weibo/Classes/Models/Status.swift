//
//  Status.swift
//  我的微博
//
//  Created by teacher on 15/8/1.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// 微博模型
class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?
    /// 用户
    var user: User?
    
    class func loadStatus(finished: (dataList: [Status]?, error: NSError?) -> ()) {
        
        NetTools.shareTools.loadStatus { (result, error) -> () in
            if error != nil {
                finished(dataList: nil, error: error)
            }
            
            if let array = result?["statuses"] as? [[String: AnyObject]] {
                var list = [Status]()
                
                for dict in array {
                    list.append(Status(dict: dict))
                }
                finished(dataList: list, error: nil)
            }
        }
        
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            if let dict = value as? [String: AnyObject] {
                user = User(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["created_at", "id", "text", "source", "pic_urls"]
        
        return "\(dictionaryWithValuesForKeys(keys))"
    }
    
}
