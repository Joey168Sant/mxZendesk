

import ZendeskCoreSDK
import SupportProvidersSDK
import AnswerBotProvidersSDK
import ChatProvidersSDK

public class ZendeskWrapper {
    public static var shared: ZendeskWrapper = {
        let instance = ZendeskWrapper()
        return instance
    }()
    private var internalCallback: ((String) -> Void)!
    private var viewController: UIViewController?
    
    private init() {}
    
    
    public func initZendesk(viewController: UIViewController) throws {
        do {
            if let config = try ConfigProvider.getConfigPath(Constants.SURVEY_MANAGER)[Constants.QUALTRICS] as? [String: Any] {
                self.viewController = viewController
                let brandId = config[Constants.BRAND_ID] as! String
                let zoneId = config[Constants.ZONE_ID] as! String
                let interceptId = config[Constants.INTERCEPT_ID] as! String
                
            } catch {
                print("errooss")
            }
        }
    }
    
}
