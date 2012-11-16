library(plyr)

library(lattice)
library(ggplot2)
library(Hmisc)

MyTheme <- function(base_size = 10)
{
  # ggplot2 graph style
  structure(list(
    axis.line =         theme_blank(),
    axis.text.x =       theme_text(size = base_size * 0.8 , lineheight = 0.9, colour = "grey0", hjust = 1, angle = 0),
    axis.text.y =       theme_text(size = base_size * 0.8, lineheight = 0.9, colour = "grey0", hjust = 1),
    axis.ticks =        theme_segment(colour = "grey50"),
    axis.title.x =      theme_text(size = base_size),
    axis.title.y =      theme_text(size = base_size, angle = 90),
    axis.ticks.length = unit(0.05, "cm"),
    axis.ticks.margin = unit(0.3, "cm"),
    
    legend.background = theme_rect(colour=NA), 
    legend.key =        theme_rect(fill = "grey95", colour = "white"),
    legend.key.size =   unit(1.2, "lines"),
    legend.text =       theme_text(size = base_size * 0.7),
    legend.title =      theme_text(size = base_size * 0.8, face = "bold", hjust = 0),
    legend.position =   "right",
    
    panel.background =  theme_rect(fill = "white", colour = NA), 
    #panel.border =      theme_blank(), 
    panel.grid.major =  theme_line(colour = "white"),
    panel.grid.minor =  theme_line(colour = "grey95", size = 0.25),
    panel.margin =      unit(0.25, "lines"),
    
    strip.background =  theme_rect(fill = "grey80", colour = NA), 
    strip.label =       function(variable, value) value, 
    strip.text.x =      theme_text(size = base_size * 0.8),
    strip.text.y =      theme_text(size = base_size * 0.8, angle = -90),
    
    plot.background =   theme_rect(colour = NA),
    plot.title =        theme_text(size = base_size * 1.2),
    plot.margin =       unit(c(1, 1, 0.5, 0.5), "lines")
    ), class = "options")
}

dados.exercicios.submetidas = read.csv("../Dados/exercicios-20112.csv")
# 
# print("Colunas da Base:")
# print(colnames(dados.exercicios.submetidas))
# print(paste("Tamanho da Base em Linhas:", nrow(dados.exercicios.submetidas)))
# print(paste("Quantidade de Exercicios Submetidos:", length(unique(dados.exercicios.submetidas$questao))))
# print("")
# print("Filtrando a Base para Considerar apenas os Exercicios Submetidos Corretamente")
# print("")

dados.exercicios.submetidas = dados.exercicios.submetidas[dados.exercicios.submetidas$nota == 10.0, ]
# print(paste("Tamanho da Base em Linhas:", nrow(dados.exercicios.submetidas)))
# print(paste("Quantidade de Exercicios Submetidos Corretamente:", length(unique(dados.exercicios.submetidas$questao))))

png("Histograma - Exercicios Submetidos Corretamente.png", width=560, height=300)
# qplot(questao, data=dados.exercicios.submetidas, geom="histogram", binwidth=10)
ggplot(dados.exercicios.submetidas, aes(x=questao)) + geom_histogram(colour="white", fill="#56B4E9", binwidth=1) +
  xlab("Quest??o do Exerc??cio") + ylab("Quantidade de Submiss??es Corretas") +
  opts(
#     title="Exerc??cios Submetidos Corretamente"
#        , panel.grid.major = theme_blank()
       panel.grid.minor = theme_blank()
       , panel.background = theme_blank()
#        , axis.ticks = theme_blank()
       )

#   MyTheme()
# theme_bw()

# hist(dados.exercicios.submetidas[, "questao"], include.lowest=T, labels=T, main="Exercicios Submetidos Corretamente",
#      xlab="Questao dos Exercicios Submetidos Corretamente", ylab="Quantidade de Alunos que Submeteram tal Questao de Exercicios Corretamente")
dev.off()

ajeitar.nota = function(string) {
  return(as.double(paste(substr(string, 1, 1), ".", substr(string, 3, 3), sep="")))
}

