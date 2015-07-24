//
//  ViewController.swift
//  DatabaseTest
//
//  Created by Tanmay Bakshi on 2014-09-02.
//  Copyright (c) 2014 TBSS. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableview: UITableView!

    var data: NSArray = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(data)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        Alamofire.request(.GET, "http://kulchan.com/api/index.php?action=getUsers")
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                println(totalBytesRead)
            }
            .responseJSON { (request, response, JSON_, error) in
                if let final = JSON_ {
                    
                    if let final_2 = JSON(final).dictionaryObject {
                        
                        self.data = final_2["result"] as! NSArray
                        if !animated { self.reload() }
                        
                    }
                    
                }
            }
            .responseString { (request, response, string, error) in
                println(string)
        }
    }
    
    @IBAction func reload() {
        viewDidAppear(true)
        self.tableview.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func dataOfJson(url: String) -> NSDictionary {
        var finalJSON: JSON!
        Alamofire.request(.GET, "http://kulchan.com/api/index.php?action=getUsers")
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                println(totalBytesRead)
            }
            .responseJSON { (request, response, JSON_, error) in
                print("hi")
                finalJSON = JSON(JSON_!)
            }
            .responseString { (request, response, string, error) in
                println(string)
        }
        if let final = finalJSON.dictionaryObject {
            return final
        }
        return [:]
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: additionInfoCell = self.tableview.dequeueReusableCellWithIdentifier("customCell") as! additionInfoCell
        var maindata = (data[indexPath.row] as! NSDictionary)
        cell.name!.text = maindata["name"] as! String
        var userID = maindata["id"] as! Int
        var age = maindata["age"] as! String
        var imageURL = maindata["image"] as! String
        var image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL)!)!)
        cell.imageview!.image = image
        cell.info!.text = "id: \(userID)\nage: \(age)"
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    }
