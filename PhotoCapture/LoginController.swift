import UIKit

class LoginController: UIViewController {

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
    }

    // MARK: - Private Methods
    private func setupLoginView() {
        view.backgroundColor = .white
        title = "Login"

        // Campo de texto para usuario
        let userTextField = UITextField()
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.placeholder = "Usuario"
        userTextField.borderStyle = .roundedRect
        view.addSubview(userTextField)

        // Campo de texto para contraseña
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Contraseña"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)

        // Botón "Login"
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor.systemBlue
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)

        // Constraints para los campos de texto y el botón
        NSLayoutConstraint.activate([
            userTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            userTextField.widthAnchor.constraint(equalToConstant: 250),
            userTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    // Acción del botón Login
    @objc private func handleLogin() {
        // Aquí puedes agregar la validación de usuario y contraseña
        // Por simplicidad, nos saltamos esa parte y navegamos directamente
        let homeController = HomeController()
        self.present(homeController, animated: true, completion: nil)
    }
}
