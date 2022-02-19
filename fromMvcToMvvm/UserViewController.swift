//
//  ViewController.swift
//  fromMvcToMvvm
//
//  Created by максим  кондратьев  on 19.02.2022.
//

import UIKit

class UserViewModel {
    
}

class UserViewController: UIViewController {

    // MARK:  Constants
    
    private let viewModel: UserViewModel
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    // MARK:  Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
      }()
      
      private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
      }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
      override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchUsers()
      }
    
    // MARK:  Funcs
      private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
          imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          imageView.heightAnchor.constraint(equalToConstant: 100),
          imageView.widthAnchor.constraint(equalToConstant: 100),
          imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
          
          emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          emailLabel.heightAnchor.constraint(equalToConstant: 56),
          emailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4)
        ])
      }
    
    
      private func fetchUsers() {
        APIManager.shared.fetchUser { result in
          switch result {
          case .success(let user):
            guard let url = URL(string: user.avatar) else {return}
            let imageData = try! NSData(contentsOf: url) as Data
            self.imageView.image = UIImage(data: imageData)
            self.emailLabel.text = user.email
          case .failure:
           guard let errorImageUrl = URL(string: "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png")
           else {return}
            let imageData = try! NSData(contentsOf: errorImageUrl) as Data
            self.imageView.image = UIImage(data: imageData)
            self.emailLabel.text = "No user found"
          }
        }
      }
    }


protocol UserService  {
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void)
}

class APIManager : UserService {
      static let shared = APIManager()
      private init() {}
      
      func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        
        let url = URL(string: "https://reqres.in/api/users/2")!
        
        URLSession.shared.dataTask(with: url) { data, res, error in
          guard let data = data else { return }
          DispatchQueue.main.async {
            if let user = try? JSONDecoder().decode(UserResponse.self, from: data).data {
              completion(.success(user))
            } else {
              completion(.failure(NSError()))
            }
          }
        }.resume()
      }
    }

    struct UserResponse: Decodable {
      let data: User
    }

    struct User: Decodable {
      let id: Int
      let email: String
      let avatar: String
    }

