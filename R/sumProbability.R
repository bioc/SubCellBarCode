#'@title Sum compartment test data probabilities to
#'neighborhood probabilities
#'@description Compartment levels classifications on the  test data are
#'summed up to associated neighborhood levels. It is a helper function.
#'@param df data.frame; test data classifications at the neighborhood
#'level and probablity vectors for each protein.
#'@export
#'@examples {
#'
#'df <- loadData(SubCellBarCode::hcc827Ctrl)
#'
#'c.prots <- calculateCoveredProtein(rownames(df), markerProteins[,1])
#'
#'set.seed(7)
#'c.prots <- sample(c.prots, 365)
#'cls <- svmClassification(c.prots, df, markerProteins)
#'
#'test.A <- cls[[1]]$svm.test.prob.out
#'
#'rep.obs <- replacePrediction(df = test.A, column = "Observation")
#'
#'neighborhood.repA <- replacePrediction(df=rep.obs, column = "svm.pred")
#'
#'sum.repA <- sumProbability(neighborhood.repA)
#'}
#'@return summed.df

sumProbability <- function(df){

    t.secretory.df <- data.frame(df[, colnames(df)[3:6]])
    t.secretory.df$Secretory <- apply(t.secretory.df, 1, sum)
    t.nuclear.df <- data.frame(df[, colnames(df)[7:10]])
    t.nuclear.df$Nuclear <- apply(t.nuclear.df, 1, sum)
    t.cytosol.df <- data.frame(df[, colnames(df)[11:15]])
    t.cytosol.df$Cytosol <- apply(t.cytosol.df, 1, sum)
    t.Mitochondria.df <- data.frame(df[, colnames(df)[16:17]])
    t.Mitochondria.df$Mitochondria <- apply(t.Mitochondria.df, 1, sum)

    summed.df <- data.frame(Proteins = rownames(df),
                            df[,colnames(df)[seq_len(2)]],
                            Secretory = t.secretory.df$Secretory,
                            Nuclear = t.nuclear.df$Nuclear,
                            Cytosol = t.cytosol.df$Cytosol,
                            Mitochondria = t.Mitochondria.df$Mitochondria)
    #temp neighborhood df
    t.n.df <- summed.df[,4:7]
    summed.df$svm.pred <- colnames(t.n.df)[apply(t.n.df, 1, which.max)]
    return(summed.df)
}