imprime.hist.questoes = function(filename, label, questao1, questao2, questao3, questao4) {
  dados.prova = read.csv(filename)
#   print("Colunas da Base:")
#   print(colnames(dados.prova))
#   print(paste("Tamanho da Base em Linhas:", nrow(dados.prova)))
  
  dados.prova$questao1 = ajeitar.nota(dados.prova[, questao1])
  dados.prova$questao2 = ajeitar.nota(dados.prova[, questao2])
  dados.prova$questao3 = ajeitar.nota(dados.prova[, questao3])
  dados.prova$questao4 = ajeitar.nota(dados.prova[, questao4])
  
  quantidade.questoes.corretas = data.frame(matricula=c(), qtd.questoes=c())
  
  for (i in 1:nrow(dados.prova)) {
    qtd = 0
    if (!is.na(dados.prova[i, "questao1"]) & dados.prova[i, "questao1"] >= 7.0) {
      qtd = qtd + 1
    }
    if (!is.na(dados.prova[i, "questao2"]) & dados.prova[i, "questao2"] >= 7.0) {
      qtd = qtd + 1
    }
    if (!is.na(dados.prova[i, "questao3"]) & dados.prova[i, "questao3"] >= 7.0) {
      qtd = qtd + 1
    }
    if (!is.na(dados.prova[i, "questao4"]) & dados.prova[i, "questao4"] >= 7.0) {
      qtd = qtd + 1
    }
    
    if (nrow(quantidade.questoes.corretas[quantidade.questoes.corretas$matricula == dados.prova[i, "Matr??cula"], ]) == 0) {
      quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(matricula=dados.prova[i, "Matr??cula"], qtd.questoes=qtd))
    } else {
      qtd = qtd + quantidade.questoes.corretas[quantidade.questoes.corretas$matricula == dados.prova[i, "matricula"], "qtd.questoes"]
      quantidade.questoes.corretas[quantidade.questoes.corretas$matricula == i$matricula, "qtd.questoes"] = qtd
    }
  }
  
  hist(quantidade.questoes.corretas[, "qtd.questoes"], include.lowest=T, labels=T, main=label,
       xlab="N??mero de Quest??es Submetidos Corretamente", ylab="N??mero de Alunos que Submeteram tal Quantidade de Quest??es Corretamente")
}

# png("Histograma - Quantidade de Questoes da Prova Submetidas Corretamente.png", width=720, height=720)
# par(mfrow = c(1,3))
# imprime.hist.questoes("../Dados/Prova1.csv", "Quantidade de Quest??es da Prova 1 Submetidas", "X86", "X87", "X88", "X89")
# imprime.hist.questoes("../Dados/Prova2.csv", "Quantidade de Quest??es da Prova 2 Submetidas", "X165", "X166", "X167", "X168")
# imprime.hist.questoes("../Dados/Prova3.csv", "Quantidade de Quest??es da Prova 3 Submetidas", "X191", "X192", "X193", "X194")
# dev.off()

imprime.hist.acertos.por.questao = function(filename, label, questao1, questao2, questao3, questao4) {
  dados.prova = read.csv(filename)
#   print("Colunas da Base:")
#   print(colnames(dados.prova))
#   print(paste("Tamanho da Base em Linhas:", nrow(dados.prova)))
  
  dados.prova$questao1 = ajeitar.nota(dados.prova[, questao1])
  dados.prova$questao2 = ajeitar.nota(dados.prova[, questao2])
  dados.prova$questao3 = ajeitar.nota(dados.prova[, questao3])
  dados.prova$questao4 = ajeitar.nota(dados.prova[, questao4])
  
  quantidade.questoes.corretas = data.frame(questao=c(), qtd=c())
  
  qtd = 0
  for (j in 1:nrow(dados.prova)) {
    if (!is.na(dados.prova[j, "questao1"]) & dados.prova[j, "questao1"] >= 7.0) {
      qtd = qtd + 1
    } 
  }
  q = c()
  for (k in 1:qtd) {
    q[k] = 1
  }
  quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(questao=q, qtd.questoes=qtd))
  
  qtd = 0
  for (j in 1:nrow(dados.prova)) {
    if (!is.na(dados.prova[j, "questao2"]) & dados.prova[j, "questao2"] >= 7.0) {
      qtd = qtd + 1
    } 
  }
  q = c()
  for (k in 1:qtd) {
    q[k] = 2
  }
  quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(questao=q, qtd.questoes=qtd))
  
  qtd = 0
  for (j in 1:nrow(dados.prova)) {
    if (!is.na(dados.prova[j, "questao3"]) & dados.prova[j, "questao3"] >= 7.0) {
      qtd = qtd + 1
    } 
  }
  q = c()
  for (k in 1:qtd) {
    q[k] = 3
  }
  quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(questao=q, qtd.questoes=qtd))
  
  qtd = 0
  for (j in 1:nrow(dados.prova)) {
    if (!is.na(dados.prova[j, "questao4"]) & dados.prova[j, "questao4"] >= 7.0) {
      qtd = qtd + 1
    } 
  }
  q = c()
  for (k in 1:qtd) {
    q[k] = 4
  }
  quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(questao=q, qtd.questoes=qtd))
  
  
  
