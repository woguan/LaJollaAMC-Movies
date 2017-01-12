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
        
        
        refresh_control = UIRefreshControl()
        refresh_control.addTarget(self, action: #selector(MovieTableViewController.mainRefresh), for: .valueChanged)
        self.refreshControl = self.refresh_control
    
        self.SearchBar.delegate = self
        
        
        mainRefresh()
    }
    
    
    func mainRefresh(){
        moviesData = Movie()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "M/d/YYYY"
        
        let todayDate = dateFormatter.string(from: date)
        
        let requestURL = URL(string: OriginalSourceURL+todayDate)
        
        
        let task = session.downloadTask(with: requestURL!, completionHandler: {(location, response, error) -> Void in
            
            guard let httpResponse = response as? HTTPURLResponse else{
                
                let msgerr = (error?.localizedDescription)! as String
                
                print(msgerr)
                
                self.refreshControl?.endRefreshing()
                return
            }
            
            if ( httpResponse.statusCode != 200){
                print ("Not able to access the website")
                self.refreshControl?.endRefreshing()
                return
            }
            
            guard let data = try? Data(contentsOf: location!) else{
                print ("Not able to retrieve data from the website")
                self.refreshControl?.endRefreshing()
                return
            }
            
            let fullText = String(data: data, encoding: String.Encoding.utf8)
            
            guard let ss = fullText else{
                print ("data Failed to convert to String")
                self.refreshControl?.endRefreshing()
                return
            }
            
            if !ss.contains(RequiredString){
                print ("Does not have data to be loaded")
                self.refreshControl?.endRefreshing()
                return
            }
            
            self.refresh(source: ss)
            
        })
        
        task.resume()
    }
    
    
    func refresh(source: String){
         let data = source
         var partialData = data.components(separatedBy: PartialData)
         
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
                self.refreshControl?.endRefreshing()
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
        
        var newFilterData = Movie()

        if searchText == "" {
            self.filteredData = moviesData
            self.tableView.reloadData()
            return
        }
        
        for i in 0..<moviesData.images.count{
            if moviesData.titles[i].range(of: searchText, options: .caseInsensitive) != nil{
                newFilterData.titles.append(moviesData.titles[i])
                newFilterData.images.append(moviesData.images[i])
                newFilterData.summaries.append(moviesData.summaries[i])
            }
        }
        self.filteredData = newFilterData
        
        self.tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.SearchBar.resignFirstResponder()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.SearchBar.resignFirstResponder()
    }
    
  }
