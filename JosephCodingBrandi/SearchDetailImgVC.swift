//
//  SearchDetailImgVC.swift
//  JosephCodingBrandi
//
//  Created by Joseph_iMac on 2020/12/30.
//

import UIKit
import SwiftyJSON

class SearchDetailImgVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var imgDic:NSDictionary?
    
    var siteNameValue: String!
    var dateTimeValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(JSON(imgDic!["image_url"] as Any).stringValue)
        
        siteNameValue = JSON(imgDic!["display_sitename"] as Any).stringValue
        dateTimeValue = JSON(imgDic!["datetime"] as Any).stringValue
        
        
        if let url = NSURL(string: JSON(imgDic!["image_url"] as Any).stringValue) {
            if let data = NSData(contentsOf: url as URL) {
                if let image = UIImage(data: data as Data) {
                    DispatchQueue.main.async(execute: { [self] in
                        let imageView = UIImageView()
                        imageView.image = image
                        imageView.contentMode = .scaleAspectFit
                        imageView.frame.size = image.size
                        
                        scrollView.addSubview(imageView)
                        
                        var textHeight = 0
                        if(siteNameValue.count != 0 || dateTimeValue.count != 0){
                            textHeight = 40
                        }
                        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: imageView.frame.size.height + CGFloat(textHeight))
                        
                        textInit(imgHeight: imageView.frame.size.height)
                    })
                }
            }
        }
    }
    
    // 출저, 문서작성시간 표시
    func textInit(imgHeight: CGFloat) {
        let botText = UILabel(frame: CGRect(x: 10, y: imgHeight + 10, width: self.view.frame.size.width, height: 20))
        botText.textAlignment = NSTextAlignment.left
        botText.font = UIFont.systemFont(ofSize: 12)
        botText.text = "출처:" + siteNameValue + ", 작성시간:" + date.getDateType(dateTimeValue)!
        scrollView.addSubview(botText)
    }
    
    // MARK: - Button
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
