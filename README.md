# Monte Carlo Option Pricing

### Introduction

Options are financial instruments based on the value of underlying securities such as stocks. It gives the
buyer the right, but not the obligation, to buy or sell the underlying asset on an affirmed price on or before
an agreed upon expiration date. Options belong to a larger group of securities know as derivatives, whose
price is dependent on the price of something else. In case of options, it depends on the price of the asset.
Options are of two types, “Call” or “Put”. A Call option gives the holder the right to buy a stock while a
Put option gives the holder the right to sell the stock. A core purpose of Options is hedging. Hedging with
options is means to reduce risk at a reasonable cost. We can think of using options like an insurance policy,
to insure your investments against a downturn.

### Monte Carlo methods for Option Pricing

Monte Carlo methods are computational algorithms that solve a problem by repeated random sampling,
often used to solve problems where conventional approach are not useful. In finance we can use Monte Carlo
methods to price options which have complicated features. For Option Pricing we generate a large number of
random price paths for the underlying assets. Using these paths the associated payoff values of each option is
calculated. After which the payoff values are averaged and discounted to today to obtain the value of the
options.

### Exotic Options

Options can be further categorized into exotic options. These type of options differ from their traditional
counterparts in terms of their strike price, expiration date and payment structure. They are customization to
the needs of the holder and allow them a greater range of investment alternatives.

### Type of Exotic Options

### LookBack Options

A lookback option allows the holder to know the history of the option when it comes to the appropriate time
to exercise it. They are path depended and are traded over the counter. They are expensive to exercise so
they come at a cost. There are two types of lookback options, namely fixed and float.
The fixed lookback option has the the strike price fixed at purchase. The most favorable price of the underlying
asset is used instead of the current market price, when the option is exercised. For a float lookback option
the strike price is set automatically at maturity to the most beneficial price over the option’s life.
The fixed lookback option solves the market exit problem—the best time to get out. The floating lookback
solves the market entry problem—the best time to get in.

### Asian Options

Asian options also known as average options have their payoffs depending on the average price of the
underlying asset over a certain period of time. They are commonly traded as currencies and commodity
products. As compared to American and European options they are typically cheaper because of the fact
that their averaging feature reduces the volatility that comes with an option.
The average can be calculated in many ways. Typically the arithmetic average or geometric average of the
price is taken at discreet intervals.

### Asset or Nothing Option

An Asset or Nothing option is a type of digital option. Its payout is fixed after the underlying asset exceeds
the predetermined strike price. These options don’t allow the holder to take a position on the underlying
asset, rather they deliver a predetermined payout or nothing.
For a Call type option the holder receives a fixed payout after the underlying asset exceeds the predetermined
strike price. On the other hand for a Put type option, the holder receives a fixed payoff if the price of the
underlying asset is below the strike price on the option’s expiration date.
They can be an effective hedging mechanism under the right circumstances because of their simplified risk
and payout structure.

### Project Overview

In this project we aim to demostrate how to generate stock prices and producing the summary measures like
mean ending price, mean max price and mean min price of the generated stock prices. In addition to that we
also want to show how to effectively value different exotic options, working under the assumption that our
underlying asset are stocks, with the help of Monte Carlo Simulation.
Using the generated stock price paths we calculate the payoff of each option, averaging them and discounting
them to today in order to obtain the option price/value.

### Methodology

First we import the required library and define the inputs used in the two functions. To accomplish our
project requirements we wrote two functions. The first function generates random stock price paths while the
second function uses the stock price paths to value the specified exotic options.

### Stock Price Generation - Function 1

To generate random stock prices we define a function named myfunc1 which takes the stock price, time
to maturity, number of steps, number of iterations, seed value, interest rate and sigma-volatility of stock
prices as inputs. Inside the function we first calculate the time interval per step by dividing the Time to
maturity with number of steps. Then we generate the total number of variables by multiplying the number
of iterations with the number of steps. To get similar results we set the seed using the set.seed() function.
After which we generate a vector of normally distributed random number using the rnorm function, which is
used to generate the matrix of normally distributed random numbers.
Once we have the matrix we need to calculate the multiplicative factor, for which we use the Weiner process
formula. We then apply this factor to each row and calculate the cumulative return. By multiplying these
returns with the stock price we get the stock price paths. In the final part of the function we use the stock
price paths to calculate the mean ending price from the ending price path, the mean max price and the mean
min price by averaging the max and min of all price paths respectively. The output that we get is then stored
in a list and is shown using the return function.

### Function 1 Results

The first function outputs the generated stock price paths, the mean ending price, the mean max price and
the mean min price in the form of a list. However, to satisfy the requirements of the project we assign the
output of the function to a variable and using the index value of each item inside the output list we extract
them and assign them to their respective variables. In the case of stock price paths we output only the first
two rows using the head function.

### Option Price/Value Estimation - Function 2

In the second function we are calculating the Option Value/Price of various exotic options using the stock
prices generated in the first function. In addition to the inputs that we used for the first function we also use
the strike price, option type and exotic option type inputs for this function. Using which we calculate the
option price/value.
We first call the 1st function inside this function to get the generated stock prices. We then use these stock
prices to extract the ending price, max price and min price of the matrix of stock prices. After this we
calculate the time interval per step and present value factor, and use these values to calculate payoff and
option value/price of the exotic options.
Using nested if else statements we go through the pre-defined input lists of option type and option style to to
calculate the option value/price for both the call and put options for all exotic options mentioned. For this
assignment we did not use any packages and coded the formulas inside the function. Lastly we define an list
which is used to store the inputs we used for the function, the option type, the exotic option type and the
option value. This list is then stored inside an empty dataframe as a row to get the output in a tabulated
format.

### Function 2 Results

The second function outputs a data frame which contains the input values which we used for the function,
the option type, exotic option type and option value. However, our function generates the output for a single
option type and exotic option type at a time. So, to generate the outputs for each type we define an empty
data frame and use nested for loops to assign the outputs as rows to it. This allows us to simply print the
data frame which contains the output for all the option types used in the function.

### Conclusion

In this project we demonstrated the use of Monte Carlo simulations to generate stock price paths. We used
these price paths to determine the option value/price for both call and put option types for 4 exotic option
types, namely Float lookback, Fixed lookback, Asian option (using both arithmetic and geometric mean) and
Asset or Nothing. We achieved this by the use of two user defined functions which used predefined inputs.

### Use Case and Limitations
Monte Carlo Option Pricing are a particularly useful approach in the valuation of options with multiple
sources of uncertainty or with complicated features. However, as its true for all approaches and models, this
model is not perfect. It has certain limitations which need to identified as they effect the outcome of the
trade conducted by the options. Some them are:
1. Monte Carlo Option pricing is limited in that it can’t account for bear markets, recessions, or any other
kind of financial crisis that might impact potential results.
2. It doesn’t use implied volatility to price the options. Its defined as the market’s forecast of a likely
movement in a security’s price.
3. The model also assumes no early exercise, making it unsuitable for American options.
4. It will usually be too slow to be competitive to other approaches and most of the time its a method of
last resort.
