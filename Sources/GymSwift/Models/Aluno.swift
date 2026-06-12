final class Aluno: Pessoa {
    let matricula: String
    private(set) var aulasColetivasInscritas: Int
    var plano: PlanoAssinatura
    var nivel: NivelExperiencia

    init(
        nome: String,
        email: String,
        matricula: String,
        plano: PlanoAssinatura,
        nivel: NivelExperiencia
    ) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel
        self.aulasColetivasInscritas = 0

        super.init(nome: nome, email: email, funcao: "Aluno")
    }

    func atualizarPlano(novoPlano: PlanoAssinatura) {
        self.plano = novoPlano
    }

    func atualizarNivel(novoNivel: NivelExperiencia) {
        self.nivel = novoNivel
    }

    func podeInscreverEmAulaColetiva() -> Bool {
        return aulasColetivasInscritas < plano.limiteAulasColetivas
    }

    func registrarInscricaoEmAulaColetiva() {
        aulasColetivasInscritas += 1
    }
}
