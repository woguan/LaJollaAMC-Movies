//
//  FirstViewController.swift
//  Theater-Movies
//
//  Created by Guan Wong on 1/11/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    @IBOutlet weak var mainText: UILabel!

    @IBOutlet weak var bodyText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       /*
        let test = Bundle.main.path(forResource: "text", ofType: "")
        
        guard let path = test else {
            print("nothing")
            return
        }
       
        guard let data = try? String(contentsOfFile: path) else{
            print("did not work")
            return
        }
        
        //print (data)
        
        //let f = data.components(separatedBy: "<span itemscope=\"http://schema.org/Movie\">")
        var partialData = data.components(separatedBy: "<span itemscope itemtype=\"http://schema.org/Movie\">")
        
        partialData.remove(at: 0)
        
        let imagesURL = retrieveImageURL(strings: partialData)
        let description = retrieveDescription(strings: partialData)
        let v = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        
        let url = URL(string: imagesURL[1])
        
        DispatchQueue.global().async{
            
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async{
                let img = UIImage(data: data!)
                
                let asd = UIImageView(image: img!)
                
                v.addSubview(asd)
            }
            
        }
        
      self.view.addSubview(v)*/
       
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let todayDate = dateFormatter.string(from: date)
        self.mainText.text = todayDate
        
        self.bodyText.text = "Showing movies of La Jolla AMC 12 Movie Theather"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

