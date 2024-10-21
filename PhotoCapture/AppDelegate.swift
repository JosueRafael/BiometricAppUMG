import UIKit
import AWSCore
import AWSCognitoIdentityProvider
import AWSRekognition

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Crear la ventana principal
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Iniciar con la pantalla de login
        let loginController = LoginController()
        let navigation = UINavigationController(rootViewController: loginController)
        
        // Configurar la ventana
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        
        // Configuración de AWS Cognito
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USEast2, // Cambia la región si es necesario
            identityPoolId: "us-east-2:21fa7fa0-059f-459f-8df5-c1890fb92a4b" // Reemplaza con tu Identity Pool ID
        )
        
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        
        // Establece la configuración predeterminada para todos los servicios de AWS
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        return true
    }
    
}
