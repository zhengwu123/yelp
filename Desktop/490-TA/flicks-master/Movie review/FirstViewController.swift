//
//  FirstViewController.swift
//  Movie review
//
//  Created by New on 1/5/16.
//  Copyright © 2016 New. All rights reserved.
//

import UIKit
import AFNetworking
//import EZLoadingActivity


class FirstViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate
    
{         var filteredMovies = [NSDictionary]()
    var searchController = UISearchController()
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var imageOut: UIImageView!
    var detailedView = detialViewController()
    var movies: [NSDictionary]?
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var movietitle: UILabel!
    
    
    
    
    var movietitleText = ""
    var relasedate = ""
    var popularity : NSNumber!
    var  vote_average : NSNumber!
    var votecount : NSNumber!
    var overview = ""
    var  posterPath = ""
    var baseURL = ""
    var imageURL :URL!
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //EZLoadingActivity.show("Loading...", disableUI: true)
        self.tabBarController?.tabBar.backgroundColor = UIColor.blue
        self.tabBarController?.tabBar.tintColor = UIColor.brown
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // check internet
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        retriveData()
        refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(FirstViewController.reload), for: UIControlEvents.valueChanged)
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        retriveData()
    }
    func retriveData(){
        
        // retrieve data from internet
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
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
        task.resume()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let textInput: String = searchBar.text!
        for i in 0...self.movies!.count {
            let movie = movies![i]
            let movieName = movie["title"] as! String
            let filteredMovieName = movieName.substring(to: movieName.characters.index(movieName.startIndex, offsetBy: textInput.characters.count))
            if (textInput == filteredMovieName) {
                continue
            } else {
                self.movies?.remove(at: i)
            }
        }
        self.tableView.reloadData()
        if searchBar.text! == "" {
            retriveData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            
        }
        else{
            if let movies = movies{
                return movies.count
            }
            
            
            
        }
        return 0
    }
    
    func reload(){
        self.tableView.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //EZLoadingActivity.hide(success: true, animated: false)
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! movieCellController
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let imageURL = URL(string: baseURL + posterPath)
        // cell.imageOut.setImageWithURL(imageURL!)
        // cell.imageOut
        cell.titleLabel.text = title
        cell.DescriptionTextArea.text = overview
        
        let imageUrl = imageURL
        let imageRequest = URLRequest(url:imageUrl! )
        
        cell.imageOut.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.imageOut.alpha = 0.0
                    cell.imageOut.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.imageOut.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.imageOut.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        
        return cell
        
    }
    // var movietitle = ""
    //var relasedate = ""
    //var popularity:NSNumber = 0.0
    //var vote_average:NSNumber = 0.0
    // var votecount:NSNumber = 0
    //var overview = ""
    //var posterPath = ""
    //var baseURL = ""
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let movie = movies![indexPath.row]
        movietitleText = movie["title"] as! String
        relasedate = movie["release_date"] as! String
        popularity = movie["popularity"] as! NSNumber
        vote_average = movie["vote_average"] as! NSNumber
        votecount = movie["vote_count"] as! NSNumber
        overview = movie["overview"] as! String
        posterPath = movie["poster_path"] as! String
        baseURL = "http://image.tmdb.org/t/p/w500"
        imageURL = URL(string: baseURL + posterPath)!
        
        //      detailedView.releaseDate.text = "Release Date: " + relasedate
        //        detailedView.popularityLabel.text = "Popularity: " + s
        //        detailedView.vote_averageLabel.text = "Vote Average: " + s_average
        //        let s_average:String = String(format:"%.2f", vote_average.doubleValue)
        //        let s:String = String(format:"%.2f", popularity.doubleValue)
        //        let s_count:String = String(format:"%f", votecount.doubleValue)
        //        self.voteCountLabel.text = "Vote Count: " + s_count
        //        self.detailedLabel.text = "10000"
        //       self.movietitle.text = movietitleText
        self.performSegue(withIdentifier: "toDetail", sender: self)
        //        print(movietitle)
        //        print(popularity)
        //        print(relasedate)
        //        print(vote_average)
        //        print(overview)
        //print(detialViewController().releaseDate.text)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"  {
            let detialViewControllerInstance = segue.destination as! detialViewController
            detialViewControllerInstance.detailedLabelText = overview
            detialViewControllerInstance.DetailImageURL = imageURL
            detialViewControllerInstance.movieTitleText = movietitleText
            let s_popularity:String = "Popularity: " + String(format:"%.2f", popularity.doubleValue)
            detialViewControllerInstance.popularityLabelText = s_popularity
            let s_count:String = "Vote Count: " + String(format:"%d", votecount.int32Value)
            detialViewControllerInstance.voteCountLabelText = s_count
            detialViewControllerInstance.releaseDateText = relasedate
            let s_average:String = "Vote Average: " + String(format:"%.2f", vote_average.doubleValue)
            detialViewControllerInstance.vote_averageLabelText = s_average
        }
    }
    
    
    
    
}

