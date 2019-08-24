//
//  DnpDescription.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/24.
//

import Foundation

protocol DnpLogLevel {
    func customDescription(level: Int ) -> String
}

extension Dictionary: DnpLogLevel {
    
    internal var description: String {
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
    
    internal func customDescription(level: Int) -> String{
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

extension Array: DnpLogLevel {
    internal func customDescription(level: Int) -> String {
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
    
    internal var description: String {
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
    internal func unicodeStrWith(level: Int) -> String {
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
    internal var unicodeStr:String {
        return self.unicodeStrWith(level: 1)
    }
}
