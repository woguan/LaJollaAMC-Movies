//
//  MovieTableViewController.swift
//  Theater-Movies
//
//  Created by Guan Wong on 1/11/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation
import UIKit

struct Movie{
    var summaries = [String]()
    var images = [UIImage]()
    var titles = [String]()
    
}

class MovieTableViewController: UITableViewController, UISearchBarDelegate{
    
    var moviesData = Movie()
    var filteredData = Movie()
    
    var refresh_control:UIRefreshControl!
    var myRefresh:UIRefreshControl!
    var session: URLSession!

    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBAction func Pressed(_ sender: Any) {
        print("filter image size: ", filteredData.images.count)
        print("filtered description size: ", filteredData.summaries.count)
        
    }
    
    
    override func viewDidLoad() {
        
            super.viewDidLoad()
     print ("second view")
        
        session = URLSession.shared
        
        
      //  refresh_control = UIRefreshControl()
       // refresh_control.addTarget(self, action: #selector(MovieTableViewController.mainRefresh), for: .valueChanged)
     //   self.refreshControl = self.refresh_control
    
        mainRefresh()
        
        self.SearchBar.delegate = self
    }
    
    
    func mainRefresh(){
        
        let requestURL = URL(string: "http://www.fandango.com/amclajolla12_aabam/theaterpage?date=1/15/2017")
        
        
        let task = session.downloadTask(with: requestURL!, completionHandler: {(location, response, error) -> Void in
            
            guard let httpResponse = response as? HTTPURLResponse else{
                return
            }
            let statusCode = httpResponse.statusCode
            
            if ( statusCode != 200){
                return
            }
            
            guard let data = try? Data(contentsOf: location!) else{
                return
            }
            
            let fullText = String(data: data, encoding: String.Encoding.utf8)
            
            guard let ss = fullText else{
                return
            }
            
            if !ss.contains("itemscope itemtype=\"http://schema.org/Movie"){
                return
            }
            
            self.refresh(source: ss)
            
            
            //self.refreshControl?.endRefreshing()
        })
        
        task.resume()
    }
    
    
    func refresh(source: String){
         let data = source
         var partialData = data.components(separatedBy: "<span itemscope itemtype=\"http://schema.org/Movie\">")
         
         partialData.remove(at: 0)
         
         let imagesURL = retrieveImageURL(strings: partialData)
         moviesData.summaries = retrieveDescription(strings: partialData)
         moviesData.titles = retrieveTitle(strings: partialData)
        
         DispatchQueue.global().async{
         
         for str in imagesURL{
         let url = URL(string: str)
         let data = try? Data(contentsOf: url!)
         DispatchQueue.main.async{
         let img = UIImage(data: data!)
         self.moviesData.images.append(img!)
         }
         
         }
            DispatchQueue.main.sync {
               self.filteredData = self.moviesData
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
                as! MovieCell
            cell.cell_image.image = filteredData.images[indexPath[1] as Int]
            cell.cell_description.text = filteredData.summaries[indexPath[1] as Int]
            cell.cell_title.text = filteredData.titles[indexPath[1] as Int]
            return cell
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var newFilter_image = [UIImage]()
        var newFilter_title = [String]()
        var newFilter_description = [String]()
        
        /*newFilter_title = moviesData.titles.filter({(title: String) -> Bool in
            return (title.range(of: searchText, options: .caseInsensitive) != nil)
            
        })*/
        if (searchText == ""){
            self.filteredData = moviesData
            self.tableView.reloadData()
            return
        }
        
        for i in 0..<moviesData.images.count{
            if moviesData.titles[i].range(of: searchText, options: .caseInsensitive) != nil{
                newFilter_title.append(moviesData.titles[i])
                newFilter_image.append(moviesData.images[i])
                newFilter_description.append(moviesData.summaries[i])
            }
        }
        self.filteredData.titles = newFilter_title
        self.filteredData.summaries = newFilter_description
        self.filteredData.images = newFilter_image
        
        self.tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.SearchBar.resignFirstResponder()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.SearchBar.resignFirstResponder()
    }
    
  }
