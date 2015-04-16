//
//  ViewController.swift
//  MapCreat
//
//  Created by Wilkon on 4/10/15.
//  Copyright (c) 2015 Wilkon. All rights reserved.
//

import Cocoa

class ViewController: NSViewController,NSTextFieldDelegate {
    
    @IBOutlet weak var keywordTextField: NSTextField!
    @IBOutlet weak var chooseFileButton: NSButton!
    @IBOutlet weak var searchButton: NSButton!
    
    @IBOutlet weak var lnglatLabel: NSTextField!
    
    @IBOutlet var resultTextView: NSTextView!
    @IBOutlet var leftResultView: NSTextView!
    @IBOutlet var rightResultView: NSTextView!
    
    @IBOutlet weak var leftUpperText: NSTextField!
    @IBOutlet weak var rightUpperText: NSTextField!
    @IBOutlet weak var leftDownText: NSTextField!
    @IBOutlet weak var rightDownText: NSTextField!
    
    var keywords:[String] = []
    var currentIndex:Int = 0
    var markers:[MarkerModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftUpperText.delegate = self
        leftDownText.delegate = self
        rightDownText.delegate = self
        rightUpperText.delegate = self
        
    }
    
    override func awakeFromNib() {
        leftResultView.superview?.superview?.hidden = true
        rightResultView.superview?.superview?.hidden = true
    }
    
    @IBAction func searchAction(sender: AnyObject) {
        leftResultView.superview?.superview?.hidden = true
        rightResultView.superview?.superview?.hidden = true
        resultTextView.superview?.superview?.hidden = false
        currentIndex = 0
        markers.removeAll(keepCapacity: true)
        let keyword = keywordTextField.stringValue
        if !keyword.isEmpty{
            keywords = self.keywordsWithSearchValue(keyword)
            self.creatMarkerWithKeywords()
        }else{
            lnglatLabel.stringValue = "关键字不能为空！"
        }
    }
    
    @IBAction func otherSearchAction(sender: AnyObject) {
        leftResultView.superview?.superview?.hidden = true
        rightResultView.superview?.superview?.hidden = true
        resultTextView.superview?.superview?.hidden = false
        
    }
    
    @IBAction func compareAction(sender: AnyObject) {
        leftResultView.superview?.superview?.hidden = false
        rightResultView.superview?.superview?.hidden = false
        resultTextView.superview?.superview?.hidden = true
    }
    
    @IBAction func clearAction(sender: AnyObject) {
        
    }
    
    func keywordsWithSearchValue(searchValue:String)->[String]{
        if NSFileManager.defaultManager().fileExistsAtPath(searchValue){
            let fileData = NSString(contentsOfFile: searchValue, encoding: NSUTF8StringEncoding, error: nil)
            return fileData?.componentsSeparatedByString("、") as! [String]
        }else{
            return searchValue.componentsSeparatedByString("、")
        }
    }
    
    func creatMarkerWithKeywords(){
        if currentIndex >= keywords.count{
            resultTextView.string = markers.description
            return
        }
        let keyword = keywords[currentIndex]
        NetworkRequests.dataWithKeyword(keyword, completionHandler: { (data) -> Void in
            if data.0{
                let dic = data.1 as! NSDictionary
                let location = dic["location"] as! String
                let lnglat = location.componentsSeparatedByString(",") as [String]
                let marker = MarkerModel(name: dic["name"] as! String, address: dic["address"] as! String, location: "lng: \(lnglat[0]), lat: \(lnglat[1])")
                self.lnglatLabel.stringValue = marker.location
                self.keywordTextField.stringValue = marker.name
                self.markers.append(marker)
                self.currentIndex++
                self.creatMarkerWithKeywords()
            }else{
                self.lnglatLabel.stringValue = data.1 as! String
            }
        })
    }
    
    @IBAction func lnglatClickAction(sender: NSClickGestureRecognizer) {
        if leftUpperText.stringValue.isEmpty{
            leftUpperText.stringValue = lnglatLabel.stringValue
        }else if rightUpperText.stringValue.isEmpty{
            rightUpperText.stringValue = lnglatLabel.stringValue
        }else if leftDownText.stringValue.isEmpty{
            leftDownText.stringValue = lnglatLabel.stringValue
        }else if rightDownText.stringValue.isEmpty{
            rightDownText.stringValue = lnglatLabel.stringValue
        }
    }
    

    @IBAction func chooseFileAction(sender: AnyObject) {
        var panel = NSOpenPanel()
        panel.prompt = "OK"
        panel.allowedFileTypes = ["txt"]
        let result = panel.runModal()
        if Bool(result){
            if let url = panel.URL?.absoluteString?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding){
                let path = url.substringFromIndex(advance(url.startIndex, 7))
                keywordTextField.stringValue = path
            }
        }
    }
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

