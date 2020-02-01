//
//  NewsDetails.swift
//  XMLDemo
//
//  Created by TUSHAR BAVALAVA on 03/01/20.
//  Copyright © 2020 TUSHAR BAVALAVA. All rights reserved.
//

import UIKit
import WebKit


class NewsDetails: UIViewController {
    
    var NewsUrl:String!
    
    @IBOutlet weak var webUrl: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(NewsUrl!)
        
        let text =  NewsUrl
        let test = String(text?.filter { !" \n\t\r".contains($0) } ?? "")
        
        
        let url = URL(string:test)
        webUrl.load(URLRequest(url: url!))
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
