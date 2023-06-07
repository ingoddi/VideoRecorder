//
//  SceneDelegate.swift
//  VideoRecorder
//
//  Created by Иван Карплюк on 07.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
                willConnectTo session: UISceneSession,
                options connectionOptions: UIScene.ConnectionOptions) {
         guard let windowScene = (scene as? UIWindowScene) else { return }

         let window = UIWindow(windowScene: windowScene)
        window.rootViewController = VideoCameraViewController()
         self.window = window
         window.makeKeyAndVisible()
     }
}

