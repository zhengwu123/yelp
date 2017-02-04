//
//  SearchViewController.swift
//  Movie review
//
//  Created by New on 1/11/16.
//  Copyright © 2016 New. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource , UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let data = ["Star Wars: The Force Awakens", "The Revenant", "The Hateful Eight", "Sherlock: The Abominable Bride",
        "Joy", "The Big Short", "The Intouchables", "The Godfather",
        "Paperman", "Victoria", "Interstellar", "Whiplash",
        "Room", "Feast", "Krampus", "Spirited Away",
        "Boruto: Naruto the Movie", "Song of the Sea", "Princess Mononoke", "Gone Girl","The Shawshank Redemption","Garage Sale Mystery: Guilty Until Proven Innocent","Extraction","Love's Complicated","The 5th Wave","Point Break","The Ridiculous 6","Alvin and the Chipmunks: The Road Chip","The Forest"]
    var flitered: [String]!
    var movies: [NSDictionary]?
    var movieTitles: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
       flitered = data
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                           
                            self.tableView.reloadData()
                    }
                }
        });
       
        //}
        task.resume()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

       
           return flitered.count
     
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! searchTableCell
      
         cell.movietitle?.text = flitered[indexPath.row]
   
        return cell
    }
   
    //func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) //{
       // <#code#>
  //  }
    @IBAction func ontap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        flitered = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
       tableView.reloadData()
    }
}
