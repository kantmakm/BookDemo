

import Foundation

struct Book: Decodable {
    var title: String!
    var imageURL: String?
    var author: String?

    private enum CodingKeys: String, CodingKey {
        case title
        case author
        case imageURL
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try values.decode(String.self, forKey: .title)
        self.imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        self.author = try values.decodeIfPresent(String.self, forKey: .author)

        //  I'd rather do this than allow HTTP, sue me
        if let url = self.imageURL {
            self.imageURL = url.replacingOccurrences(of: "http", with: "https")
        }
    }
}


class BookService {
    static let shared = BookService()

    fileprivate init() {}

    func getBooks(completion: @escaping ([Book]?) -> ()) {
        let url = URL(string: "https://de-coding-test.s3.amazonaws.com/books.json")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            if error != nil || data == nil {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let books = try decoder.decode([Book].self, from: data!)
                completion(books)
            } catch {
                completion(nil)
            }
        })

        task.resume()
    }
}
