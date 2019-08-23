//
//  DnpLogDetailController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/23.
//

import UIKit

class DnpLogDetailController: DnpToolBaseController {

    lazy var textView: UITextView = {
        let m_textView = UITextView()
        m_textView.backgroundColor = UIColor.white
        m_textView.translatesAutoresizingMaskIntoConstraints = false
        m_textView.setContentOffset(CGPoint(x: 0, y: -navigationHeight), animated: false)
        return m_textView
    }()
    
    var content : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout()
        self.showTextviewContent(content: content)
    }
    
    /// TextView显示
    func showTextviewContent(content: String) {
        let attribute = NSMutableAttributedString(string: content)
        let pattern0 = "((.*?)\\s=)|(\"(.*?)\"\\s:)"
        let contentRange0 = NSRange(location: 0, length: content.count)
        let express0 = try? NSRegularExpression.init(pattern: pattern0, options: .caseInsensitive)
        let expressResults0 = express0?.matches(in: content, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: contentRange0)
        if let result = expressResults0{
            for check in result {
                let range = NSRange(location: check.range.location, length: check.range.length > 1 ? check.range.length - 1 : check.range.length)
                let keycolor = UIColor(red: 58/255.0, green: 181/255.0, blue: 75/255.0, alpha: 1)
                attribute.addAttributes([NSAttributedString.Key.foregroundColor : keycolor], range: range)
            }
        }
        
        let pattern = "((https|http|ftp|rtsp|mms)?:\\/\\/)(.*?)(\"|\\s)"
        let contentRange = NSRange(location: 0, length: content.count)
        let express = try? NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
        let expressResults = express?.matches(in: content, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: contentRange)
        if let result = expressResults{
            for check in result {
                let range = NSRange(location: check.range.location, length: check.range.length > 1 ? check.range.length - 1 : check.range.length)
                let httpcolor = UIColor(red: 97/255.0, green: 210/255.0, blue: 214/255.0, alpha: 1)
                attribute.addAttributes([NSAttributedString.Key.foregroundColor : httpcolor], range: range)
            }
        }
        
        let keys = ["URL:","Method:","Headers:","RequestBody:","Response:"]
        for m_key in keys {
            let keycolor = UIColor(red: 146/255.0, green: 38/255.0, blue: 143/255.0, alpha: 1)
            let range = NSString(string: content).range(of: m_key)
            attribute.addAttributes([NSAttributedString.Key.foregroundColor : keycolor], range: range)
        }
        self.textView.attributedText = attribute
    }
    //let subStr = (content as NSString).substring(with: textResult)
    
    
    func layout() {
        self.view.addSubview(self.textView)
        NSLayoutConstraint(item: self.textView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 1).isActive = true
        NSLayoutConstraint(item: self.textView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 1).isActive = true
        NSLayoutConstraint(item: self.textView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 1).isActive = true
        NSLayoutConstraint(item: self.textView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 1).isActive = true
    }

    
}
