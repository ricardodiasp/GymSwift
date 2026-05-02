import Foundation

enum NivelExperiencia {
    case iniciante
    case intermediario
    case avancado
}

enum CategoriaAula {
    case musculacao
    case spinning
    case yoga
    case funcional
    case luta
}

enum StatusRegularidade {
    case regular
    case irregular
}

class PlanoAssinatura {
    let nome: String
    let valorMensalidade: Double
    let incluiPersonalTrainer: Bool
    let limiteAulasColetivas: Int
    let duracaoEmMeses: Int

    init(nome: String, valorMensalidade: Double, incluiPersonalTrainer: Bool, limiteAulasColetivas: Int, duracaoEmMeses: Int) {
        self.nome = nome
        self.valorMensalidade = valorMensalidade
        self.incluiPersonalTrainer = incluiPersonalTrainer
        self.limiteAulasColetivas = limiteAulasColetivas
        self.duracaoEmMeses = duracaoEmMeses
    }
}

class CatalogoPlanos {

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
}
class Pessoa {
    let nome: String
    let email: String
    let funcao: String

    init(nome: String, email: String, funcao: String) {
        self.nome = nome
        self.email = email
        self.funcao = funcao
    }
}

class Aluno: Pessoa {
    let matricula: String
    var plano: PlanoAssinatura
    var nivel: NivelExperiencia

    init(nome: String, email: String, matricula: String, plano: PlanoAssinatura, nivel: NivelExperiencia) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel

        super.init(nome: nome, email: email, funcao: "Aluno")
    }

    func atualizarPlano(novoPlano: PlanoAssinatura) {
        self.plano = novoPlano
    }

    func atualizarNivel(novoNivel: NivelExperiencia) {
        self.nivel = novoNivel
    }
}

class Instrutor: Pessoa {
    let especialidade: CategoriaAula

    init(nome: String, email: String, especialidade: CategoriaAula) {
        self.especialidade = especialidade
        super.init(nome: nome, email: email, funcao: "Instrutor")
    }
}

protocol ContratoManutencao {
    var nomeItem: String { get }
    var historico: [String] { get }

    func realizarReparo(data: String, status: StatusRegularidade) -> Bool
}

class EquipamentoFisico: ContratoManutencao {
    let nomeItem: String
    private(set) var historico: [String]
    var estaDefeituoso: Bool

    init(nomeItem: String, estaDefeituoso: Bool) {
        self.nomeItem = nomeItem
        self.estaDefeituoso = estaDefeituoso
        self.historico = []
    }

    func realizarReparo(data: String, status: StatusRegularidade) -> Bool {
        if estaDefeituoso {
            historico.append("Manutenção falhou em \(data). Equipamento defeituoso.")
            return false
        }

        historico.append("Reparo realizado em \(data). Status: \(status)")
        return true
    }
}

protocol Aula {
    var nome: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }
}

class TurmaColetiva: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String

    let capacidadeMinima: Int
    let capacidadeMaxima: Int

    private(set) var alunosInscritos: [Aluno]

    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String, capacidadeMinima: Int, capacidadeMaxima: Int) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidadeMinima = capacidadeMinima
        self.capacidadeMaxima = capacidadeMaxima
        self.alunosInscritos = []
    }

    func inscreverAluno(_ aluno: Aluno) -> Bool {
        for alunoInscrito in alunosInscritos {
            if alunoInscrito.matricula == aluno.matricula {
                print("Inscrição falhou: \(aluno.nome) já está inscrito.")
                return false
            }
        }

        if alunosInscritos.count >= capacidadeMaxima {
            print("Inscrição falhou: turma cheia. Capacidade máxima: \(capacidadeMaxima)")
            return false
        }

        alunosInscritos.append(aluno)
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

class TreinoPersonal: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String
    let aluno: Aluno

    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String, aluno: Aluno) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = aluno
    }
}

class GerenciadorAcademia {
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

