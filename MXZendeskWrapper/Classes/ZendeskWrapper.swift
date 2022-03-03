

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




public class ZendeskWrapper {
    static private var globalConfig: [String: Any] = [:]
    static private var santanderConfig: [String: Any] = [:]
    public static var shared: ZendeskWrapper = {
        let instance = ZendeskWrapper()
        return instance
    }()
    private var internalCallback: ((String) -> Void)!
    private var viewController: UIViewController?
    
    private init() {}
    
    
    public func initZendesk() throws {
        do {
            let config = try ConfigProvider().getConfig()
            if config.contains(where: { $0.key == Configuration.ZENDESK_CONFIG }) {
                ZendeskWrapper.santanderConfig = config[Configuration.ZENDESK_CONFIG] as! [String: Any]
                let appId = ZendeskWrapper.santanderConfig[Configuration.APP_ID] as! String
                let clientId = ZendeskWrapper.santanderConfig[Configuration.CLIENT_ID] as! String
                let zendeskUrl = ZendeskWrapper.santanderConfig[Configuration.ZENDESK_URL] as! String
                print("appIId",appId)
                print("clientt",clientId)
                print("url",zendeskUrl)
                Zendesk.initialize(appId: appId,
                                   clientId: clientId,
                                   zendeskUrl: zendeskUrl)
                Support.initialize(withZendesk: Zendesk.instance)
                AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
                Chat.initialize(accountKey: "p2NTTV8eKsiczkAWR8cmPnmxAytjvvR3")
            } else {
                print("error")
            }
        } catch {
            print("erroor")
        }
    }
    
    public func setUserZendesk(){
        let anonymous = Identity.createAnonymous(name: UUID().uuidString, // name is optional
                        email: "") // email is optional

//        let authenticated = Identity.createJwt(token: "unique_id")
        Zendesk.instance?.setIdentity(anonymous)
    }
    
    public func buildUI() throws -> UIViewController {
//        let messagingConfiguration = MessagingConfiguration()
//           let answerBotEngine = try AnswerBotEngine.engine()
////           let supportEngine = try SupportEngine.engine()
////           let chatEngine = try ChatEngine.engine()
//
//           return try Messaging.instance.buildUI(engines: [answerBotEngine],
//                                                 configs: [messagingConfiguration])
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
            // do something with error
        }
        return try Messaging.instance.buildUI(engines: [],
                                              configs: [])
    }

}
    

extension ZendeskWrapper {
    public func resetIdentity() {
        Chat.instance?.resetIdentity {
            
            // Identity cleared, continue to log out
        }
    }
}
