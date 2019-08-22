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
        DnpToolManager.shareInstance.show()
        

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

