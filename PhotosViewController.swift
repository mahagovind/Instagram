//
//  ViewController.swift
//  Instagram
//
//  Created by Maha Govindarajan on 2/3/16.
//  Copyright © 2016 Maha Govindarajan. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var media :[NSDictionary] = []
    var data = NSDictionary()
    var imageUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.dataSource = self
        tableView.delegate = self
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                           // print("response: \(responseDictionary)")
                            self.media = responseDictionary["data"] as! [NSDictionary]
                            
                            self.tableView.reloadData()

                            
                     
                    }
                }
        });
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count: \(media.count)")
        return media.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as!PhotosTableViewCell
      
        print("row: \(indexPath.row)")

                if let images = media[indexPath.row]["images"] as? NSDictionary {
                                             if let thumbnail = images["low_resolution"] as? NSDictionary {
                                                 if let url = thumbnail["url"] as? NSString {
                                                    print(url)
                                                    cell.imageView!.setImageWithURL(NSURL(string: url as String)!)
                                                }
                                            }
                                        }
        
        //    let url = self.media["data"]!["images"]!!["thumbnail"]!!["url"]
        //   let url2 = url!["images"]
        // print(url2)
        
        return cell
    }

}


