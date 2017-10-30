//
//  ViewController.swift
//  CoreImageFun

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var context: CIContext!
    var filter: CIFilter!
    var beginImage: CIImage!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var amountSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 1
        let fileURL = Bundle.main.url(forResource: "image", withExtension: "png")
        
        beginImage = CIImage(contentsOf: fileURL!)
        
        filter = CIFilter(name: "CISepiaTone")
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        
        let outputImage = filter.outputImage
        
        context = CIContext(options:nil)
        let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent)
        let newImage = UIImage(cgImage: cgimg!)
        self.ImageView.image = newImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func amountSliderValueChanged(_ sender: UISlider) {
        let sliderValue = sender.value
        
        filter.setValue(sliderValue, forKey: kCIInputIntensityKey)
        let outputImage = filter.outputImage
        
        let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent)
        
        let newImage = UIImage(cgImage: cgimg!)
        self.ImageView.image = newImage
    }
    
    @IBAction func loadPhoto(_ sender: UIButton) {
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.present(pickerC, animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!) {
     self.dismiss(animated: true, completion: nil)
     
     let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
     
     beginImage = CIImage(image: gotImage)
     filter.setValue(beginImage, forKey: kCIInputImageKey)
     self.amountSliderValueChanged(amountSlider)
     }
    
    @IBAction func savePhoto(_ sender: UIButton) {
        // 1
        let imageToSave = filter.outputImage
        
        // 2
        let softwareContext = CIContext(options:[kCIContextUseSoftwareRenderer: true])
        
        // 3
        let cgimg = softwareContext.createCGImage(imageToSave!, from:imageToSave!.extent)
        
        // 4
        let library = ALAssetsLibrary()
        library.writeImage(toSavedPhotosAlbum: cgimg,
                                             metadata:imageToSave!.properties,
                                             completionBlock:nil)

    }
}
