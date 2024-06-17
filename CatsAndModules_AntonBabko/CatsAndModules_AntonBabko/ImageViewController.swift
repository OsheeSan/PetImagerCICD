//
//  ImageViewController.swift
//  CatsAndModules_AntonBabko
//
//  Created by admin on 27.05.2024.
//

import UIKit

class ImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    func setupImageView(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        switch Int.random(in: 1...3) {
        case 1:
            let numbers = [0]
            let _ = numbers[1]
        case 2:
            let str: String? = nil
            let _ = str!
        case 3:
            let zero = [0]
            let _ = 1 / zero[0]
        default:
            break
        }
    }
    
}
