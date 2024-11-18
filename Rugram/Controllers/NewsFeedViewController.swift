import UIKit
import FirebaseFirestore
import FirebaseAuth

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts: [Post] = [] // Массив для хранения загруженных постов
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Обновите вашу ленту здесь
        fetchPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        fetchPosts()
        
        // Добавьте кнопку для создания поста
        let createPostButton = UIBarButtonItem(title: "Create Post", style: .plain, target: self, action: #selector(presentCreatePostVC))
        navigationItem.rightBarButtonItem = createPostButton
        
        // Подписка на уведомление о создании поста
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPosts), name: NSNotification.Name("PostCreated"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func presentCreatePostVC() {
        let createPostVC = CreatePostViewController()
        navigationController?.pushViewController(createPostVC, animated: true)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Настройка кнопки выхода в навигационном баре
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        logoutButton.tintColor = .red // Установите цвет кнопки
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    
    @objc func logoutButtonTapped() {
        do {
            try Auth.auth().signOut() // Выход из аккаунта
            // После выхода можно вернуться на экран логина
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @objc func fetchPosts() {
        let db = Firestore.firestore() // Получение ссылки на Firestore
        db.collection("posts").order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No posts found")
                return
            }
            
            // Преобразование документов в массив постов
            self.posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                guard let author = data["author"] as? String,
                      let content = data["content"] as? String,
                      let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
                    return nil
                }
                return Post(id: doc.documentID, author: author, content: content, timestamp: timestamp, imageUrl: data["imageUrl"] as? String)
            }
            
            self.tableView.reloadData() // Обновление таблицы с новыми данными
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.content // Отображение контента поста
        return cell
    }
}
