//
//  UIView+Metrics.swift
//  MetricsLineDemo
//
//  Created by Zomfice on 2019/7/23.
//  Copyright © 2019 eyee. All rights reserved.
//

import UIKit
import Foundation

extension UIView: SelfAware{
    public static func awake() {
        swizzleMethod
    }
    private static let swizzleMethod: Void = {
        UIView.zom_swizzleInstanceMethodWithOriginSel(oriSel: #selector(layoutSubviews), swiSel: #selector(zom_layoutSubviews))
    }()
    
    @objc func zom_layoutSubviews() {
        self.zom_layoutSubviews()
        self.showMetrics()
    }
    
    func showMetricsRecursive() {
        for subView in self.subviews {
            subView.showMetricsRecursive()
        }
        self.showMetrics()
    }
    
    func showMetrics() {
        if !self.shouldShowMetricsView(){
            self.hideMetricsRecursive()
            return
        }
        
        var metricsView = self.getMetricsView()
        if metricsView == nil {
            metricsView = MetricsView(frame: self.bounds)
            metricsView?.tag = MetricsView.self.hash() + self.hash
            metricsView?.isUserInteractionEnabled = false
            self.addSubview(metricsView!)
        }
        guard let m_metricsView = metricsView else {
            return
        }
        m_metricsView.layer.borderColor = MetricsConfig.shared.borderColor.cgColor
        m_metricsView.layer.borderWidth = MetricsConfig.shared.borderWidth
        m_metricsView.isHidden = !MetricsConfig.shared.enable
    }
    
    func shouldShowMetricsView()-> Bool {
        if !MetricsConfig.shared.enable{
            return false
        }
        if self.isKind(of: MetricsView.self) {
            return false
        }
        
        // 状态栏不需要显示元素边框
        let statusBarString = "_statusBarWindow"
        let statusBarWindow = UIApplication.shared.value(forKey: statusBarString) as? UIWindow
        if let barwindow = statusBarWindow , self.isDescendant(of: barwindow){
            return false
        }
        
        if self.isInBlackList() {
            return false
        }
        
        return true
    }
    
    func hideMetricsRecursive() {
        for subView in self.subviews {
            subView.hideMetricsRecursive()
        }
        self.hideMetrics()
    }
    
    func hideMetrics() {
        let metricsView = self.getMetricsView()
        if let m_metricsView = metricsView {
            m_metricsView.isHidden = true
        }
    }
    
    func getMetricsView() -> MetricsView? {
        let tag = MetricsView.self.hash() + self.hash
        return self.viewWithTag(tag) as? MetricsView
    }
    
    func isInBlackList()-> Bool  {
        for blackname in MetricsConfig.shared.blackList {
            if let cls = NSClassFromString(blackname),let classname = cls as? UIVisualEffectView.Type {
                if self.isKind(of: classname){
                    return true
                }
            }
        }
        return false
    }
}

