//
//  ViewController.swift
//  RandomFactsAPI
//
//  Created by Ibrahim Syed on 2024-11-25.
//

import UIKit

class ViewController: UIViewController {

 @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData() // This is to fetch an inital fact on launch
    }

    @IBAction func fetchNewFact(_ sender: UIButton) {
        fetchData() 
    }
    
    struct Fact: Codable {
        let text: String
        let id: String
        let source: String
        let sourceUrl: String
        let language: String
        let permalink: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case text
            case source
            case sourceUrl = "source_url"
            case language
            case permalink
        }
        
    }

    func fetchData() {
        let apiUrlString = "https://uselessfacts.jsph.pl/random.json?language=en"
        guard let url = URL(string: apiUrlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.updateTextView(text: "Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.updateTextView(text: "Invalid response from server")
                return
            }

            if let data = data {
                do {
                 
                    let fact = try JSONDecoder().decode(Fact.self, from: data)
                    
                    print("Fetched Fact: \(fact.text)")
                    print("Fact ID: \(fact.id)")
                    print("Source: \(fact.source)")
                    print("Source URL: \(fact.sourceUrl)")
                    print("Language: \(fact.language)")
                    print("Permalink: \(fact.permalink)")
                    
                    
                    self.updateTextView(text: """
                Fact: \(fact.text)
                Source: \(fact.source)
                Source URL: \(fact.sourceUrl)
                """)
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    self.updateTextView(text: "Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }

    func updateTextView(text: String) {
        DispatchQueue.main.async {
            self.outputTextView.text = text
        }
    }
}
