final class TreinoPersonal: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String
    let aluno: Aluno

    init(
        nome: String,
        instrutor: Instrutor,
        categoria: CategoriaAula,
        descricao: String,
        aluno: Aluno
    ) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = aluno
    }
}
