final class PlanoAssinatura {
    let nome: String
    let valorMensalidade: Double
    let incluiPersonalTrainer: Bool
    let limiteAulasColetivas: Int
    let duracaoEmMeses: Int

    var valorTotal: Double {
        return valorMensalidade * Double(duracaoEmMeses)
    }

    init(
        nome: String,
        valorMensalidade: Double,
        incluiPersonalTrainer: Bool,
        limiteAulasColetivas: Int,
        duracaoEmMeses: Int
    ) {
        self.nome = nome
        self.valorMensalidade = valorMensalidade
        self.incluiPersonalTrainer = incluiPersonalTrainer
        self.limiteAulasColetivas = limiteAulasColetivas
        self.duracaoEmMeses = duracaoEmMeses
    }
}
