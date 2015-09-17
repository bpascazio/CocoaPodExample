//
//  ViewController.swift
//  CocoPodExample
//
//  Created by Bob Pascazio on 9/16/15.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import Parse

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var lastImageData:NSData?
    
    @IBOutlet weak var commentView: UITextView!
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
                self.lastImageData = data_
            }
        }
        
    }
    
    @IBAction func reloadButton(sender: AnyObject) {
    
        self.loadFromLoremPixel()
    
    }

    @IBAction func refreshButton(sender: AnyObject) {
        
        let query = PFQuery( className: "Image" )
        query.getObjectInBackgroundWithId("Klc5c2oMoJ") {
            (someData: PFObject?, error: NSError?) -> Void in
            if error == nil && someData != nil {
                let data = someData!.objectForKey("data") as! NSData
                let image = UIImage(data:data)
                self.imageView.image = image
            } else {
                println("error")
            }
        }
        
    }
    
    
    @IBAction func uploadButton(sender: AnyObject) {
        
        let parseObject = PFObject( className: "Comment" )
        let someData:String! = commentView.text
        parseObject.setObject(someData, forKey: "someField")
        parseObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                println("Object has been saved.")
            } else {
                // There was a problem, check error.description
                println("error = \(error!.description)")
            }
        }
        
        if let lastImageData_ = self.lastImageData {
            let parseObject = PFObject( withoutDataWithClassName: "Image", objectId: "Klc5c2oMoJ" )
            
            parseObject.setObject(lastImageData_, forKey: "data")
            parseObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if (success) {
                    println("Object has been saved.")
                } else {
                    // There was a problem, check error.description
                    println("error = \(error!.description)")
                }
            }
        }
        
    }
    
    func usePhotoAlbum() {
        
        let albumPickerController: UIImagePickerController = UIImagePickerController();

        albumPickerController.delegate = self;
        
        albumPickerController.modalPresentationStyle = UIModalPresentationStyle.FullScreen;
        albumPickerController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        
        presentViewController(albumPickerController, animated: true, completion: nil);
    }
    
    @IBAction func takePhotoButton(sender: AnyObject) {
        
        self.usePhotoAlbum()
        
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject: AnyObject]){
            let mediaType: CFString? = info[UIImagePickerControllerMediaType] as! CFString?;
            if mediaType != nil && mediaType! == kUTTypeImage {
                let metadata: [NSObject: AnyObject]? =
                info[UIImagePickerControllerMediaMetadata] as! [NSObject: AnyObject]?;
                if metadata != nil {
                    //Exchangeable image file format
                    let exif: [NSObject: AnyObject]? =
                    metadata!["{Exif}"] as! [NSObject: AnyObject]?;
                    if exif != nil {
                        let width: Int? = exif!["PixelXDimension"] as! Int?;
                        let height: Int? = exif!["PixelYDimension"] as! Int?;
                        if width != nil && height != nil {
                            println("dimensions in pixels = \(width!) × \(height!)");
                        }
                    }
                }
                
                let editedImage: UIImage? = info[UIImagePickerControllerOriginalImage] as! UIImage?;
                
                self.lastImageData = UIImagePNGRepresentation(editedImage)

                self.imageView.image = editedImage
            
            }
            
            dismissViewControllerAnimated(true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("didCancel");
        dismissViewControllerAnimated(true, completion: nil);
    }
    
}

