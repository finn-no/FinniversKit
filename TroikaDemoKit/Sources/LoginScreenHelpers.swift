//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Troika

public struct LoginViewData: LoginViewModel {
    public init() {
    }

    public let headerText = "Logg inn for å sende meldinger, lagre favoritter og søk. Du får også varsler når det skjer noe nytt!"

    public let emailPlaceholder = "E-post"

    public let passwordPlaceholder = "Passord"

    public let forgotPasswordButtonTitle = "Glemt passord"

    public let loginButtonTitle = "Logg inn"

    public let newUserButtonTitle = "Ny bruker"

    public let userTermsIntroText = "Ved å logge inn aksepterer du brukervilkårene våre"

    public let userTermsButtonTitle = "Brukervilkår"
}
