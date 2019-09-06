//
//  ViewController.swift
//  DnpTool
//
//  Created by songchaofeng6@hotmail.com on 07/24/2019.
//  Copyright (c) 2019 songchaofeng6@hotmail.com. All rights reserved.
//

/*
 需要完善：通知在异步处理,通知在单独线程处理,单独开辟一个线程处理通知的发送和接收
 */

import UIKit
import DnpTool
import ZLNetworkComponent

class ViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(request), userInfo: nil, repeats: true)
        //RunLoop.current.add(timer, forMode: .common)
        
        //request()
    }

    
    @objc func request() {
        let path = "http://meizi.leanapp.cn/category/All/page/1"
        //DnpTool.dnpLogDataFormat(url: path, method: "POST", headers: "请求头", body: "请求参数", response: nil, error: nil)
        
        ZLNetWork.request(requestType: .get, path: path, parameters: nil, netConfig: nil, progressBlock: nil, dataTaskBlock: nil, serviceResponse: nil) { (response, error) in
            if let m_response = response{
                //print("----\(m_response)")
                DnpTool.dnpLogDataFormat(url: path, method: "POST", headers: "请求头", body: "请求参数", response: m_response, error: error)
                
                /*
                let headers = "请求头"
                let param = "请求参数"
                var result = "nil"
                if let mm_response = m_response as? [String:Any]{
                    result =  mm_response.customDescription(level: 0)
                }else{
                    result = "\(m_response)"
                }
                let netlog = "URL: " + "\(path)" + "\n\n"
                    + "Method: " + "POST" + "\n\n"
                    + "Headers: " + "\(headers)" + "\n\n"
                    + "RequestBody: " + "\(param)" + "\n\n"
                    + "Response: \n" + "\(result)" + "\n\n"
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DnpLogNotification), object: nil, userInfo: ["DnpLog":netlog])
                */
            }else{
                DnpTool.dnpLogDataFormat(url: path, method: "POST", headers: "请求头", body: "请求参数", response: nil, error: error)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DnpTool.shareInstance.show()
        DnpTool.shareInstance.configModule = {
            return [
                ["title": "环境切换","type": "2"],
                ["title": "模型数据","type": "3"],
                ["title": "MOMODA","type": "4"]
            ]
        }
        
        DnpTool.shareInstance.jumpModule = {
            return [
                ["type": "2","class": SecondController.self],
                ["type": "3","class": ThirdController.self],
                ["type": "4","class": ThirdController.self]
            ]
        }
    }
    
    
    
    
}



extension ViewController {
    func charcalcult() {
        let string = "abca"//bcbb"//pwwkew
        let charArr:[Character] = Array(string)
        
        
        for c in charArr[0...0]{
            print("---------")
        }
        
        var count = 0
        first: for (i,value) in charArr.enumerated() {
            var num = 0
            if i < charArr.count - 1,value != charArr[i+1]{
                for c in charArr[0...i]{
                    print("++++\(charArr[0...i])")
                    if c == charArr[i+1]{
                        continue first
                    }else{
                        num = num + 1
                    }
                }
            }else{
                continue first
            }
            
            if num >= count {
                count = num
            }
        }
        print("----\(count)")
    }
    
    
    func metrics() {
        MetricsConfig.shared.setEnable(false)
        
        MetricsConfig.shared.borderColor = UIColor.magenta
        
        let name = "\(UIVisualEffectView.self)"
        let effect = UIVisualEffectView()
        
        if let cls = swiftClassFromString_system(className: name),let clname = cls as? UIVisualEffectView.Type {
            //print("----\(clname.self)")
            print("----\(effect.isKind(of: clname))")
        }
    }
    
    /// 获取系统类类型
    public func swiftClassFromString_system(className: String) -> AnyClass? {
        return NSClassFromString(className)
    }
    
    /// 获取Bundle中类类型
    public func swiftClassFromString_bundle(className: String) -> AnyClass? {
        if let bundlename = Bundle.main.object(forInfoDictionaryKey: "CFBundleName"),let appname = bundlename as? String {
            let classString = appname + "." + className
            return NSClassFromString(classString)
        }
        return nil;
    }
}

/*
 #if DEBUG
 var headers = "nil"
 if let m_header = ZLNetWork.sharedManager?.requestSerializer.httpRequestHeaders{
 headers = String.jsonToString(dic: m_header)
 }
 var methodstr = "unknown"
 switch method {
 case .get:
 methodstr = "GET"
 case .post:
 methodstr = "POST"
 default:
 break
 }
 var param = "nil"
 if let m_param = parameters as? [String: Any]{
 param = String.jsonToString(dic: m_param)
 }
 var result = "nil"
 if let m_response = response as? [String:Any]{
 result =  m_response.customDescription(level: 0)
 }else{
 result = "\(response ?? "")"
 }
 let netlog = "URL: " + "\(urlPath)" + "\n\n"
 + "Method: " + "\(methodstr)" + "\n\n"
 + "Headers: " + "\(headers)" + "\n\n"
 + "RequestBody: " + "\(param)" + "\n\n"
 + "Response: \n" + "\(result)" + "\n\n"
 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DnpLogNotification"), object: nil,userInfo: ["DnpLog":netlog])
 #endif
 */
