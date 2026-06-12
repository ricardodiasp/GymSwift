import Foundation

final class MenuAcademia {
    private let academia = GerenciadorAcademia()

    func iniciar() {
        while true {
            imprimirMenu()
            let opcao = lerTexto("Escolha uma opção:")
            print("----------------------")

            switch opcao {
            case "1":
                cadastrarAluno()
            case "2":
                listarAlunos()
            case "3":
                cadastrarEquipamento()
            case "4":
                listarEquipamentos()
            case "5":
                fazerManutencaoProgramada()
            case "6":
                cadastrarInstrutor()
            case "7":
                listarInstrutores()
            case "8":
                criarTurmaColetiva()
            case "9":
                agendarTreinoPersonal()
            case "10":
                listarAulasETurmas()
            case "0":
                print("Sistema encerrado.")
                return
            default:
                print("Opção inválida.")
            }
        }
    }

    private func imprimirMenu() {
        print("----------------------")
        print("MENU ACADEMIA")
        print("1 - Cadastrar aluno")
        print("2 - Listar alunos")
        print("3 - Cadastrar equipamento")
        print("4 - Listar equipamentos")
        print("5 - Fazer manutenção programada")
        print("6 - Cadastrar instrutor")
        print("7 - Listar instrutores")
        print("8 - Criar turma coletiva")
        print("9 - Agendar treino personal")
        print("10 - Listar aulas e turmas")
        print("0 - Sair")
    }

    private func cadastrarAluno() {
        let nome = lerTexto("Nome do aluno:")
        let email = lerTexto("Email do aluno:")
        let matricula = lerTexto("Matrícula:")

        print("Escolha o plano:")
        print("1 - Mensal")
        print("2 - Trimestral")
        print("3 - Anual")
        let planoEscolhido = CatalogoPlanos.plano(porOpcao: lerTexto("Opção:"))

        print("Escolha o nível:")
        print("1 - Iniciante")
        print("2 - Intermediário")
        print("3 - Avançado")
        let nivelEscolhido = NivelExperiencia.porOpcao(lerTexto("Opção:"))

        let novoAluno = Aluno(
            nome: nome,
            email: email,
            matricula: matricula,
            plano: planoEscolhido,
            nivel: nivelEscolhido
        )

        _ = academia.cadastrarAluno(novoAluno)
    }

    private func listarAlunos() {
        let alunos = academia.listarAlunos()

        if alunos.isEmpty {
            print("Nenhum aluno cadastrado.")
            return
        }

        print("Alunos cadastrados:")

        for aluno in alunos {
            print("- \(aluno.nome) | Email: \(aluno.email) | Matrícula: \(aluno.matricula) | Plano: \(aluno.plano.nome) | Nível: \(aluno.nivel)")
        }
    }

    private func cadastrarEquipamento() {
        let nomeItem = lerTexto("Nome do equipamento:")

        print("O equipamento está defeituoso?")
        print("1 - Sim")
        print("2 - Não")
        let estaDefeituoso = lerTexto("Opção:") == "1"

        let equipamento = EquipamentoFisico(
            nomeItem: nomeItem,
            estaDefeituoso: estaDefeituoso
        )

        academia.cadastrarEquipamento(equipamento)
    }

    private func listarEquipamentos() {
        let equipamentos = academia.listarEquipamentos()

        if equipamentos.isEmpty {
            print("Nenhum equipamento cadastrado.")
            return
        }

        print("Equipamentos cadastrados:")

        for equipamento in equipamentos {
            print("- \(equipamento.nomeItem) | Defeituoso: \(equipamento.estaDefeituoso ? "Sim" : "Não")")

            if equipamento.historico.isEmpty == false {
                print("  Histórico:")

                for registro in equipamento.historico {
                    print("  - \(registro)")
                }
            }
        }
    }

    private func fazerManutencaoProgramada() {
        let data = lerTexto("Data da manutenção:")
        let equipamentosReparados = academia.realizarManutencaoProgramada(data: data)

        if equipamentosReparados.isEmpty {
            print("Manutenção preventiva realizada. Nenhum equipamento precisava de reparo.")
            return
        }

        print("Equipamentos reparados:")

        for equipamento in equipamentosReparados {
            print("- \(equipamento.nomeItem)")
        }
    }

    private func cadastrarInstrutor() {
        let nome = lerTexto("Nome do instrutor:")
        let email = lerTexto("Email do instrutor:")

        print("Especialidade:")
        print("1 - Musculação")
        print("2 - Spinning")
        print("3 - Yoga")
        print("4 - Funcional")
        print("5 - Luta")
        let especialidade = CategoriaAula.porOpcao(lerTexto("Opção:"))

        let instrutor = Instrutor(
            nome: nome,
            email: email,
            especialidade: especialidade
        )

        _ = academia.cadastrarInstrutor(instrutor)
    }

