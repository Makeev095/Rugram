import UIKit
import Firebase
import FirebaseStorage

class CreatePostViewController: UIViewController {

    let contentTextField = UITextField()
    let createPostButton = UIButton()
    let selectMediaButton = UIButton()
    let imageView = UIImageView()
    
    var selectedImage: UIImage?

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
        
        selectMediaButton.setTitle("Select Media", for: .normal)
        selectMediaButton.backgroundColor = .green
        selectMediaButton.addTarget(self, action: #selector(selectMedia), for: .touchUpInside)
        selectMediaButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // Скрыто до выбора изображения
        
        view.addSubview(contentTextField)
        view.addSubview(createPostButton)
        view.addSubview(selectMediaButton)
        view.addSubview(imageView)
        
        // Установка ограничений
        NSLayoutConstraint.activate([
            contentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            contentTextField.widthAnchor.constraint(equalToConstant: 250),
            
            selectMediaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectMediaButton.topAnchor.constraint(equalTo: contentTextField.bottomAnchor, constant: 20),
            selectMediaButton.widthAnchor.constraint(equalToConstant: 250),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: selectMediaButton.bottomAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            createPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createPostButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            createPostButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

    @objc func selectMedia() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"] // Позволяет выбирать только изображения
        present(imagePicker, animated: true, completion: nil)
    }

    @objc func createPost() {
        guard let content = contentTextField.text, !content.isEmpty else {
            print("Post content cannot be empty.")
            return
        }
        
        let db = Firestore.firestore()
        var postData: [String: Any] = [
            "author": "CurrentUser ", // Замените на имя текущего пользователя
            "content": content,
            "timestamp": Timestamp(date: Date())
        ]
        
        // Если изображение выбрано, загрузите его в Firebase Storage
        if let image = selectedImage {
            uploadImage(image: image) { imageUrl in
                postData["imageUrl"] = imageUrl
                self.savePostToFirestore(postData: postData)
            }
        } else {
            // Если изображения нет, просто сохраняем пост
            savePostToFirestore(postData: postData)
        }
    }

    func savePostToFirestore(postData: [String: Any]) {
        let db = Firestore.firestore()
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

    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("posts/\(UUID().uuidString).jpg")

        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                // Получение ссылки на загруженное изображение
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                        return
                    }
                    completion(downloadURL.absoluteString)
                }
            }
        }
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
            imageView.isHidden = false // Показываем изображение
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
