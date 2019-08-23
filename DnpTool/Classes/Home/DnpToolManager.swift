//
//  DnpToolManager.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/30.
//

import UIKit

public class DnpToolManager: NSObject {
    public static let shareInstance  = DnpToolManager()
    var enterView : DnpToolEnterView!
    var startPlugins = [String]()
    
    public func show() {
        self.initEnter()
    }
    
    func initEnter() {
        enterView = DnpToolEnterView()
        enterView.makeKeyAndVisible()
        initconfig()
    }
    
    func hidden() {
        enterView.isHidden = true
    }
    
    func initconfig() {
        /// 初始化Log监听
        if UserDefaults.standard.bool(forKey: "\(DnpToolLogController.self)") {
            DnpLogListController.addnotification()
        }
    }
}
