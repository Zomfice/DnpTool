//
//  Log.swift
//  ZLNetworkComponent_Example
//
//  Created by Zomfice on 2019/7/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

protocol LogLevel {
    func customDescription(level: Int ) -> String
}

/// Print功能扩展(可选,Dictionary,Array,String)
///
/// - Parameters:
///   - message: 打印内容
///   - file: 文件
///   - function: 函数
///   - line: 行
public func ZLLog<T>(_ message:T, file:String = #file, function:String = #function,
              line:Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    if message is Dictionary<String, Any> {
        print("[\(fileName):line:\(line)]- \((message as! Dictionary<String, Any>).customDescription(level: 0))")
    }else if message is Array<Any> {
        print("[\(fileName):line:\(line)]- \((message as! Array<Any> ).customDescription(level: 0))")
    }else if message is CustomStringConvertible {
        print("[\(fileName):line:\(line)]- \((message as! CustomStringConvertible).description)")
    }else {
        print("[\(fileName):line:\(line)]- \(message)")
    }
    #endif
}


extension Optional: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "Optional(null)"
        case .some(let obj):
            if let obj = obj as? CustomStringConvertible, obj is Dictionary<String, Any> {
                return "Optional:" + "\((obj as! Dictionary<String, Any>).customDescription(level: 0))"
            }
            if let obj = obj as? CustomStringConvertible, obj is Array<Any> {
                return "Optional:" + "\((obj as! Array<Any>).customDescription(level: 0))"
            }
            return  "Optional" + "(\(obj))"
        }
    }
}

extension Dictionary: LogLevel {
    public var description: String {
        var str = ""
        str.append(contentsOf: "{\n")
        for (key, value) in self {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, s.unicodeStr))
            }else if value is Dictionary {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, (value as! Dictionary).description))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, (value as! Array<Any>).description))
            }else {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, "\(value)"))
            }
        }
        str.append(contentsOf: "}")
        return str
    }
    
    public func customDescription(level: Int) -> String{
        var str = ""
        var tab = ""
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        str.append(contentsOf: "{\n")
        for (key, value) in self {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "%@\t%@ = \"%@\",\n", tab, key as! CVarArg, s.unicodeStrWith(level: level)))
            }else if value is Dictionary {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, (value as! Dictionary).customDescription(level: level + 1)))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, (value as! Array<Any>).customDescription(level: level + 1)))
            }else {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, "\(value)"))
            }
        }
        str.append(contentsOf: String.init(format: "%@}", tab))
        return str
    }
}

extension Array: LogLevel {
    public func customDescription(level: Int) -> String {
        var str = ""
        var tab = ""
        str.append(contentsOf: "[\n")
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        for (_, value) in self.enumerated() {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "%@\t\"%@\",\n", tab, s.unicodeStrWith(level: level)))
            }else if value is Dictionary<String, Any> {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, (value as! Dictionary<String, Any>).customDescription(level: level + 1)))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, (value as! Array<Any>).customDescription(level: level + 1)))
            }else {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, "\(value)"))
            }
        }
        str.append(contentsOf: String.init(format: "%@]", tab))
        return str
    }
    
    public var description: String {
        var str = ""
        str.append(contentsOf: "[\n")
        for (_, value) in self.enumerated() {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "\t\"%@\",\n", s.unicodeStr))
            }else if value is Dictionary<String, Any> {
                str.append(contentsOf: String.init(format: "\t%@,\n", (value as! Dictionary<String, Any>).description))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "\t%@,\n", (value as! Array<Any>).description))
            }else {
                str.append(contentsOf: String.init(format: "\t%@,\n", "\(value)"))
            }
        }
        str.append(contentsOf: "]")
        return str
    }
}

// MARK: - unicode转码
extension String {
    public func unicodeStrWith(level: Int) -> String {
        let s = self
        let data = s.data(using: .utf8)
        if let data = data {
            if let id = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                if id is Array<Any> {
                    return (id as! Array<Any>).customDescription(level: level + 1)
                }else if id is Dictionary<String, Any> {
                    return (id as! Dictionary<String, Any>).customDescription(level: level + 1)
                }
            }
        }
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    public var unicodeStr:String {
        return self.unicodeStrWith(level: 1)
    }
}