    private func listarInstrutores() {
        let instrutores = academia.listarInstrutores()

        if instrutores.isEmpty {
            print("Nenhum instrutor cadastrado.")
            return
        }

        print("Instrutores cadastrados:")

        for instrutor in instrutores {
            print("- \(instrutor.nome) | Email: \(instrutor.email) | Especialidade: \(instrutor.especialidade)")
        }
    }

    private func criarTurmaColetiva() {
        let nomeTurma = lerTexto("Nome da turma:")
        let emailInstrutor = lerTexto("Email do instrutor:")

        guard let instrutorEscolhido = academia.buscarInstrutorPorEmail(email: emailInstrutor) else {
            print("Criação falhou: instrutor não encontrado.")
            return
        }

        let descricao = lerTexto("Descrição da turma:")
        let capacidadeMinima = lerInteiro("Capacidade mínima:", valorPadrao: 1)
        let capacidadeMaxima = lerInteiro("Capacidade máxima:", valorPadrao: capacidadeMinima)

        let turma = TurmaColetiva(
            nome: nomeTurma,
            instrutor: instrutorEscolhido,
            categoria: instrutorEscolhido.especialidade,
            descricao: descricao,
            capacidadeMinima: capacidadeMinima,
            capacidadeMaxima: capacidadeMaxima
        )

        while true {
            let matricula = lerTexto("Digite a matrícula do aluno para inscrever ou 0 para finalizar:")

            if matricula == "0" {
                break
            }

            guard let aluno = academia.buscarAluno(matricula: matricula) else {
                print("Aluno não encontrado.")
                continue
            }

            _ = turma.inscreverAluno(aluno)
        }

        print("Turma possui quantidade mínima? \(turma.possuiQuantidadeMinima() ? "Sim" : "Não")")
        academia.cadastrarAula(turma)
    }

    private func agendarTreinoPersonal() {
        let matricula = lerTexto("Matrícula do aluno:")
        let emailInstrutor = lerTexto("Email do instrutor:")

        guard let instrutorEscolhido = academia.buscarInstrutorPorEmail(email: emailInstrutor) else {
            print("Agendamento falhou: instrutor não encontrado.")
            return
        }

        _ = academia.agendarTreinoPersonal(
            nome: "Treino Personal",
            matriculaAluno: matricula,
            instrutor: instrutorEscolhido,
            categoria: instrutorEscolhido.especialidade,
            descricao: "Treino individual com personal trainer."
        )
    }

    private func listarAulasETurmas() {
        let aulas = academia.listarAulas()

        if aulas.isEmpty {
            print("Nenhuma aula cadastrada.")
            return
        }

        print("Aulas cadastradas:")

        for aula in aulas {
            print("----------------------")
            print("Nome: \(aula.nome)")
            print("Instrutor: \(aula.instrutor.nome)")
            print("Categoria: \(aula.categoria)")
            print("Descrição: \(aula.descricao)")

            if let turma = aula as? TurmaColetiva {
                imprimirTurma(turma)
            } else if let treino = aula as? TreinoPersonal {
                imprimirTreinoPersonal(treino)
            }
        }
    }

    private func imprimirTurma(_ turma: TurmaColetiva) {
        print("Tipo: Turma coletiva")
        print("Capacidade mínima: \(turma.capacidadeMinima)")
        print("Capacidade máxima: \(turma.capacidadeMaxima)")
        print("Possui mínimo necessário: \(turma.possuiQuantidadeMinima() ? "Sim" : "Não")")

        let alunos = turma.listarAlunosInscritos()

        if alunos.isEmpty {
            print("Nenhum aluno inscrito.")
            return
        }

        print("Alunos inscritos:")

        for aluno in alunos {
            print("- \(aluno.nome) | Matrícula: \(aluno.matricula) | Nível: \(aluno.nivel)")
        }
    }

    private func imprimirTreinoPersonal(_ treino: TreinoPersonal) {
        print("Tipo: Treino personal")
        print("Aluno: \(treino.aluno.nome)")
        print("Matrícula: \(treino.aluno.matricula)")
        print("Plano: \(treino.aluno.plano.nome)")
    }

    private func lerTexto(_ mensagem: String) -> String {
        print(mensagem)
        return (readLine() ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func lerInteiro(_ mensagem: String, valorPadrao: Int) -> Int {
        let texto = lerTexto(mensagem)
        return Int(texto) ?? valorPadrao
    }
}
