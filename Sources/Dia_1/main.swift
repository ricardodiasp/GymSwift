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

class PlanoAssinatura {

    let nome: String
    let valorMensalidade: Double
    let incluiPersonalTrainer: Bool
    let limiteAulasColetivas: Int
    let duracaoEmMeses: Int

    init(nome: String,valorMensalidade: Double, incluiPersonalTrainer: Bool, limiteAulasColetivas: Int, duracaoEmMeses: Int) {
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

    static let todos = [
        mensal,
        trimestral,
        anual
    ]
}


class Pessoa {

    let nome: String
    let email: String
    let funcao: String

    init(nome: String, email: String,funcao: String) {
        self.nome = nome
        self.email = email
        self.funcao = funcao
    }
}

class Aluno: Pessoa {

    let matricula: String
    var plano: PlanoAssinatura
    var nivel: NivelExperiencia

    init(nome: String, email: String, matricula: String, plano: PlanoAssinatura, nivel: NivelExperiencia){
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel

        super.init(nome: nome, email: email, funcao: "Aluno")
    }

    func atualizarPlano(novoPlano: PlanoAssinatura){
        self.plano = novoPlano
    }

    func atualizarNivel(novoNivel: NivelExperiencia){
        self.nivel = novoNivel
    }
}

class Instrutor: Pessoa {
    let especialidade: CategoriaAula

    init(nome: String, email: String, especialidade: CategoriaAula){

        self.especialidade = especialidade

        super.init(nome: nome, email: email, funcao: "Instrutor")
    }
}

let aluno1 = Aluno(nome: "Carlos Silva", email: "carlos@email.com", matricula: "A001", plano: CatalogoPlanos.mensal, nivel: .iniciante)

let instrutor1 = Instrutor(nome: "Mariana Souza", email: "mariana@email.com", especialidade: .yoga)


aluno1.atualizarPlano(novoPlano: CatalogoPlanos.anual)

aluno1.atualizarNivel(novoNivel: .intermediario)


print("ALUNO")
print("Nome: \(aluno1.nome)")
print("Email: \(aluno1.email)")
print("Matrícula: \(aluno1.matricula)")
print("Plano: \(aluno1.plano.nome)")
print("Função: \(aluno1.funcao)")

print("")

print("INSTRUTOR")
print("Nome: \(instrutor1.nome)")
print("Email: \(instrutor1.email)")
print("Função: \(instrutor1.funcao)")
print("Especialidade: \(instrutor1.especialidade)")