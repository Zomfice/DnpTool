//
//  DnpTool.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/30.
//

import UIKit

@objc public class DnpTool: NSObject {
    @objc public static let shareInstance  = DnpTool()
    private var enterView : DnpToolEnterView!
    private var startPlugins = [String]()
    /// custom module show
    public var configModule: (() -> [[String:String]] )?
    /// custom module jump
    public var jumpModule: (()-> [[String: Any]])?
    
    override init() {
        super.init()
        self.initconfig()
    }
    
    @objc public func show() {
        self.initEnter()
    }
    
    internal func hidden() {
        enterView.isHidden = true
    }
    
    internal func initEnter() {
        enterView = DnpToolEnterView()
        enterView.makeKeyAndVisible()
    }
    
    internal func initconfig() {
        /// 初始化Log监听
        if UserDefaults.standard.bool(forKey: "\(DnpToolLogController.self)") {
            DnpLogListController.addnotification()
        }
    }
    
    /// 是否显示DnpLog
    @objc public static var logisShow : Bool{
        return UserDefaults.standard.bool(forKey: "\(DnpToolLogController.self)")
    }
    
    /// 监听网络Log需格式化参数
    ///
    /// - Parameters:
    ///   - url: URL
    ///   - method: Method(get post)
    ///   - headers: Request headers
    ///   - body: Request body
    ///   - response: Response
    ///   - error: Error
    @objc public static func dnpLogDataFormat(url: String?,method: String?,headers: Any?,body: Any?,response: Any?,error: NSError?) {
        var p_url = ""
        if let m_url = url{
            p_url = m_url
        }
        var p_method = "{\n\n}"
        if let m_method = method{
            p_method = m_method
        }
        var p_headers = "{\n\n}"
        if let m_headers = headers as? [String: Any]{
            p_headers = String.jsonToString(dic: m_headers)
        }else if let n_headers = headers{
            p_headers = "{\n\(n_headers)\n}"
        }
        var p_body = "{\n\n}"
        if let m_body = body as? [String: Any]{
            p_body = String.jsonToString(dic: m_body)
        }else if let n_body = body{
            p_body = "{\n\(n_body)\n}"
        }
        var p_response = "{\n\n}"
        if let e = error{
            p_response = "{\n\(e)\n}"
        }else if let m_response = response as? [String: Any]{
            p_response = String.jsonToString(dic: m_response)
            //m_response.customDescription(level: 0)
        }else if let n_response = response{
            p_response = "{\n\(n_response)\n}"
        }
        let netlog = "URL: " + "\(p_url)" + "\n\n"
            + "Method: " + "\(p_method)" + "\n\n"
            + "Headers: " + "\(p_headers)" + "\n\n"
            + "RequestBody: " + "\(p_body)" + "\n\n"
            + "Response: " + "\(p_response)" + "\n\n"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DnpLogNotification), object: nil,userInfo: [DnpLog:netlog])
    }
}

// MARK: 使用文档
/*
 1. 配置自定义模块
     DnpTool.shareInstance.configModule = {
     return [["title": "--","type": "2"]]
     }
     DnpTool.shareInstance.jumpModule = {
     return [["type": "2","class": SecondController.self]]
     }
 */
