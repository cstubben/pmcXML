## PLOT the total number of PMC articles published in the Open access subset by Year

# run May 17, 2013 
## all artices  = all[sb]                = 2736623
## open         = open access[Filter]    = 605246


## run loop and SEARCH PMC for
##  <Year>[dp] AND open access[Filter]  
##  <Year>[dp] NOT open access[Filter]


years<- 2001:2013
pub_open <-vector("list", length(years))
pub_closed <-vector("list", length(years))


for(i in 1:length(years)){
  pub_closed[[i]] <-esearch(paste(years[i], "[dp] NOT open access[Filter]", sep=""), "pmc")[2]
  pub_open[[i]]   <-esearch(paste(years[i], "[dp] AND open access[Filter]", sep=""), "pmc")[2]
  Sys.sleep(.33)
}

x1 <- unlist(pub_open)
names(x1) <- years

x2 <- unlist(pub_closed)
names(x2) <- years


## PLOT


png("pmc_growth.png", 400, 400, point=16)
par(mar=c(4.5,4.5,1.5,1))

plot(years[-13], x1[-13]/1000, type="l", pch=16, col="blue", xlab="Year published", ylab="PMC Articles (thousands)", log='y', ylim=c(5,150), las=1  )
lines(years[-13], x2[-13]/1000, col="red")

legend(2001.5, 140, c("Open Access", "Closed"), lty=1, col=c("blue", "red"), bty='n')

dev.off()


