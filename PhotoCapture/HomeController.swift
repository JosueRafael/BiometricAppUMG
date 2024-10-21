import UIKit
import AWSRekognition

class HomeController: UIViewController, CustomCameraControllerDelegate {
    
    // MARK: - Variables
    private var photoCount = 0 // Variable para rastrear cuántas fotos se han tomado
    private let firstContainer = UIImageView()
    private let secondContainer = UIImageView()
    
    // Botón para analizar las imágenes
    lazy private var analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Analyze", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(analyzeImages), for: .touchUpInside)
        button.isEnabled = false // Desactivado hasta que se tomen las dos fotos
        return button
    }()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        view.backgroundColor = .white
        title = "Capture Photo"
        
        // Botón "Take Photo"
        let takePhotoButton = UIButton(type: .system)
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.setTitle("Take Photo", for: .normal)
        takePhotoButton.setTitleColor(.white, for: .normal)
        takePhotoButton.backgroundColor = UIColor.systemBlue // Cambiado a azul cielo
        takePhotoButton.layer.cornerRadius = 5
        takePhotoButton.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        view.addSubview(takePhotoButton)
        
        // Primer contenedor (usar UIImageView para mostrar la imagen)
        firstContainer.translatesAutoresizingMaskIntoConstraints = false
        firstContainer.backgroundColor = .lightGray
        firstContainer.contentMode = .scaleAspectFill
        firstContainer.clipsToBounds = true
        view.addSubview(firstContainer)
        
        // Segundo contenedor (usar UIImageView para mostrar la imagen)
        secondContainer.translatesAutoresizingMaskIntoConstraints = false
        secondContainer.backgroundColor = .lightGray
        secondContainer.contentMode = .scaleAspectFill
        secondContainer.clipsToBounds = true
        view.addSubview(secondContainer)
        
        // Agregar el botón "Analyze"
        analyzeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(analyzeButton)
        
        // Constraints del botón "Take Photo"
        takePhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takePhotoButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        takePhotoButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // Constraints del primer contenedor
        firstContainer.topAnchor.constraint(equalTo: takePhotoButton.bottomAnchor, constant: 20).isActive = true
        firstContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstContainer.widthAnchor.constraint(equalToConstant: 100).isActive = true
        firstContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Constraints del segundo contenedor
        secondContainer.topAnchor.constraint(equalTo: firstContainer.bottomAnchor, constant: 20).isActive = true
        secondContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        secondContainer.widthAnchor.constraint(equalToConstant: 100).isActive = true
        secondContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Constraints del botón "Analyze"
        analyzeButton.topAnchor.constraint(equalTo: secondContainer.bottomAnchor, constant: 20).isActive = true
        analyzeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        analyzeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        analyzeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc private func handleTakePhoto() {
        let controller = CustomCameraController()
        controller.delegate = self // Establecer el delegado
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - CustomCameraControllerDelegate
    func didCapturePhoto(_ image: UIImage) {
        if photoCount == 0 {
            // Guardar la primera imagen en el primer contenedor
            firstContainer.image = image
        } else if photoCount == 1 {
            // Guardar la segunda imagen en el segundo contenedor
            secondContainer.image = image
        }
        
        photoCount += 1
        
        // Verificar si ya se han tomado las dos fotos
        if photoCount == 2 {
            // Habilitar el botón de analizar
            analyzeButton.isEnabled = true
            print("Se han tomado las dos fotos.")
        }
    }
    
    @objc private func analyzeImages() {
        guard let firstImage = firstContainer.image,
              let secondImage = secondContainer.image else {
            print("Both images must be set")
            return
        }
        
        compareFaces(firstImage: firstImage, secondImage: secondImage)
    }
    
    private func compareFaces(firstImage: UIImage, secondImage: UIImage) {
        let rekognition = AWSRekognition.default()
        
        // Convert UIImage to Data
        guard let firstImageData = firstImage.jpegData(compressionQuality: 0.8),
              let secondImageData = secondImage.jpegData(compressionQuality: 0.8) else { return }
        
        let sourceImage = AWSRekognitionImage()
        sourceImage?.bytes = firstImageData
        
        let targetImage = AWSRekognitionImage()
        targetImage?.bytes = secondImageData
        
        let request = AWSRekognitionCompareFacesRequest()
        request?.sourceImage = sourceImage
        request?.targetImage = targetImage
        request?.similarityThreshold = 90.0 // Umbral de similitud
        
        rekognition.compareFaces(request!) { (result, error) in
            if let error = error {
                print("Error comparing faces: \(error)")
                return
            }
            
            guard let faceMatches = result?.faceMatches else {
                print("No faces matched")
                return
            }
            
            if !faceMatches.isEmpty {
                print("Faces match!")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Result", message: "The faces match, authentication APPROVED!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Continue to Login", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                print("Faces do not match")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Result", message: "The faces do not match, authentication FAILED!.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
