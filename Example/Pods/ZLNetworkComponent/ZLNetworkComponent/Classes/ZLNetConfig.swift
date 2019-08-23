//
//  ZLNetConfig.swift
//  AFNetworking
//
//  Created by Zomfice on 2019/7/3.
//

import UIKit

/// 当前网络环境
public enum NetScheme {
    case on_line    /// 线上
    case on_develop /// 开发
    case on_mock    /// mock
}

public class ZLNetConfig: NSObject {
    
    /// 是否需要域名(使用自定义url请求,需置false,是: 域名(http:/baidu.com)+path(meinv/capi),否: url中包含域名"http:/baidu.com/meinv/cpai")
    public var isNeedDomainName: Bool = true
    /// 是否需要基础参数
    public var isNeedBaseParam: Bool = false
    /// 是否需要serviceResponse(使用自定义url请求,需置为false,response返回data中数据)
    public var isNeedServiceResponse: Bool = true
    /// 当前网络环境
    public var netScheme: NetScheme = .on_line
    /// 域名(外部传递域名优先读取外部域名)
    public var domainName: String = ""
    /// 基础参数
    public var baseParam = [String:String]()
    /// 用户Token(必传)
    public var userToken: String = ""
    /// 阿里签名验证token
    public var avmpToken: String?
    /// uuid
    public var deviceid: String = ""
    /// 公共请求头(os version deviceid)
    public var commonHeaderInfo: [String:String]?
    /// 是否需要打印Log
    public var isNeedLog: Bool = false

    // MARK: - Implementation
    public override init() {
        super.init()
    }
    
}

extension NetScheme {
    public var desc: String{
        switch self {
        case .on_line:
            return "https://mapi.eyee.com/"
        case .on_develop:
            return "https://stest.eyee.com/"
        case .on_mock:
            return "http://mock.api.eyee.com/"
        }
    }
}



//----文档-----
/*
 
 1. 修改EYEE Swift的debug配置https://www.twblogs.net/a/5b7fc8552b717767c6b1a05e/zh-cn
 2.
 
 */
