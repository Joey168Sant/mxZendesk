

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
                Qualtrics.shared.initialize(brandId: brandId, zoneId: zoneId, interceptId: interceptId) { result in
                    if !result.passed() {
                        self.getResult()
                    } else {
                        self.getResult(message: QualtricsException.getMessageException(ErrorCode.CODE_3))
                    }
                }
            } else {
                throw try QualtricsException(ErrorCode.CODE_2)
            }
        } catch ConfigProviderError.configPathIsMissing {
            getResult(message: QualtricsException.getMessageException(ErrorCode.CODE_2))
        } catch {
            getResult(message: "\(error)")
        }
    }
    
    
}
