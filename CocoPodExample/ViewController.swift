//
//  ViewController.swift
//  CocoPodExample
//
//  Created by Bob Pascazio on 9/16/15.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadFromLoremPixel() {
        
        Alamofire.request(.GET, "http://lorempixel.com/300/400/cats/") .response { request, response, data, error in
            print(request)
            print(response)
            print(error)
            
            if let data_ = data {
                let image = UIImage(data:data_)
                self.imageView.image = image
            }
        }
        
    }
    
    @IBAction func reloadButton(sender: AnyObject) {
    
        self.loadFromLoremPixel()
    
    }

    @IBAction func uploadButton(sender: AnyObject) {
    }
    
    @IBAction func takePhotoButton(sender: AnyObject) {
    }
    
}

