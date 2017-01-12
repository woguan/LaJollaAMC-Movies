//
//  FirstViewController.swift
//  Theater-Movies
//
//  Created by Guan Wong on 1/11/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

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
        
        print ("first view")
        
    }
    
    func retrieveImageURL (strings: [String]) -> [String]{
        
        var result = [String]()
        
        for str in strings{
            let lowerbound = str.range(of: "\"image\" content=\"")?.upperBound
            let upperbound = str.range(of: ".jpg")?.lowerBound
            result += [str.substring(with: lowerbound! ..< upperbound!) + ".jpg"]
        }
        
        
        return result
    }
    
    func retrieveDescription (strings: [String]) -> [String]{
        var result = [String]()
        
        for str in strings{
            let lowerbound = str.range(of: "description\" content=\"")?.upperBound
            let first = str.substring(from: lowerbound!)
            let upperbound = first.range(of: "/>")?.lowerBound
            var final = first.substring(to: upperbound!)
            
            while final[final.index(before: final.endIndex)] != "."{
            final.remove(at: final.index(before: final.endIndex))
            }
            result += [final]
        }
        
        
        return result
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

