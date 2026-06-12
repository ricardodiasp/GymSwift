final class CatalogoPlanos {
    private init() {}

    static let mensal = PlanoAssinatura(
        nome: "Mensal",
        valorMensalidade: 120.0,
        incluiPersonalTrainer: false,
        limiteAulasColetivas: 8,
        duracaoEmMeses: 1
    )

    static let trimestral = PlanoAssinatura(
        nome: "Trimestral",
        valorMensalidade: 100.0,
        incluiPersonalTrainer: false,
        limiteAulasColetivas: 15,
        duracaoEmMeses: 3
    )

    static let anual = PlanoAssinatura(
        nome: "Anual",
        valorMensalidade: 80.0,
        incluiPersonalTrainer: true,
        limiteAulasColetivas: 30,
        duracaoEmMeses: 12
    )

    static let todos = [mensal, trimestral, anual]

    static func plano(porOpcao opcao: String) -> PlanoAssinatura {
        switch opcao {
        case "2":
            return trimestral
        case "3":
            return anual
        default:
            return mensal
        }
    }
}
