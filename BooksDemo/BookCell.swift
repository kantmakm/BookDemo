

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    func configure(withBook book: Book) {
        self.bookTitleLabel.text = book.title

        if let author = book.author {
            self.authorLabel.text = author
            self.authorLabel.isHidden = true
        } else {
            self.authorLabel.isHidden = false
        }

        if let url = book.imageURL {
            self.coverImageView.load(imageFromURL: url)
        }
    }
}