    func cadastrarInstrutor(_ instrutor: Instrutor) {
        instrutores.append(instrutor)
        print("Instrutor \(instrutor.nome) cadastrado com sucesso.")
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

    func realizarManutencaoProgramada(data: String) -> [EquipamentoFisico] {
        var equipamentosComFalha: [EquipamentoFisico] = []

        for equipamento in equipamentos {
            let sucesso = equipamento.realizarReparo(data: data, status: .regular)

            if sucesso == false {
                equipamentosComFalha.append(equipamento)
            }
        }

        return equipamentosComFalha
    }

    func agendarTreinoPersonal(nome: String, matriculaAluno: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String) -> TreinoPersonal? {
        guard let aluno = buscarAluno(matricula: matriculaAluno) else {
            print("Agendamento falhou: aluno não encontrado.")
            return nil
        }

        if aluno.plano.incluiPersonalTrainer == false {
            print("Agendamento falhou: o plano de \(aluno.nome) não inclui personal trainer.")
            return nil
        }

        let treino = TreinoPersonal(nome: nome, instrutor: instrutor, categoria: categoria, descricao: descricao, aluno: aluno)

        aulas.append(treino)

        print("Treino personal agendado com sucesso para \(aluno.nome) com o instrutor \(instrutor.nome).")

        return treino
    }
    
    func buscarInstrutorPorEmail(email: String) -> Instrutor? {
        for instrutor in instrutores {
            if instrutor.email == email {
                return instrutor
            }
        }

        return nil
    }

    func listarAlunos() -> [Aluno] {
        return Array(alunosPorMatricula.values)
    }

    func listarInstrutores() -> [Instrutor] {
        return instrutores
    }

    func listarEquipamentos() -> [EquipamentoFisico] {
        return equipamentos
    }

    func listarAulas() -> [Aula] {
        return aulas
    }
}

let academia = GerenciadorAcademia()

while true {
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
    print("Escolha uma opção:")

    let opcao = readLine() ?? ""
    print("----------------------")

    if opcao == "1" {
        print("Nome do aluno:")
        let nome = readLine() ?? ""

        print("Email do aluno:")
        let email = readLine() ?? ""

        print("Matrícula:")
        let matricula = readLine() ?? ""

        print("Escolha o plano:")
        print("1 - Mensal")
        print("2 - Trimestral")
        print("3 - Anual")

        let opcaoPlano = readLine() ?? ""

        var planoEscolhido = CatalogoPlanos.mensal

        if opcaoPlano == "2" {
            planoEscolhido = CatalogoPlanos.trimestral
        } else if opcaoPlano == "3" {
            planoEscolhido = CatalogoPlanos.anual
        }

        print("Escolha o nível:")
        print("1 - Iniciante")
        print("2 - Intermediário")
        print("3 - Avançado")

        let opcaoNivel = readLine() ?? ""

        var nivelEscolhido: NivelExperiencia = .iniciante

        if opcaoNivel == "2" {
            nivelEscolhido = .intermediario
        } else if opcaoNivel == "3" {
            nivelEscolhido = .avancado
        }

        let novoAluno = Aluno(
            nome: nome,
            email: email,
            matricula: matricula,
            plano: planoEscolhido,
            nivel: nivelEscolhido
        )

        _ = academia.cadastrarAluno(novoAluno)

    } else if opcao == "2" {
        let alunos = academia.listarAlunos()

        if alunos.isEmpty {
            print("Nenhum aluno cadastrado.")
        } else {
            print("Alunos cadastrados:")

            for aluno in alunos {
                print("- \(aluno.nome) | Email: \(aluno.email) | Matrícula: \(aluno.matricula) | Plano: \(aluno.plano.nome)")
            }
        }

    } else if opcao == "3" {
        print("Nome do equipamento:")
        let nomeItem = readLine() ?? ""

        print("O equipamento está defeituoso?")
        print("1 - Sim")
        print("2 - Não")

        let opcaoDefeito = readLine() ?? ""

        var estaDefeituoso = false

        if opcaoDefeito == "1" {
            estaDefeituoso = true
        }

        let equipamento = EquipamentoFisico(
            nomeItem: nomeItem,
            estaDefeituoso: estaDefeituoso
        )

        academia.cadastrarEquipamento(equipamento)

    } else if opcao == "4" {
        let equipamentos = academia.listarEquipamentos()

        if equipamentos.isEmpty {
            print("Nenhum equipamento cadastrado.")
        } else {
            print("Equipamentos cadastrados:")

            for equipamento in equipamentos {
                print("- \(equipamento.nomeItem) | Defeituoso: \(equipamento.estaDefeituoso)")
            }
        }

    } else if opcao == "5" {
        print("Data da manutenção:")
        let data = readLine() ?? ""

        let falhas = academia.realizarManutencaoProgramada(data: data)

        if falhas.isEmpty {
            print("Nenhum equipamento falhou na manutenção.")
        } else {
            print("Equipamentos que falharam:")

            for equipamento in falhas {
                print("- \(equipamento.nomeItem)")
            }
        }

    } else if opcao == "6" {
        print("Nome do instrutor:")
        let nome = readLine() ?? ""

        print("Email do instrutor:")
        let email = readLine() ?? ""
        print("Especialidade:")
        print("1 - Musculação")
        print("2 - Spinning")
        print("3 - Yoga")
        print("4 - Funcional")
        print("5 - Luta")

        let opcaoEspecialidade = readLine() ?? ""

        var especialidade: CategoriaAula = .musculacao

        if opcaoEspecialidade == "2" {
            especialidade = .spinning
        } else if opcaoEspecialidade == "3" {
            especialidade = .yoga
        } else if opcaoEspecialidade == "4" {
            especialidade = .funcional
        } else if opcaoEspecialidade == "5" {
            especialidade = .luta
        }

        let instrutor = Instrutor(
            nome: nome,
            email: email,
            especialidade: especialidade
        )

        academia.cadastrarInstrutor(instrutor)

    } else if opcao == "7" {
        let instrutores = academia.listarInstrutores()

        if instrutores.isEmpty {
            print("Nenhum instrutor cadastrado.")
        } else {
            print("Instrutores cadastrados:")
            for instrutor in instrutores {

                print("- \(instrutor.nome) | Email: \(instrutor.email) | Especialidade: \(instrutor.especialidade)")
            }
        }

    } else if opcao == "8" {
        print("Nome da turma:")
        let nomeTurma = readLine() ?? ""

        print("Email do instrutor:")
        let emailInstrutor = readLine() ?? ""

        guard let instrutorEscolhido = academia.buscarInstrutorPorEmail(email: emailInstrutor) else {
            print("Criação falhou: instrutor não encontrado.")
            continue
        }

        print("Descrição da turma:")
        let descricao = readLine() ?? ""

        print("Capacidade mínima:")
        let capacidadeMinima = Int(readLine() ?? "") ?? 1

        print("Capacidade máxima:")
        let capacidadeMaxima = Int(readLine() ?? "") ?? 1

        let turma = TurmaColetiva(
            nome: nomeTurma,
            instrutor: instrutorEscolhido,
            categoria: instrutorEscolhido.especialidade,
            descricao: descricao,
            capacidadeMinima: capacidadeMinima,
            capacidadeMaxima: capacidadeMaxima
        )

        while true {
            print("Digite a matrícula do aluno para inscrever ou 0 para finalizar:")
            let matricula = readLine() ?? ""

            if matricula == "0" {
                break
            }

            guard let aluno = academia.buscarAluno(matricula: matricula) else {
                print("Aluno não encontrado.")
                continue
            }

            _ = turma.inscreverAluno(aluno)
        }

        print("Turma possui quantidade mínima? \(turma.possuiQuantidadeMinima())")

        academia.cadastrarAula(turma)

    } else if opcao == "9" {
        print("Matrícula do aluno:")
        let matricula = readLine() ?? ""

        print("Email do instrutor:")
        let emailInstrutor = readLine() ?? ""

        guard let instrutorEscolhido = academia.buscarInstrutorPorEmail(email: emailInstrutor) else {
            print("Agendamento falhou: instrutor não encontrado.")
            continue
        }
        let _ = academia.agendarTreinoPersonal(
            nome: "Treino Personal",
            matriculaAluno: matricula,
            instrutor: instrutorEscolhido,
            categoria: instrutorEscolhido.especialidade,
            descricao: "Treino individual com personal trainer."
        )

    } else if opcao == "10" {

        let aulas = academia.listarAulas()

        if aulas.isEmpty {
            print("Nenhuma aula cadastrada.")
        } else {
            print("Aulas cadastradas:")

            for aula in aulas {
                print("----------------------")
                print("Nome: \(aula.nome)")
                print("Instrutor: \(aula.instrutor.nome)")
                print("Categoria: \(aula.categoria)")
                print("Descrição: \(aula.descricao)")

                if let turma = aula as? TurmaColetiva {
                    print("Tipo: Turma coletiva")
                    print("Capacidade mínima: \(turma.capacidadeMinima)")
                    print("Capacidade máxima: \(turma.capacidadeMaxima)")
                    print("Possui mínimo necessário: \(turma.possuiQuantidadeMinima())")

                    let alunos = turma.listarAlunosInscritos()

                    if alunos.isEmpty {
                        print("Nenhum aluno inscrito.")
                    } else {
                        print("Alunos inscritos:")

                        for aluno in alunos {
                            print("- \(aluno.nome) | Matrícula: \(aluno.matricula) | Nível: \(aluno.nivel)")
                        }
                    }

                } else if let treino = aula as? TreinoPersonal {
                    print("Tipo: Treino personal")
                    print("Aluno: \(treino.aluno.nome)")
                    print("Matrícula: \(treino.aluno.matricula)")
                    print("Plano: \(treino.aluno.plano.nome)")
                }
            }

        }

    } else if opcao == "0" {
        print("Sistema Encerrado.")
        break

    } else {
        print("Opção inválida.")
    }
}