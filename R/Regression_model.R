# prediction with linear models : vect, circul, elliptic and quadratic

predict.scores.lm=function(Y,discretspace,map,
                           formula="~I(F1*F1)+I(F2*F2)+F1*F2",
                           pred.na=FALSE){
  ## map is a data.frame with F1 and F2 obtained after DR on the explained data Y
  notespr= nbconsos=matrix(0,nrow(discretspace),ncol(discretspace))
  pred.conso=preference=matrix(0,nrow = nrow(discretspace),ncol=ncol(Y))
  regs=vector("list",ncol(Y))
  nb.NA=vector("list",ncol(Y))
  pos.NA=vector("list",ncol(Y))
  ## Firts we preform all regressions
  for(j in 1:ncol(Y)){
    map.reg=cbind.data.frame(Y[,j],map)
    colnames(map.reg)[1]="Conso"
    modele=as.formula(paste("Conso",formula))
    regs[[j]]=lm(modele,data=map.reg)
    pred.conso[,j]=predict(regs[[j]],newdata=discretspace)

    if (pred.na==TRUE) {
      x=pred.conso[,j]
      x[x<0]=NA
      x[x>10]=NA
      pred.conso[,j]=x
      x=as.data.frame(x)
      nb.NA[[j]] <- apply(x,2,function(a) sum(is.na(a)))# nbre de NA pour chaque conso
      pos.NA[[j]]=which(is.na(x))# le point qui contient NA pour chaque consom
      occur.NA <- unlist(pos.NA)
      occur.NA=as.vector(occur.NA)
      occur.NA=as.data.frame(table(occur.NA))# nbre de NA en chaque point du plan pour tous les consos

    }
    else {
      nb.NA=0
      pos.NA=0
      occur.NA=0
    }
    preference[,j]=(pred.conso[,j]> mean(Y[,j]))
  }
  return(list(regression=regs,pred.conso=pred.conso,preference=preference,nb.NA=nb.NA,
              pos.NA=pos.NA, occur.NA=occur.NA))
}


