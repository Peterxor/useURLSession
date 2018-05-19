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
    var downloadFinished: Bool?
    var checkDownloadFinished: Timer?
    
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
        downloadFinished = true
    }
    
    @objc func checkDownload(){
        if downloadFinished!{
            self.label?.text = parseJson(dataURL: localDataURL!)
            self.view.addSubview(self.label!)
            self.checkDownloadFinished?.invalidate()
        }
    }
    
    func parseJson(dataURL: URL) -> String{
        let localData: Data?
        var data: [String:String]
        do{
            localData = try Data(contentsOf: dataURL)
            data = try JSONSerialization.jsonObject(with: localData!, options: .allowFragments) as! [String:String]
        }catch let error as NSError{
            print(error)
            return error.localizedDescription
        }
        print(data)
        print("parse Done")
        return data["content"]!
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("\(totalBytesWritten)/\(totalBytesExpectedToWrite)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadFinished = false
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        documentURL = URL.init(fileURLWithPath: urls[0].absoluteString)
        localDataURL = documentURL?.appendingPathComponent("hello.json")
        theDataURLString = "http://localhost:8080/hello"
        normalGet(myURL: theDataURLString!)
        label = UILabel(frame: CGRect(x: 150, y: 150, width: 100, height: 30))
        checkDownloadFinished = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkDownload), userInfo: nil, repeats: true)
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

