//
//  ViewController.swift
//  BabyCrpytApp
//
//  Created by Ahmet Emin Yalçınkaya on 8.10.2023.
//

import UIKit
import CryptoKit



class ViewController: UIViewController {
	
	private var key = SymmetricKey(size: .bits256)
	private var nonce: ChaChaPoly.Nonce?
	private var cipherText: Data?
	
	
	@IBOutlet weak var outputLabel: UILabel!
	
	
	@IBOutlet weak var inputTextField: UITextField!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
		
		
	}

	
	
	@IBAction func encryptButtonTapped(_ sender: Any) {
		guard let plainText = inputTextField.text else { return }
  let result = encryptData(plainText: plainText, key: key)
  cipherText = result?.cipherText
  nonce = result?.nonce
  outputLabel.text = cipherText?.base64EncodedString() ?? "Şifreleme Başarısız"
	}
	
	
	
	@IBAction func decryptButtonTapped(_ sender: Any) {
		if let cipher = cipherText {
			   let decryptedText = decryptData(cipherText: cipher, key: key)
			   outputLabel.text = decryptedText ?? "Şifre Çözme Başarısız"
		   }
		
	}
	

	func encryptData(plainText: String, key: SymmetricKey) -> (cipherText: Data, nonce: ChaChaPoly.Nonce)? {
			guard let data = plainText.data(using: .utf8) else { return nil }
			do {
				let nonce = ChaChaPoly.Nonce()
				let sealedBox = try ChaChaPoly.seal(data, using: key, nonce: nonce)
				return (sealedBox.combined, nonce)
			} catch {
				print("Encryption failed: \(error)")
				return nil
			}
		}
	
	
	func decryptData(cipherText: Data, key: SymmetricKey) -> String? {
		do {
			let sealedBox = try ChaChaPoly.SealedBox(combined: cipherText)
			let decryptedData = try ChaChaPoly.open(sealedBox, using: key)
			return String(data: decryptedData, encoding: .utf8)
		} catch {
			print("Decryption failed: \(error)")
			return nil
		}
	}

}
