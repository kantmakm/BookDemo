import UIKit

extension UIImageView {
    public func load(imageFromURL url: String) {
        self.image = nil
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }}
