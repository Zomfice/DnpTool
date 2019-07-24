//
//  ViewController.swift
//  DnpTool
//
//  Created by songchaofeng6@hotmail.com on 07/24/2019.
//  Copyright (c) 2019 songchaofeng6@hotmail.com. All rights reserved.
//

import UIKit
import DnpTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MetricsConfig.shared.setEnable(true)
        
        MetricsConfig.shared.borderColor = UIColor.magenta
        
        let name = "\(UIVisualEffectView.self)"
        let effect = UIVisualEffectView()
        
        if let cls = swiftClassFromString_system(className: name),let clname = cls as? UIVisualEffectView.Type {
            //print("----\(clname.self)")
            print("----\(effect.isKind(of: clname))")
        }
        /// OC中isKindOfClass
        if self.view.isKind(of: UIView.self){
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

