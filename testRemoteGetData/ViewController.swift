//
//  ViewController.swift
//  testRemoteGetData
//
//  Created by Peter on 2018/5/18.
//  Copyright © 2018年 Peter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate{
    var label: UILabel?
    var documentURL: URL?
    var theDataURLString: String?
    var localDataURL: URL?
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var data: Data?
        
        do{
            data = try Data.init(contentsOf: location)
            try data?.write(to: localDataURL!, options: .atomic)
        }catch let error as NSError{
            print(error)
            return
        }
        print("Complete")
        
    }
    
    func parseJson(localDataURL: String) -> String{
        let localURL = URL(string:localDataURL)
        let localData: Data?
        var dataString: String?
        do{
            localData = try Data(contentsOf: localURL!)
            dataString = try JSONSerialization.jsonObject(with: localData!, options: .allowFragments) as? String
        }catch{
            print("data wrong")
        }
        return dataString!
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("\(totalBytesWritten)/\(totalBytesExpectedToWrite)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        documentURL = URL.init(fileURLWithPath: urls[0].absoluteString)
        localDataURL = documentURL?.appendingPathComponent("hello.json")
        theDataURLString = "http://localhost:8080/hello"
        normalGet(myURL: theDataURLString!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func normalGet(myURL: String){
        let url = URL.init(string: myURL)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let downloadTask = session.downloadTask(with: url!)
        downloadTask.resume()
    }
    
    


}

