//
//  HotWeibo.swift
//  weibo
//
//  Created by 杨晓晨 on 15/10/11.
//  Copyright © 2015年 yangxiaochen. All rights reserved.
//

import UIKit
class HotWeibo: NSObject {
  class func loadHotWeibo() {
        let params = ["source": "3696368993","access_token": "2.00tlNLlCj7aJCEdb850bc3b70YRm6k"]
        NetTools.shareTools.requestGET("https://api.weibo.com/2/statuses/public_timeline.json", params: params) { (result, error) -> () in
            print(result)
    }
        }
}
