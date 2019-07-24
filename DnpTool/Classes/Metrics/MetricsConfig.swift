//
//  MetricsConfig.swift
//  MetricsLineDemo
//
//  Created by Zomfice on 2019/7/23.
//  Copyright © 2019 eyee. All rights reserved.
//

import Foundation
import UIKit

public class MetricsConfig: NSObject {
    public static let shared = MetricsConfig()
    public var borderColor = UIColor.red
    public var borderWidth: CGFloat = 1
    internal var enable: Bool = false
    public var ignoreSystemView: Bool = true
    internal var blackList = [String]()
    
    public override init() {
        super.init()
        self.blackList = [NSStringFromClass(UIVisualEffectView.self)]
    }
    
    /// 是否开启元素线
    public func setEnable(_ enable: Bool) {
        MetricsConfig.shared.enable = enable
        for window in UIApplication.shared.windows {
            if enable {
                window.showMetricsRecursive()
            }else{
                window.hideMetricsRecursive()
            }
        }
    }
}
