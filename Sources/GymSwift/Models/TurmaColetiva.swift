final class TurmaColetiva: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String
    let capacidadeMinima: Int
    let capacidadeMaxima: Int

    private(set) var alunosInscritos: [Aluno]

    init(
        nome: String,
        instrutor: Instrutor,
        categoria: CategoriaAula,
        descricao: String,
        capacidadeMinima: Int,
        capacidadeMaxima: Int
    ) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidadeMinima = max(1, capacidadeMinima)
        self.capacidadeMaxima = max(self.capacidadeMinima, capacidadeMaxima)
        self.alunosInscritos = []
    }

    func inscreverAluno(_ aluno: Aluno) -> Bool {
        for alunoInscrito in alunosInscritos {
            if alunoInscrito.matricula == aluno.matricula {
                print("Inscrição falhou: \(aluno.nome) já está inscrito.")
                return false
            }
        }

        if aluno.podeInscreverEmAulaColetiva() == false {
            print("Inscrição falhou: \(aluno.nome) atingiu o limite de aulas coletivas do plano \(aluno.plano.nome).")
            return false
        }

        if alunosInscritos.count >= capacidadeMaxima {
            print("Inscrição falhou: turma cheia. Capacidade máxima: \(capacidadeMaxima).")
            return false
        }

        alunosInscritos.append(aluno)
        aluno.registrarInscricaoEmAulaColetiva()
        print("Aluno \(aluno.nome) inscrito com sucesso.")
        return true
    }

    func possuiQuantidadeMinima() -> Bool {
        return alunosInscritos.count >= capacidadeMinima
    }

    func listarAlunosInscritos() -> [Aluno] {
        return alunosInscritos
    }
}
