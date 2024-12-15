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
    

    
    func updateTextView(text: String) {
        DispatchQueue.main.async {
            self.outputTextView.text = text
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
        
        func updateTextView(text: String) {
            DispatchQueue.main.async {
                self.outputTextView.text = text
            }
        }
    }
    
    @IBAction func fetchImageButtonTapped(_ sender: UIButton) {
            fetchImagesFromUnsplash(query: "kittens")
        }
    
    @IBOutlet weak var imageView: UIImageView!
        
        func fetchImagesFromUnsplash(query: String) {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "https://api.unsplash.com/search/photos?query=\(encodedQuery)&client_id=A-jVme2KHnAzs-LNqHGYa4p63b1phEmqkS8EGbn7uEw"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL for Unsplash API")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching Unsplash images: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received from Unsplash")
                    return
                }
                
                do {
                    let unsplashResponse = try JSONDecoder().decode(UnsplashResponse.self, from: data)
                    
                    if let firstImageURL = unsplashResponse.results.first?.urls.regular {
                        self.loadImage(from: firstImageURL)
                    } else {
                        print("No images found for query: \(query)")
                    }
                } catch {
                    print("Error decoding Unsplash API response: \(error.localizedDescription)")
                }
            }.resume()
        }
        
        func loadImage(from urlString: String) {
            guard let url = URL(string: urlString) else {
                print("Invalid image URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Failed to load image data")
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }.resume()
        }
    }
