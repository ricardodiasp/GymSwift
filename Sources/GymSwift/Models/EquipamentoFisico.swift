import Foundation

final class EquipamentoFisico: ContratoManutencao {
    let nomeItem: String
    private(set) var historico: [String]
    var estaDefeituoso: Bool

    init(nomeItem: String, estaDefeituoso: Bool) {
        self.nomeItem = nomeItem
        self.estaDefeituoso = estaDefeituoso
        self.historico = []
    }

    func realizarReparo(data: String, status: StatusRegularidade) -> Bool {
        let dataFormatada = data.trimmingCharacters(in: .whitespacesAndNewlines)

        guard dataFormatada.isEmpty == false else {
            historico.append("Manutenção não realizada. Data inválida.")
            return false
        }

        if estaDefeituoso {
            estaDefeituoso = false
            historico.append("Reparo realizado em \(dataFormatada). Status anterior: \(status). Equipamento consertado.")
            return true
        }

        historico.append("Manutenção preventiva realizada em \(dataFormatada). Status: \(status).")
        return true
    }
}
