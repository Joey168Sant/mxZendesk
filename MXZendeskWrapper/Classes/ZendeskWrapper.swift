

import ZendeskCoreSDK
import ChatProvidersSDK
import AnswerBotProvidersSDK
import SupportProvidersSDK
import SupportSDK

import MessagingSDK
import MessagingAPI
import ChatSDK
import ChatProvidersSDK
import AnswerBotSDK
import CommonUISDK
import SDKConfigurations
import MXAuthenticationManager
import MXSecureStorage


public class ZendeskWrapper {
    static private var globalConfig: [String: Any] = [:]
    static private var santanderConfig: [String: Any] = [:]
    public static var shared: ZendeskWrapper = {
        let instance = ZendeskWrapper()
        return instance
    }()
    private var internalCallback: ((String) -> Void)!
    private var viewController: UIViewController?
    private var buttonText : String?
    fileprivate let appearanceKey = "zendesk_open_value"
    private init() {}
    
    
    public func initZendesk() throws {
        do {
            let config = try ConfigProvider().getConfig()
            if config.contains(where: { $0.key == Configuration.ZENDESK_CONFIG }) {
                ZendeskWrapper.santanderConfig = config[Configuration.ZENDESK_CONFIG] as! [String: Any]
                let appId = ZendeskWrapper.santanderConfig[Configuration.APP_ID] as! String
                let clientId = ZendeskWrapper.santanderConfig[Configuration.CLIENT_ID] as! String
                let zendeskUrl = ZendeskWrapper.santanderConfig[Configuration.ZENDESK_URL] as! String
                buttonText = ZendeskWrapper.santanderConfig[Configuration.BUTTON_CLOSE] as? String
                print("appIId",appId)
                print("clientt",clientId)
                print("url",zendeskUrl)
                Zendesk.initialize(appId: appId,
                    clientId: clientId,
                    zendeskUrl: zendeskUrl)
                Support.initialize(withZendesk: Zendesk.instance)
                AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
                Chat.initialize(accountKey: "") //solicitar key de chat
                ZendeskWrapper.setKeyZendesk(saveUse: "false")
            } else {
                print("error")
            }
        } catch {
            print("error")
        }
    }

    
    public func setUserZendesk(){
        let anonymous = Identity.createAnonymous(name: "", email: "")
        Zendesk.instance?.setIdentity(anonymous)
    }
    
    
    public func presentModally(viewControllerShow: UIViewController) throws {
        let viewController = try ZendeskWrapper.shared.buildUI(viewControllerShow: viewControllerShow)
        self.viewController = viewControllerShow
        let button = UIBarButtonItem(title: buttonText ?? "Cerrar", style: .plain, target: self, action: #selector(dismissZ))
        viewController.navigationItem.leftBarButtonItem = button
        
        let chatController = UINavigationController(rootViewController: viewController)
        ZendeskWrapper.setKeyZendesk(saveUse: "true")
        viewControllerShow.present(chatController, animated: true)
    }
    
    @objc public func dismissZ() {
        ZendeskWrapper.setKeyZendesk(saveUse: "false")
        self.viewController?.dismiss(animated: true)
    }
    
    
    public func buildUI(viewControllerShow: UIViewController) throws -> UIViewController {
        setUserZendesk()
        do {
            let messagingConfiguration = MessagingConfiguration()
            let answerBotEngine = try AnswerBotEngine.engine()
            let supportEngine = try SupportEngine.engine()
            let chatEngine = try ChatEngine.engine()
            let viewController = try Messaging.instance.buildUI(engines: [answerBotEngine, chatEngine, supportEngine],
                                                    configs: [messagingConfiguration])
            
            return viewController
        } catch {
            print("errorZendesk ", error)
            alertError(viewControllerShow: viewControllerShow, text: "\(error)")
            // do something with error
        }
        ZendeskWrapper.setKeyZendesk(saveUse: "false")
        return try Messaging.instance.buildUI(engines: [],
                                              configs: [])
    }
    
    public func alertError(viewControllerShow: UIViewController, text: String){
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
            switch action.style{
                case .default:
                ZendeskWrapper.setKeyZendesk(saveUse: "false")
            case .cancel:
                break
            case .destructive:
                break
            }
        }))
        viewControllerShow.present(alert, animated: true, completion: nil)
    }
    
    
    public static func setKeyZendesk(
        saveUse: String
    ) {
        do {
            try SecureStorageHelper.setValue(key: Configuration.ZENDESK_OPEN, value: saveUse)
        } catch {
            debugPrint("\(String(describing: self)).\(#function): \(error)")
        }
    }
    
    public static var getKeyZendesk: Bool {
        let value = (
            try? SecureStorageHelper
                .getValue(key: Configuration.ZENDESK_OPEN)
        ) as? String ?? ""
        return value.isEmpty ? true : (value as NSString).boolValue
    }

}
    

extension ZendeskWrapper {
    public func resetIdentity() {
        Chat.instance?.resetIdentity {
            
            // Identity cleared, continue to log out
        }
    }
}



