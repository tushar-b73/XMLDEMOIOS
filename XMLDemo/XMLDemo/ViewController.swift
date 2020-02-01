//
//  ViewController.swift
//  XMLDemo
//
//  Created by TUSHAR BAVALAVA on 03/01/20.
//  Copyright © 2020 TUSHAR BAVALAVA. All rights reserved.
//

import UIKit

class tblCellData: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescripation: UILabel!
    @IBOutlet weak var txtDesc:UITextView!
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

@available(iOS 13.0, *)
class ViewController: UIViewController,XMLParserDelegate,UITableViewDelegate,UITableViewDataSource{
   
    
     @IBOutlet weak var tblData:UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblCellData")as! tblCellData
        let arrdata:NSDictionary = posts.object(at: indexPath.row) as! NSDictionary
        
        cell.lblTitle.text = (arrdata.value(forKey: "title") as! String)
        
         let htmltext = arrdata.value(forKey: "description")as! String
        
        cell.txtDesc.attributedText = htmltext.htmlToAttributedString
        //posts.value(forKey: "title") as? String
    return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            let newsView = self.storyboard?.instantiateViewController(identifier: "NewsDetails")as! NewsDetails
        
        let arrdata:NSDictionary = posts.object(at: indexPath.row) as! NSDictionary
        let url = (arrdata.value(forKey: "link") as! String)
    
        newsView.NewsUrl = (url as! String)
        self.navigationController?.pushViewController(newsView, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 1000
    }
    
   
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var links = NSMutableString()
    var date = NSMutableString()
    var lblData = NSMutableString()
    var newsDesc = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginParsing()
        // Do any additional setup after loading the view.
    }

    
    func beginParsing()
    {
        posts = []
        parser = //XMLParser(contentsOf:(NSURL(string:"http://images.apple.com/main/rss/hotnews/hotnews.rss")! as URL))!
       
            XMLParser(contentsOf: URL(string: "https://timesofindia.indiatimes.com/rssfeeds/4719148.cms")!)!
       
        
            //XMLParser(contentsOf: URL(string: "https://news.google.com/?output=rss")!)!
        parser.delegate = self
        parser.parse()
        tblData.reloadData()
    
        
    
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            date = NSMutableString()
            date = ""
            links = NSMutableString()
            links = ""
            lblData = NSMutableString()
            newsDesc = NSMutableString()
            newsDesc = ""
        }
    }
    
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "title") {
            title1.append(string)
        } else if element.isEqual(to: "pubDate") {
            date.append(string)
        }else if element.isEqual(to: "link"){
            links.append(string)
        }else if element.isEqual(to: "description"){
            newsDesc.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item") {
            if !title1.isEqual(nil) {
                
                elements["title"] = title1
            
                //elements.setObject(title1, forKey: "title")
            }
            if !date.isEqual(nil) {
                  elements["date"] = date
                //elements.setObject(date, forKey: "date")
            
            }
            if !links.isEqual(nil){
                elements["link"] = links
            }
            if !newsDesc.isEqual(nil){
                elements["description"] = newsDesc
                
            }
            
            posts.add(elements)
        }
        
        print(posts)
    }
    
}

