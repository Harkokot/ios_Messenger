//
//  UIImage_extension.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import Foundation
import UIKit

extension UIImage{
    static func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }
    
    static func convertImageToBase64String (img: UIImage, imageExtension: String) -> String {
        switch imageExtension{
        case "png":
            guard let imgBase = img.pngData()?.base64EncodedString() else {print("error"); return ""}
            return imgBase
        case "jpg", "jpeg":
            guard let imgBase = img.jpegData(compressionQuality: 1)?.base64EncodedString() else {print("error"); return ""}
            return imgBase
        default:
            return ""
        }
    }
    
    static func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
}
