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
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // Другие методы SceneDelegate...
}
