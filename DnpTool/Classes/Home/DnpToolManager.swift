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
    }
    
    func hidden() {
        enterView.isHidden = true
    }
}
