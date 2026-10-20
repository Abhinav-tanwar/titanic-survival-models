set.seed(530304); n<-1200
Sex<-sample(c("female","male"),n,TRUE,c(.36,.64));Pclass<-sample(1:3,n,TRUE,c(.25,.22,.53));Age<-pmax(1,rnorm(n,30,14));SibSp<-rpois(n,.5);Parch<-rpois(n,.4);Fare<-round(exp(rnorm(n,4-.4*Pclass,.5)),2);Embarked<-sample(c("C","Q","S"),n,TRUE,c(.2,.1,.7))
prob<-plogis(.5+1.7*(Sex=="female")-.65*(Pclass-1)-.025*Age-.15*SibSp);Survived<-rbinom(n,1,prob);Age[sample(n,80)]<-NA
write.csv(data.frame(Survived,Sex,Pclass,Age,SibSp,Parch,Fare,Embarked),"data/synthetic_titanic.csv",row.names=FALSE)
