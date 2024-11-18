import UIKit
import Firebase
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser  != nil {
            // Пользователь уже вошел, показываем экран новостей
            initialViewController = NewsFeedViewController()
        } else {
            // Пользователь не вошел, показываем экран логина
            initialViewController = LoginViewController()
        }
        
        let tabBarController = UITabBarController()
        
        let newsFeedVC = NewsFeedViewController()
        let searchVC = SearchViewController()
        let createPostVC = CreatePostViewController()
        let videoFeedVC = VideoFeedViewController()
        let profileVC = ProfileViewController()
        
        // Настройка вкладок
        newsFeedVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 1)
        createPostVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), tag: 2) // Кнопка добавления
        videoFeedVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "play.rectangle"), tag: 3)
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 4)

        // Добавление контроллеров в таб бар
        tabBarController.viewControllers = [newsFeedVC, searchVC, createPostVC, videoFeedVC, profileVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
    }

    
//        let navigationController = UINavigationController(rootViewController: initialViewController)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
    }
    
    // Другие методы SceneDelegate...

