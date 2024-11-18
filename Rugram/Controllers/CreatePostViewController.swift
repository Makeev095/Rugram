import UIKit
import Firebase

class CreatePostViewController: UIViewController {

    let contentTextField = UITextField()
    let createPostButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        // Настройка элементов интерфейса
        contentTextField.placeholder = "What's on your mind?"
        contentTextField.borderStyle = .roundedRect
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        createPostButton.setTitle("Create Post", for: .normal)
        createPostButton.backgroundColor = .blue
        createPostButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)
        createPostButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentTextField)
        view.addSubview(createPostButton)
        
        // Установка ограничений
        NSLayoutConstraint.activate([
            contentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentTextField.widthAnchor.constraint(equalToConstant: 250),
            
            createPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createPostButton.topAnchor.constraint(equalTo: contentTextField.bottomAnchor, constant: 20),
            createPostButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

    
    @objc func createPost() {
        print("Create Post button tapped") // Для отладки
        guard let content = contentTextField.text, !content.isEmpty else {
            print("Post content cannot be empty.")
            return
        }
        
        let db = Firestore.firestore()
        let postData: [String: Any] = [
            "author": "CurrentUser ", // Замените на имя текущего пользователя
            "content": content,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("posts").addDocument(data: postData) { error in
            if let error = error {
                print("Error creating post: \(error.localizedDescription)")
                return
            }
            print("Post created successfully.")
            
            NotificationCenter.default.post(name: NSNotification.Name("PostCreated"), object: nil)

            
            // Возврат на экран ленты
            self.navigationController?.popViewController(animated: true)
        }
    }

}
