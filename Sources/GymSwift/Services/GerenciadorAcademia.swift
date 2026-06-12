final class GerenciadorAcademia {
    private var alunosPorMatricula: [String: Aluno]
    private var emailsCadastrados: Set<String>
    private var instrutores: [Instrutor]
    private var equipamentos: [EquipamentoFisico]
    private var aulas: [Aula]

    init() {
        self.alunosPorMatricula = [:]
        self.emailsCadastrados = []
        self.instrutores = []
        self.equipamentos = []
        self.aulas = []
    }

    func cadastrarAluno(_ aluno: Aluno) -> Bool {
        if alunosPorMatricula[aluno.matricula] != nil {
            print("Cadastro falhou: matrícula \(aluno.matricula) já existente.")
            return false
        }

        if emailsCadastrados.contains(aluno.email) {
            print("Cadastro falhou: e-mail \(aluno.email) já existente.")
            return false
        }

        alunosPorMatricula[aluno.matricula] = aluno
        emailsCadastrados.insert(aluno.email)

        print("Aluno \(aluno.nome) cadastrado com sucesso.")
        return true
    }

    func cadastrarInstrutor(_ instrutor: Instrutor) -> Bool {
        if emailsCadastrados.contains(instrutor.email) {
            print("Cadastro falhou: e-mail \(instrutor.email) já existente.")
            return false
        }

        instrutores.append(instrutor)
        emailsCadastrados.insert(instrutor.email)

        print("Instrutor \(instrutor.nome) cadastrado com sucesso.")
        return true
    }

    func cadastrarEquipamento(_ equipamento: EquipamentoFisico) {
        equipamentos.append(equipamento)
        print("Equipamento \(equipamento.nomeItem) cadastrado com sucesso.")
    }

    func cadastrarAula(_ aula: Aula) {
        aulas.append(aula)
        print("Aula \(aula.nome) cadastrada com sucesso.")
    }

    func buscarAluno(matricula: String) -> Aluno? {
        return alunosPorMatricula[matricula]
    }

    func buscarInstrutorPorEmail(email: String) -> Instrutor? {
        return instrutores.first { instrutor in
            instrutor.email == email
        }
    }

    func realizarManutencaoProgramada(data: String) -> [EquipamentoFisico] {
        var equipamentosReparados: [EquipamentoFisico] = []

        for equipamento in equipamentos {
            let estavaDefeituoso = equipamento.estaDefeituoso
            let status: StatusRegularidade = estavaDefeituoso ? .irregular : .regular
            let sucesso = equipamento.realizarReparo(data: data, status: status)

            if estavaDefeituoso && sucesso {
                equipamentosReparados.append(equipamento)
            }
        }

        return equipamentosReparados
    }

    func agendarTreinoPersonal(
        nome: String,
        matriculaAluno: String,
        instrutor: Instrutor,
        categoria: CategoriaAula,
        descricao: String
    ) -> TreinoPersonal? {
        guard let aluno = buscarAluno(matricula: matriculaAluno) else {
            print("Agendamento falhou: aluno não encontrado.")
            return nil
        }

        if aluno.plano.incluiPersonalTrainer == false {
            print("Agendamento falhou: o plano de \(aluno.nome) não inclui personal trainer.")
            return nil
        }

        let treino = TreinoPersonal(
            nome: nome,
            instrutor: instrutor,
            categoria: categoria,
            descricao: descricao,
            aluno: aluno
        )

        aulas.append(treino)

        print("Treino personal agendado com sucesso para \(aluno.nome) com o instrutor \(instrutor.nome).")

        return treino
    }

    func listarAlunos() -> [Aluno] {
        return Array(alunosPorMatricula.values).sorted { primeiro, segundo in
            primeiro.nome < segundo.nome
        }
    }

    func listarInstrutores() -> [Instrutor] {
        return instrutores.sorted { primeiro, segundo in
            primeiro.nome < segundo.nome
        }
    }

    func listarEquipamentos() -> [EquipamentoFisico] {
        return equipamentos
    }

    func listarAulas() -> [Aula] {
        return aulas
    }
}
