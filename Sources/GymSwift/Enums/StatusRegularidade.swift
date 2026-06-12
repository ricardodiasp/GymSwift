enum StatusRegularidade: CustomStringConvertible {
    case regular
    case irregular

    var description: String {
        switch self {
        case .regular:
            return "Regular"
        case .irregular:
            return "Irregular"
        }
    } 
}
