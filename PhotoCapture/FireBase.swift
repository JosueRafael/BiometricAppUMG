import Foundation

class FirebaseService {

    // Singleton para acceso global
    static let shared = FirebaseService()
    
    // Referencia a Firestore
    private let db = Firestore.firestore()

    // MARK: - Métodos de Autenticación
    
    // Método para iniciar sesión con email y contraseña
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    // Método para registrar un nuevo usuario
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
    
    // Método para cerrar sesión
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Métodos de Firestore
    
    // Guardar datos de usuario en Firestore
    func saveUserData(userID: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userID).setData(data) { error in
            completion(error)
        }
    }

    // Obtener datos de usuario desde Firestore
    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                if let data = document.data() {
        