#   for (i in c("questao1", "questao2", "questao3", "questao4")) {
#     qtd = 0
#     
#     for (j in 1:nrow(dados.prova)) {
#       if (!is.na(dados.prova[j, i]) & dados.prova[j, i] >= 7.0) {
#         qtd = qtd + 1
#       } 
#     }
#     
#     q = c()
#     for (k in 1:qtd) {
#       q[k] = i
#     }
#     
#     quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(questao=q, qtd.questoes=qtd))
#   }
  
#   hist(quantidade.questoes.corretas[, "questao"], include.lowest=T, labels=T, main=label,
#        xlab="Questao Submetida Corretamente", ylab="Quantidade de Alunos que Submeteram tal Questoes Corretamente")
  ggplot(quantidade.questoes.corretas, aes(x=questao)) + geom_histogram(colour="black", fill="#56B4E9", binwidth = 0.5) +
    xlab("Quest??o") + ylab("N??mero de Alunos") +
    opts(panel.grid.minor = theme_blank(), panel.background = theme_blank())
}

# png("Histograma - Questoes da Prova Submetidas Corretamente.png", width=560, height=300)
# par(mfrow = c(1,3))
png("Histograma - Questoes da Prova 1 Submetidas Corretamente.png", width=200, height=300)
imprime.hist.acertos.por.questao("../Dados/Prova1.csv", "Quest??es da Prova 1", "X86", "X87", "X88", "X89")
dev.off()
png("Histograma - Questoes da Prova 2 Submetidas Corretamente.png", width=200, height=300)
imprime.hist.acertos.por.questao("../Dados/Prova2.csv", "Quest??es da Prova 2", "X165", "X166", "X167", "X168")
dev.off()
png("Histograma - Questoes da Prova 3 Submetidas Corretamente.png", width=200, height=300)
imprime.hist.acertos.por.questao("../Dados/Prova3.csv", "Quest??es da Prova 3", "X191", "X192", "X193", "X194")
dev.off()


# get.prova = function(filename, prova, questao1, questao2, questao3, questao4) {
#   dados.prova = read.csv(filename)
#   
#   dados.prova$questao1 = ajeitar.nota(dados.prova[, questao1])
#   dados.prova$questao2 = ajeitar.nota(dados.prova[, questao2])
#   dados.prova$questao3 = ajeitar.nota(dados.prova[, questao3])
#   dados.prova$questao4 = ajeitar.nota(dados.prova[, questao4])
#   
#   quantidade.questoes.corretas = data.frame(questao=c(), qtd=c())
#   
#   for (i in 1:4) {
#     qtd = 0
#     
#     for (j in 1:nrow(dados.prova))
#       if (!is.na(dados.prova[j, paste("questao", i, sep="")]) & dados.prova[j, paste("questao", i, sep="")] >= 7.0)
#         qtd = qtd + 1
#     
#     q = c()
#     for (k in 1:qtd)
#       q[k] = paste("", i, sep="")
#     
#     quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(questao=q, qtd.questoes=qtd))
#   }
#   
#   quantidade.questoes.corretas$prova = paste("Prova", prova)
#   
#   return(quantidade.questoes.corretas)
# }
# 
# provas = get.prova("../Dados/Prova1.csv", 1, "X86", "X87", "X88", "X89")
# provas = rbind(provas, get.prova("../Dados/Prova2.csv", 2, "X165", "X166", "X167", "X168"))
# provas = rbind(provas, get.prova("../Dados/Prova3.csv", 3, "X191", "X192", "X193", "X194"))
# 
# png("UC1-Histograma-Questoes das Provas Submetidas Corretamente.png", width=600, height=300)
# ggplot(provas, aes(x=questao)) + geom_histogram(colour="black", fill="#56B4E9", binwidth = 1) +
#   xlab("Quest??o") + ylab("N??mero de Alunos") +
#   scale_y_continuous(breaks=seq(0, 60, 5)) +
#   theme(panel.grid.minor = element_blank(), panel.background = element_blank()) +
#   facet_grid(. ~ prova)
# dev.off()
