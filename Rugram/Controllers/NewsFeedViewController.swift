//import UIKit
//import FirebaseFirestore
//import FirebaseAuth
//
//class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    var posts: [Post] = [] // Массив для хранения загруженных постов
//    let tableView = UITableView()
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchPosts()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        setupTableView()
//        
//        // Добавьте кнопку для создания поста
//        let createPostButton = UIBarButtonItem(title: "Create Post", style: .plain, target: self, action: #selector(presentCreatePostVC))
//        navigationItem.rightBarButtonItem = createPostButton
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(fetchPosts), name: NSNotification.Name("PostCreated"), object: nil)
//    }
//    
//    @objc func presentCreatePostVC() {
//        let createPostVC = CreatePostViewController()
//        navigationController?.pushViewController(createPostVC, animated: true)
//    }
//    
//    func setupTableView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
//        
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//    }
//    
//    @objc func fetchPosts() {
//        let db = Firestore.firestore()
//        db.collection("posts").order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error fetching posts: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                print("No posts found")
//                return
//            }
//            
//            self.posts = documents.compactMap { doc -> Post? in
//                let data = doc.data()
//                guard let author = data["author"] as? String,
//                      let content = data["content"] as? String,
//                      let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
//                    return nil
//                }
//                return Post(id: doc.documentID, author: author, content: content, timestamp: timestamp, imageUrl: data["imageUrl"] as? String)
//            }
//            
//            self.tableView.reloadData()
//        }
//    }
//    
//    // MARK: - UITableViewDataSource
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
//        let post = posts[indexPath.row]
//        cell.authorLabel.text = post.author
//        cell.contentLabel.text = post.content
//        
//        // Загрузка изображения из URL
//        if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
//            // Загрузка изображения асинхронно
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        cell.postImageView.image = image
//                    }
//                }
//            }.resume()
//        }
//        
//        return cell
//    }
//}
//


import UIKit
import FirebaseFirestore
import FirebaseAuth

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts: [Post] = [] // Массив для хранения загруженных постов
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        setupTableView()
//        
//        // Добавьте кнопку для создания поста
//        let createPostButton = UIBarButtonItem(title: "Create Post", style: .plain, target: self, action: #selector(presentCreatePostVC))
//        navigationItem.rightBarButtonItem = createPostButton
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(fetchPosts), name: NSNotification.Name("PostCreated"), object: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        
        // Добавьте кнопку для создания поста
        let createPostButton = UIBarButtonItem(title: "Создать пост", style: .plain, target: self, action: #selector(presentCreatePostVC))
        navigationItem.rightBarButtonItem = createPostButton
        
        // Добавьте кнопку настроек
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(presentSettingsVC))
        navigationItem.leftBarButtonItem = settingsButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPosts), name: NSNotification.Name("PostCreated"), object: nil)
    }

    
    @objc func presentCreatePostVC() {
        let createPostVC = CreatePostViewController()
        navigationController?.pushViewController(createPostVC, animated: true)
    }
    
    @objc func presentSettingsVC() {
        let SettingsVC = SettingsViewController()
        navigationController?.pushViewController(SettingsVC, animated: true)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none // Убираем разделители
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("posts").order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No posts found")
                return
            }
            
            self.posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                guard let author = data["author"] as? String,
                      let content = data["content"] as? String,
                      let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
                    return nil
                }
                return Post(id: doc.documentID, author: author, content: content, timestamp: timestamp, imageUrl: data["imageUrl"] as? String)
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.authorLabel.text = post.author
        cell.contentLabel.text = post.content
        
        // Загрузка изображения из URL
        if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
            // Загрузка изображения асинхронно
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.postImageView.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
}
