enum CategoriaAula: CustomStringConvertible {
    case musculacao
    case spinning
    case yoga
    case funcional
    case luta

    var description: String {
        switch self {
        case .musculacao:
            return "Musculação"
        case .spinning:
            return "Spinning"
        case .yoga:
            return "Yoga"
        case .funcional:
            return "Funcional"
        case .luta:
            return "Luta"
        }
    }

    static func porOpcao(_ opcao: String) -> CategoriaAula {
        switch opcao {
        case "2":
            return .spinning
        case "3":
            return .yoga
        case "4":
            return .funcional
        case "5":
            return .luta
        default:
            return .musculacao
        }
    }
}
