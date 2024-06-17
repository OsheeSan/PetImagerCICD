//
//  ViewController.swift
//  CatsAndModules_AntonBabko
//
//  Created by admin on 21.05.2024.
//

import UIKit
import CatsAPIManager
import FirebasePerformance
import FirebaseCrashlytics

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let catsManager = CatsAPIManager()
    var catImages: [UIImage] = []
    var catImageURLs: [String] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CatCell.self, forCellReuseIdentifier: "CatCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "crashlytics_permission") == nil {
                requestCrashlyticsPermission()
        }
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCatImages()
    }
    
    func requestCrashlyticsPermission() {
        let alert = UIAlertController(title: "Crashlytics Permission", message: "Do you agree to share crash data with us?", preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "myAlert"
        alert.addAction(UIAlertAction(title: "Agree", style: .default, handler: { _ in
            UserDefaults.standard.set(true, forKey: "crashlytics_permission")
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        }))
        alert.addAction(UIAlertAction(title: "Disagree", style: .cancel, handler: { _ in
            UserDefaults.standard.set(false, forKey: "crashlytics_permission")
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchCatImages() {
        let trace = Performance.startTrace(name: "fetch_cat_images_trace")
        Task {
            do {
                if let petType = Bundle.main.object(forInfoDictionaryKey: "PetType") as? String {
                    if petType == "CATS" {
                        let catImagesURLs = try await catsManager.fetchCatImagesURLs(limit: 10, petWebsite: "api.thecatapi.com")
                        self.catImageURLs = catImagesURLs
                    } else if petType == "DOGS" {
                        let dogsImagesURLs = try await catsManager.fetchCatImagesURLs(limit: 10, petWebsite: "www.thedogapi.com")
                        self.catImageURLs = dogsImagesURLs
                    }
                }
                await self.loadCatImages()
                trace?.stop()
            } catch {
                print("Failed to fetch cat images: \(error)")
                trace?.stop()
            }
        }
    }
    
    func loadCatImages() async {
        for url in catImageURLs {
            if let image = try? await downloadImage(from: url) {
                self.catImages.append(image)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func downloadImage(from url: String) async throws -> UIImage {
        let trace = Performance.startTrace(name: "download_image_trace")
        let url = URL(string: url)!
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            trace?.stop()
            throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
        }
        trace?.stop()
        return image
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatCell
        cell.catImageView.image = catImages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Crashlytics.crashlytics().log("User tapped on cat image at row \(indexPath.row)")
        let vc = ImageViewController()
        vc.setupImageView(catImages[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 2
    }
    
    
}

class CatCell: UITableViewCell {
    
    let catImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(catImageView)
        
        NSLayoutConstraint.activate([
            catImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            catImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            catImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            catImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
