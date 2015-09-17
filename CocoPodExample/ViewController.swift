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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
                
                self.imageView.image = editedImage
            
            }
            
            dismissViewControllerAnimated(true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("didCancel");
        dismissViewControllerAnimated(true, completion: nil);
    }
    
}

