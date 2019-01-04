
import UIKit

class BookViewController: UIViewController {
    var book: Book!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = self.book.imageURL {
            self.imageView.load(imageFromURL: url)
        }

        self.titleLabel.text = self.book.title

        if let author = self.book.author {
            self.authorLabel.text = "Written by: \(author)"
        } else {
            self.authorLabel.isHidden = true
        }

    }
}

