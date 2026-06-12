enum NivelExperiencia: CustomStringConvertible {
    case iniciante
    case intermediario
    case avancado

    var description: String {
        switch self {
        case .iniciante:
            return "Iniciante"
        case .intermediario:
            return "Intermediário"
        case .avancado:
            return "Avançado"
        }
    }

    static func porOpcao(_ opcao: String) -> NivelExperiencia {
        switch opcao {
        case "2":
            return .intermediario
        case "3":
            return .avancado
        default:
            return .iniciante
        }
    }
}
