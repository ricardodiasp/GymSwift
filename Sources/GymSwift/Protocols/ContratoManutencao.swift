protocol ContratoManutencao {
    var nomeItem: String { get }
    var historico: [String] { get }

    func realizarReparo(data: String, status: StatusRegularidade) -> Bool
}
