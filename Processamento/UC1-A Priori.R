library(plyr)

dados.exercicios.submetidas = read.csv("../Dados/exercicios-20112.csv")
dados.exercicios.submetidas = dados.exercicios.submetidas[dados.exercicios.submetidas$nota == 10.0, ]

# print(nrow(dados.exercicios.submetidas))

dados.exercicios.submetidas = dados.exercicios.submetidas[, c("matricula", "questao")]
colnames(dados.exercicios.submetidas) = c("matricula", "exercicio")
dados.exercicios.submetidas = unique(dados.exercicios.submetidas)

exercicios.um = dados.exercicios.submetidas[dados.exercicios.submetidas$exercicio < 86, ]
print(nrow(exercicios.um))
exercicios.dois = dados.exercicios.submetidas[dados.exercicios.submetidas$exercicio > 85 & dados.exercicios.submetidas$exercicio < 165, ]
print(nrow(exercicios.dois))
exercicios.tres = dados.exercicios.submetidas[dados.exercicios.submetidas$exercicio > 164, ]
print(nrow(exercicios.tres))


ajeitar.nota = function(string) {
  return(as.double(paste(substr(string, 1, 1), ".", substr(string, 3, 3), sep="")))
}

prepara.data.frame.provas = function(dados, limiar=7) {
  
  df = data.frame(matricula=c(), questao=c())
  
  for (i in 1:nrow(dados)) {
    q = c()

    if (!is.na(dados[i, "questao1"]) & dados[i, "questao1"] >= limiar)
      q[length(q) + 1] = 1
    if (!is.na(dados[i, "questao2"]) & dados[i, "questao2"] >= limiar)
      q[length(q) + 1] = 2
    if (!is.na(dados[i, "questao3"]) & dados[i, "questao3"] >= limiar)
      q[length(q) + 1] = 3
    if (!is.na(dados[i, "questao4"]) & dados[i, "questao4"] >= limiar)
      q[length(q) + 1] = 4
    
    for (j in q)
      df = rbind(df, data.frame(matricula=dados[i, "Matrícula"], questao=j))
  }
  
  return(df)
}

ajeita.provas = function(filename, q1, q2, q3, q4) {
  dados = read.csv(filename)
  
  dados$questao1 = ajeitar.nota(dados[, q1])
  dados$questao2 = ajeitar.nota(dados[, q2])
  dados$questao3 = ajeitar.nota(dados[, q3])
  dados$questao4 = ajeitar.nota(dados[, q4])
  
  dados = dados[, c("Matrícula", "questao1", "questao2", "questao3", "questao4")]
  dados = unique(dados)
  
  return(prepara.data.frame.provas(dados))
}

prova.um = ajeita.provas("../Dados/Prova1.csv", "X86", "X87", "X88", "X89")
prova.dois = ajeita.provas("../Dados/Prova2.csv", "X165", "X166", "X167", "X168")
prova.tres = ajeita.provas("../Dados/Prova3.csv", "X191", "X192", "X193", "X194")

prova.exercicio.um = merge(prova.um, exercicios.um, by="matricula")
prova.exercicio.um = prova.exercicio.um[, c("questao", "exercicio")]
prova.exercicio.dois = merge(prova.dois, exercicios.dois, by="matricula")
prova.exercicio.dois = prova.exercicio.dois[, c("questao", "exercicio")]
prova.exercicio.tres = merge(prova.tres, exercicios.tres, by="matricula")
prova.exercicio.tres = prova.exercicio.tres[, c("questao", "exercicio")]

write.csv(prova.exercicio.um, "provaExercicioUm.csv", quote=F, row.names=F)
write.csv(prova.exercicio.dois, "provaExercicioDois.csv", quote=F, row.names=F)
write.csv(prova.exercicio.tres, "provaExercicioTres.csv", quote=F, row.names=F)
