//
//  ImageColors.swift
//  spotifyclone
//
//  Created by Osama Qarem on 2/16/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
import UIKit
import UIImageColors

@objc(ImageColors)
class ImageColors : NSObject{
  enum ERRORS {
    static let ERROR_1 = "Invalid URL";
    static let ERROR_2 = "Could not download image.";
    static let ERROR_3 = "Could not parse image.";
  }
  
  private func toHexString(color: UIColor) -> String {
    let comp = color.cgColor.components;
    
    let r:CGFloat = comp![0]
    let g:CGFloat = comp![1]
    let b:CGFloat = comp![2]
    
    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    
    return String(format:"#%06X", rgb)
  }
  
  @objc
  func getImageColorsFromURL(_ url : String, config: NSDictionary, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void{
    
    let defColor = config.value(forKey: "defaultColor") as? String
    
    if let parsedURL = URL(string: url) {
      if let imageData = try? Data(contentsOf: parsedURL){
        if let uiImage = UIImage(data: imageData) {
          uiImage.getColors(quality: UIImageColorsQuality.low){ colors in
            
            var resultDict : Dictionary<String, String> = [:]
            
            if let background = colors?.background{
              resultDict["background"] = self.toHexString(color: background)
            }else{
              resultDict["background"] = defColor
            }
            
            
            if let primary = colors?.primary{
              resultDict["primary"] = self.toHexString(color: primary)
            }else{
              resultDict["primary"] = defColor
            }
            
            
            if let secondary = colors?.secondary{
              resultDict["secondary"] = self.toHexString(color: secondary)
            }else{
              resultDict["secondary"] = defColor
            }
            
            if let detail = colors?.detail{
              resultDict["detail"] = self.toHexString(color: detail)
            }else{
              resultDict["detail"] = defColor
            }
            
            resolve(resultDict)
          }
        }else{
          let error = NSError.init(domain: ImageColors.ERRORS.ERROR_3, code: -3)
          reject("Error", ImageColors.ERRORS.ERROR_3, error)
        }
      }else{
        let error = NSError.init(domain: ImageColors.ERRORS.ERROR_2, code: -2)
        reject("Error", ImageColors.ERRORS.ERROR_2, error)
      }
    }else{
      let error = NSError.init(domain: ImageColors.ERRORS.ERROR_1, code: -1)
      reject("Error", ImageColors.ERRORS.ERROR_1, error)
    }
  }
}