//
//  PlataformaViewController.swift
//  MyGames
//
//  Created by Frederyk Antunnes on 27/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit
import Photos

class PlataformaViewController: UIViewController {

    @IBOutlet weak var tvNome: UITextField!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var ivCapa: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    var console: Console?
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareDataLayout()
    }
    
    func prepareDataLayout() {
        if console != nil {
            title = "Editar jogo"
            btnSave.setTitle("ALTERAR", for: .normal)
            tvNome.text = console?.name
        
            ivCapa.image = console?.capa as? UIImage
            if console?.capa != nil {
                btnAddImage.setTitle(nil, for: .normal)
            }
        }
        
    }
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func addPlataforma(_ sender: UIButton) {
        // acao salvar novo ou editar existente
        print("addEditGame")
        
        if console == nil {
            // context está sendo obtida pela extension 'ViewController+CoreData'
            console = Console(context: context)
        }
        console?.name = tvNome.text
        
        
    
        console?.capa = ivCapa.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
    }

    
    
    @IBAction func addEditImage(_ sender: UIButton) {
        // para adicionar uma imagem da biblioteca
        print("AddEditCover")
        
        
        // para adicionar uma imagem da biblioteca
    
        
        let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        
        if photos == .denied {
            // TODO considetar exibir um dialogo pedindo para o usuario ir em configuracoes
            print(".denied")
            
        } else if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    // TODO considetar exibir um dialogo pedindo para o usuario ir em configuracoes
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
}


extension PlataformaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.ivCapa.image = pickedImage
                self.ivCapa.setNeedsDisplay() // fixed here
                self.btnAddImage.setTitle(nil, for: .normal)
                self.btnAddImage.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

