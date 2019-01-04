

import UIKit

class BooksTableViewController: UITableViewController {
    var books: [Book] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let spinner = UIActivityIndicatorView()
        spinner.color = .blue
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true

        //  I'm the worst
        guard let navController = self.navigationController else {
            return
        }

        navController.view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: navController.view.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: navController.view.centerXAnchor)
        ])

        spinner.startAnimating()
        navController.view.bringSubview(toFront: spinner)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0

        BookService.shared.getBooks { [weak self] (bookData) in
            DispatchQueue.main.async {
                guard let books = bookData else {
                    return
                }

                spinner.stopAnimating()
                self?.books = books
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let book = self.books[indexPath.row]

        self.performSegue(withIdentifier: "showBook", sender: book)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //  this is enough to check for correct seque and prevents magic strings
        if let book = sender as? Book, let bookVC = segue.destination as? BookViewController {
            bookVC.book = book
        } else {
            print("bad")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! BookCell
        let book = self.books[indexPath.row]

        cell.configure(withBook: book)
        
        return cell
    }
}
