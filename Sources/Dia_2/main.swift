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
        if alunosInscritos.count >= capacidadeMaxima {
            print("Inscrição falhou: turma cheia.(\(capacidadeMaxima))")
            return false
        }

        for alunoInscrito in alunosInscritos {
            if alunoInscrito.matricula == aluno.matricula {
                print("Inscrição falhou: \(aluno.nome) já está inscrito.")
                return false
            }
        }

        alunosInscritos.append(aluno)

        print("Aluno \(aluno.nome) inscrito com sucesso.")

        return true
    }

    func possuiQuantidadeMinima() -> Bool {
        return alunosInscritos.count >= capacidadeMinima
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

let aluno1 = Aluno(nome: "Andreas",email: "andreas@gmail.com", matricula: "008",plano: CatalogoPlanos.mensal, nivel: .avancado)
let aluno2 = Aluno(nome: "Felipe", email: "felipe@gmail.com", matricula: "007", plano: CatalogoPlanos.trimestral,nivel: .iniciante)
let aluno3 = Aluno(nome: "Allan", email: "allan@gmail.com", matricula: "040", plano: CatalogoPlanos.trimestral,nivel: .intermediario)

let instrutor1 = Instrutor(nome: "Abel", email: "abel@email.com",especialidade: .musculacao)

let equipamento = EquipamentoFisico(nomeItem: "Esteira 01", estaDefeituoso: true)
let resultadoManutencao = equipamento.realizarReparo(data: "30/04/2026",status: .regular)

print("-----------------------")
print("Resultado manutenção: \(resultadoManutencao)")
print(equipamento.historico)

let turmaLuta = TurmaColetiva(
    nome: "Luta de Manhã",
    instrutor: instrutor1,
    categoria: .luta,
    descricao: "Aula coletiva de Luta.",
    capacidadeMinima: 2,
    capacidadeMaxima: 2
)

print("-----------------------")
print("Turma \(turmaLuta.nome)")
print("")
_ = turmaLuta.inscreverAluno(aluno1)
_ = turmaLuta.inscreverAluno(aluno1)
_ = turmaLuta.inscreverAluno(aluno2)
_ = turmaLuta.inscreverAluno(aluno3)
print("")

print("Turma possui mínimo: \(turmaLuta.possuiQuantidadeMinima())")

let treinoPersonal = TreinoPersonal(
    nome: "Treino Personalizado",
    instrutor: instrutor1,
    categoria: .musculacao,
    descricao: "Treino individual com personal trainer.",
    aluno: aluno1
)

print("---------------------")
print("Treino: \(treinoPersonal.nome)")
print("")
print("Aluno: \(treinoPersonal.aluno.nome)")
print("Instrutor: \(treinoPersonal.instrutor.nome)")