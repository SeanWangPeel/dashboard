library(quantmod)

## Transaction History  
transaction <- read.table('transaction_history.csv', sep = ',', header = TRUE, stringsAsFactors = TRUE)

## Report


## Average Transaction Price
attach(transaction)
pr_by <- by(data = transaction, list(Ticker), #simplify = FALSE, 
   FUN = function(x){
      sum(x$Cost * x$Shares)/sum(x$Shares)
   })
pr <- as.numeric(pr_by)
names(pr) <- attributes(pr_by)$dimnames[[1]]
pr <- pr[order(names(pr))]
report <- round(pr, 2)

## Last Closing Price
getLastClosingPrice <- function(ticker){
   a <- getSymbols(ticker, src = "yahoo", ## warning
       from = Sys.Date() - 10,
       to = Sys.Date(),
       auto.assign = FALSE)
   as.numeric(a[nrow(a), 4])
}

cl <- sapply(levels(transaction$Ticker), FUN = getLastClosingPrice)
cl <- cl[order(names(cl))]
report <- rbind(report, round(cl, 2))


## Growth Rate up to date
percentage <- paste0(round((cl - pr) / pr * 100, 2), '%')
names(percentage) <- names(cl)
report <- rbind(report, percentage)


## Portion by total market value
pr_by <- by(data = transaction, list(Ticker), #simplify = FALSE, 
            FUN = function(x){
              sum(x$Cost * x$Shares)
            })
pr <- as.numeric(pr_by)
names(pr) <- attributes(pr_by)$dimnames[[1]]
pr <- pr[order(names(pr))]
pr1 <- pr/sum(pr)
pr1 <- paste0(round(pr1 * 100, 0), '%')
report <- rbind(report, pr1)
# MUB       VEA       VTI       VWO 
# 0.4285549 0.1670508 0.2888531 0.1155412

## Report bullet point tag
rownames(report) <- c('Cost Price',
                      'MKT Value',
                      'Growth Rate',
                      'Proportion')





# chartSeries(data, type = 'candlesticks')



###############################################################################
##                                                                           
##                                              
##
###############################################################################
