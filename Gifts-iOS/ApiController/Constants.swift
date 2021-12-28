import UIKit

class Constants {
    static let kAppDelegate          = UIApplication.shared.delegate as! AppDelegate
    static let kScreenWidth          = UIScreen.main.bounds.width
    static let kScreenHeight         = UIScreen.main.bounds.height
    static let kAppDisplayName       = UIApplication.appName
    static let kUserDefaults         = UserDefaults.standard
    static var kTest                 = 1
    static var optionColor           = "#EEFEEF7"
    static var UDID                  = UIDevice.current.identifierForVendor?.uuidString ?? ""
    static var KBundleID             = Bundle.main.bundleIdentifier
    static var kVersionNo            = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

// MARK: - Failed Errors
public struct ConstantsErrors {
    static let kNoInternetConnection = NSError(domain: Constants.kAppDisplayName, code: NSURLErrorNotConnectedToInternet, userInfo: [NSLocalizedDescriptionKey: ConstantsMessages.kConnectionFailed])
    static let kSomethingWrong = NSError(domain: Constants.kAppDisplayName, code: 1000002, userInfo: [NSLocalizedDescriptionKey : "Something went wrong, please try again soon!"])
}

public struct ConstantsMessages {
    static let kConnectionFailed = NSLocalizedString("There seems to be a problem with your Internet connection. Please try again after a while.", comment :"NetworkError")
    static let kNetworkFailure = NSLocalizedString("seems to be a network error, please try after a while.", comment :"NetworkError")
    static let kSomethingWrong = NSLocalizedString("Something went wrong. Please try again soon!", comment :"NetworkError")
}

public func convertDateFormater(_ date: String, _ formatFrom: String = "", _ format: String = "dd-MM-yyyy") -> String {
    let dateFormatter = DateFormatter()
    if formatFrom == "" {
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
    } else {
        dateFormatter.dateFormat = formatFrom
    }
    dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0].hasPrefix("fr") ? "fr_FR" : "en_US")
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = format
    return  dateFormatter.string(from: date!)
}

public func getLanguage() -> String {
    switch Locale.preferredLanguages[0] {
    case "ru":
        return "ru"
    default:
        return "en"
    }
}
