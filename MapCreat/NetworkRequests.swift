//
//  NetworkRequests.swift
//  MapCreat
//
//  Created by Wilkon on 4/11/15.
//  Copyright (c) 2015 Wilkon. All rights reserved.
//

import Cocoa

class NetworkRequests: NSObject {
    class func dataWithKeyword(keyword: String, completionHandler handler: ((Bool,AnyObject)) ->Void){
        
        let basicUrl = "http://restapi.amap.com/v3/place/text?"
        let keyId = "8325164e247e15eea68b59e89200988b"
        let page = "1"
        let offset = "1"
        let city = "110000"
        
        let string = "\(basicUrl)keywords=\(keyword)&key=\(keyId)&page=\(page)&offset=\(offset)&city=\(city)"
        let urlString = string.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string: urlString!)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var dataTuple: (Bool,AnyObject)?
            if let data = NSData(contentsOfURL: url!){
                let dic = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                let pois = dic["pois"] as! NSArray
                if pois.count > 0{
                    dataTuple = (true,pois[0])
                }else{
                    dataTuple = (false,"查询的信息不存在")
                }
            }else{
                dataTuple = (false,"网络异常，检测网络")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                handler(dataTuple!)
            })
        })
    }

}
