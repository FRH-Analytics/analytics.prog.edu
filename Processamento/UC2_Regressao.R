library(plyr)

ajeitar.nota = function(string) {
  return(as.double(paste(substr(string, 1, 1), ".", substr(string, 3, 3), sep="")))
}

filtra.dados = function(dados) {
  df = data.frame(matricula=c(), nota=c())
  
  for (i in 1:nrow(dados))
    if (paste(dados[i, "Nota"], "", sep="") != "#VALUE!" & paste(dados[i, "Nota"], "", sep="") != "")
      df = rbind(df, data.frame(matricula=dados[i, "Matrícula"], nota=dados[i, "Nota"]))
  
  return(df)
}

ajeita.provas = function(filename) {
  dados = read.csv(filename)
  dados = filtra.dados(dados)
  dados$nota = ajeitar.nota(dados[, "nota"])
  
  return(dados)
}

dados.exercicios = read.csv("../Dados/exercicios-20112.csv")

dados.exercicios.um = dados.exercicios[dados.exercicios$questao < 86, ]
dados.exercicios.um = ddply(dados.exercicios.um, .(matricula), nrow)
colnames(dados.exercicios.um) = c("matricula", "numero.submissoes")
dados.exercicios.dois = dados.exercicios[dados.exercicios$questao > 85 & dados.exercicios$questao < 165, ]
dados.exercicios.dois = ddply(dados.exercicios.dois, .(matricula), nrow)
colnames(dados.exercicios.dois) = c("matricula", "numero.submissoes")
dados.exercicios.tres = dados.exercicios[dados.exercicios$questao > 164, ]
dados.exercicios.tres = ddply(dados.exercicios.tres, .(matricula), nrow)
colnames(dados.exercicios.tres) = c("matricula", "numero.submissoes")

dados.prova.um = ajeita.provas("../Dados/Prova1.csv")
dados.prova.dois = ajeita.provas("../Dados/Prova2.csv")
dados.prova.tres = ajeita.provas("../Dados/Prova3.csv")

prova.exercicio.um = merge(dados.prova.um, dados.exercicios.um)
prova.exercicio.dois = merge(dados.prova.dois, dados.exercicios.dois)
prova.exercicio.tres = merge(dados.prova.tres, dados.exercicios.tres)

correlacao.prova.um = cor.test(prova.exercicio.um$nota, prova.exercicio.um$numero.submissoes, method="spearman")
correlacao.prova.dois = cor.test(prova.exercicio.dois$nota, prova.exercicio.dois$numero.submissoes, method="spearman")
correlacao.prova.tres = cor.test(prova.exercicio.tres$nota, prova.exercicio.tres$numero.submissoes, method="spearman")

correlacoes = data.frame(correlacao.prova.um=c(correlacao.prova.um$estimate),
                         correlacao.prova.dois=c(correlacao.prova.dois$estimate),
                         correlacao.prova.tres=c(correlacao.prova.tres$estimate))

write.csv(correlacoes, "correlacoes.csv", quote=F, row.names=F, col.names=F)

write.csv(prova.exercicio.um[, c("nota", "numero.submissoes")], "UC2-Prova1.csv", quote=F, row.names=F, col.names=F)
write.csv(prova.exercicio.dois[, c("nota", "numero.submissoes")], "UC2-Prova2.csv", quote=F, row.names=F, col.names=F)
write.csv(prova.exercicio.tres[, c("nota", "numero.submissoes")], "UC2-Prova3.csv", quote=F, row.names=F, col.names=F)
