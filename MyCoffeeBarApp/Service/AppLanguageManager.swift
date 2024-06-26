//
//  AppLanguageManager.swift
//  MyCoffeeBarApp
//
//  Created by Alisher Sultanov on 25/4/24.
//

import Foundation

enum LanguageType: String {
    
    case ru = "ru"
    case en = "en"
}

class AppLanguageManager {
    
    static let shared = AppLanguageManager()
    private var currentLanguage: LanguageType?
    private var currentBundle: Bundle = Bundle.main
    var bundle: Bundle {
        return currentBundle
    }
    
    func setAppLanguage(language: LanguageType) {
        setCurrentLanguage(language: language)
        setCurrentBandlePath(languageCode: language.rawValue)
    }
    
    private func setCurrentLanguage(language: LanguageType) {
        currentLanguage = language
        UserDefaults.standard.set(
            language.rawValue,
            forKey: "selectedLanguage")
  }
    
    private func setCurrentBandlePath(languageCode: String) {
        guard let bundle = Bundle.main.path(
            forResource: languageCode,
            ofType: "lproj"),
            let langBundle = Bundle(path: bundle)
        else {
            currentBundle = Bundle.main
            return
        }
        currentBundle = langBundle
    }
}

extension String {
    func localized() -> String {
        let bundle = AppLanguageManager.shared.bundle
        return NSLocalizedString(
            self, 
            tableName: "Localizable",
            bundle: bundle,
            value: "", comment: "")
    }
}
