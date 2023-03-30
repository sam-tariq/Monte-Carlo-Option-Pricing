library(psych)
### Monte Carlo Simulation
#Pricing Inputs
# Stock Price
S0 <- 20
#Strike Price
X <- 20
# Sigma
sig <- 0.4
# Maturity
T <- 0.25
# Interest Rate
r <- 0.03
# Steps
m <- 20
# Iterations
n <- 1000
# Seed
seed <- 12
#Option Styles for function 2
option_style <- list("Float_Look_Back", "Fixed_Look_Back", "Asian_Arithmetic",
                     "Asian_Geometric", "Asset_or_Nothing")
#Option Types for function 2
option_type <- list("call","put")

#Function 1
myfunc1<-function(S0,T,m,sig,r,n,seed){
  #Time interval per step
  t<-T/m
  #Generating matrix of random numbers
  nvars<-m*n
  set.seed(seed)
  e <- as.vector(rnorm(n=nvars, m=0, sd=1))
  E <- matrix(e,nrow = n,ncol = m)
  
  #Converting random variables to multiplicative factor
  fac <- exp((r-.5*sig^2)*t+sig*sqrt(t)*E) 
  
  #Creating Stock Price Paths
  fac1 <- t(apply(fac,1,cumprod))
  Stock_Price <- fac1*S0
  
  #Calculating the Summary measures
  #Mean Ending Price
  Mean_Ending_Price<-lapply(list(Stock_Price[,m]), mean, na.rm = TRUE)
  
  #Mean Max Price
  Max_Price<-apply(Stock_Price, 1, max, na.rm = TRUE)
  Mean_Max_Price<-mean(Max_Price)
  
  #Mean Min Price
  Min_Price<-apply(Stock_Price, 1, min, na.rm = TRUE)
  Mean_Min_Price<-mean(Min_Price)
  
  #Compiling outputs in a list to return
  everything<-list(Stock_Price,Mean_Ending_Price,Mean_Max_Price,Mean_Min_Price)
  return(everything)
}
#Calling the first function
Output_func1 <- myfunc1(S0,T,m,sig,r,n,seed)

#Extracting Stock Price and printing first 2 rows
Stock_Price_2rows <- head(Output_func1[[1]],2)
print(Stock_Price_2rows)

#Extracting and Printing Summary Measures
Mean_Ending_Price<-Output_func1[[2]]
print(Mean_Ending_Price)

Mean_Max_Price<-Output_func1[[3]]
print(Mean_Max_Price)

Mean_Min_Price<-Output_func1[[4]]
print(Mean_Min_Price)

#Function 2 

myfunc2<-function(S0,T,m,sig,r,n,seed,X,option_type,option_style){
  #Calling the first function
  Output_func1 <- myfunc1(S0,T,m,sig,r,n,seed)
  #Extracting Stock Price
  Stock_Price <- Output_func1[[1]]
  #Ending Price
  Ending_Price<-Stock_Price[,m]
  #Max Price
  Max_Price<-apply(Stock_Price, 1, max, na.rm = TRUE)
  #Min Price
  Min_Price<-apply(Stock_Price, 1, min, na.rm = TRUE)
  
  #Time interval per step
  t <- T/m 
  #Present Value Factor
  PVfac <- exp(-r*T)
  
  #Calculating Float Look Back Option
  if (option_style == "Float_Look_Back") {
    if (option_type == "call") {
      Payoff <- ifelse(Ending_Price > Min_Price, Ending_Price - Min_Price, 0)
      Option_Price <- mean(PVfac * Payoff)}
    else if (option_type == "put") {
      Payoff <- ifelse(Ending_Price < Max_Price, Max_Price - Ending_Price, 0)
      Option_Price <- mean(PVfac * Payoff)}
  }
  #Calculating Fixed Look Back Option
  else if(option_style == "Fixed_Look_Back") {
    if (option_type == "call") {
      Payoff <- ifelse(Max_Price > X, Max_Price - X, 0)
      Option_Price <- mean(PVfac * Payoff)}
    else if (option_type == "put") {
      Payoff <- ifelse(X > Min_Price, X - Min_Price, 0)
      Option_Price <- mean(PVfac * Payoff)}
  } 
  #Calculating Asian Arithmetic Option
  else if(option_style == "Asian_Arithmetic") {
    Mean_Stock_Price <- apply(Stock_Price, 1, mean)
    if (option_type == "call") {
      Payoff <- ifelse(Mean_Stock_Price > X, Mean_Stock_Price - X, 0)
      Option_Price <- mean(PVfac * Payoff)}
    else if (option_type == "put") {
      Payoff <- ifelse(X > Mean_Stock_Price, X - Mean_Stock_Price, 0)    
      Option_Price <- mean(PVfac * Payoff)}
  }
  #Calculating Asian Geometric Option
  else if(option_style == "Asian_Geometric") {
    Geo_Mean_Stock_Price <- apply(Stock_Price, 1, geometric.mean, na.rm=T)
    if (option_type == "call") {
      Payoff <- ifelse(Geo_Mean_Stock_Price > X, Geo_Mean_Stock_Price - X, 0)
      Option_Price <- mean(PVfac * Payoff)}
    else if (option_type == "put") {
      Payoff <- ifelse(X > Geo_Mean_Stock_Price, X - Geo_Mean_Stock_Price, 0)
      Option_Price <- mean(PVfac * Payoff)}
  }
  #Calculating Asset or Nothing Option
  else if(option_style == "Asset_or_Nothing") {
    if (option_type == "call") {
      d1 <- (log(S0/X) + (r + sig^2/2)*T-t) / (sig*sqrt(T-t))
      Option_Price <- S0 * pnorm(d1)}
    
    else if (option_type == "put") {
      d1 <- (log(S0/X) + (r + sig^2/2)*T-t) / (sig*sqrt(T-t))
      Option_Price <- S0 * pnorm(-d1)}
  } 
  #Putting everything in a list
  everything2 <- list(S0, T, m, sig, r, n, seed, X,option_style, option_type, Option_Price)  
  #Defining an Empty dataframe
  df<-data.frame('Stock_Price' = numeric(0), 'Time to Maturity' = numeric(0),'Steps' = numeric(0),
                  'Standard Deviation' = numeric(0),'Interest Rate' = numeric(0), 'Iterations' = numeric(0),
                  'Seed Value' = numeric(0), 'Strike Price' = numeric(0),
                  'Option Style' = character(),'Option Type' = character(),
                  'Option Price'= numeric(0))
  #Assigning the output to the empty dataframe
  df[nrow(df) + 1,] <- everything2
  return(df)
}


#Defining an Empty Dataframe
df1<-data.frame('Stock_Price' = numeric(0), 'Time to Maturity' = numeric(0),'Steps' = numeric(0),
                'Standard Deviation' = numeric(0),'Interest Rate' = numeric(0), 'Iterations' = numeric(0),
                'Seed Value' = numeric(0), 'Strike Price' = numeric(0),
                'Option Style' = character(),'Option Type' = character(),
                'Option Price'= numeric(0))
#Using a Nested For loop to run all the option styles and option types 
#Storing the results in the empty dataframe to get a consolidated tabulated form
for (i in option_style){
  for(j in option_type){
    output <- myfunc2(S0,T,m,sig,r,n,seed,X,j,i)
    df1[nrow(df1)+1,] <- output
  }
}
print(df1)
