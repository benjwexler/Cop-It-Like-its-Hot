const convertToUsCurrency = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2
  })

  $( document ).on('turbolinks:load', function() {
const transactionStockSymbol = document.getElementById("transaction_stock_symbol")
const transactionShares = document.getElementById("transaction_shares")
const transactionPricePerShare = document.getElementById("transaction_price_per_share")
const holdingStockSymbol = document.getElementById("holding_stock_symbol")
const holdingShares = document.getElementById("holding_shares")
const createHoldingBtn = document.getElementById("createHoldingBtn")
const createTransactionBtn = document.getElementById("createTransactionBtn")
const confirmPurchaseBtn = document.getElementById("confirmPurchaseBtn")

let getPriceForm = document.getElementById("getPriceForm")
let confirmTradeContainer = document.getElementById("confirmTradeContainer")
let getPriceButton = document.getElementById("getPriceButton")
let cancelPurchaseBtn = document.getElementById("cancelPurchaseBtn")
// const hiddenPortfolioValuation = document.getElementById("hiddenPortfolioValuation").innerText
const hiddenAccountBalance = parseFloat(document.getElementById("hiddenAccountBalance").innerText)

const stocksInPortfolio = document.getElementsByClassName("holdingsStockName")
const numSharesOfEachStock = document.getElementsByClassName("holdingsSharesInteger")
const holdingsValuePerStock = document.getElementsByClassName("holdingsValuePerStock")

// the arguments passed to row will actually start at Zero

function getOpeningPrice(stockSymbol, quantity, row) {
    $.ajax({
        url: `https://api.iextrading.com/1.0/stock/${stockSymbol}/ohlc`,
        // dataType: 'jsonp',
        success: function (data) { 
            console.log(data.open.price)
            let openingPrice = data.open.price
            console.log("OPENING")
            evaluateStockPrices(stockSymbol, quantity, row, openingPrice)
        }

    });
}

let i = 0
let portfolioSum = 0

function evaluateStockPrices(stockSymbol, quantity, row, openingPrice) {
    $.ajax({
        url: `https://api.iextrading.com/1.0/stock/${stockSymbol}/price`,
        // dataType: 'jsonp',
        success: function (data) { 
            // console.log(data)
            console.log(data * quantity) 
            let currentPrice = (data * quantity)
            if (openingPrice > currentPrice ) {
                console.log("F frjfnjmf skimmy")
                holdingsValuePerStock[row].classList.add("stockInRed")
                stocksInPortfolio[row].classList.add("stockInRed")
            } else if (openingPrice === currentPrice) {
                holdingsValuePerStock[row].classList.add("stockNeutral")
                stocksInPortfolio[row].classList.add("stockNeutral")
            }
            holdingsValuePerStock[row].innerText = convertToUsCurrency.format(currentPrice)
            console.log(stocksInPortfolio.length)
            portfolioSum += currentPrice
            i++ 

            if(i === stocksInPortfolio.length) {
                console.log("READYREADYREADY")
                console.log(portfolioSum)
                document.getElementById("portfolioFloatSum").innerText = convertToUsCurrency.format(portfolioSum)
            }
        }

    });
}

console.log(stocksInPortfolio.length)

for(let i=0; i<stocksInPortfolio.length; i++) {
    console.log(stocksInPortfolio[i].innerText)
    console.log(numSharesOfEachStock[i].innerText)
    getOpeningPrice(stocksInPortfolio[i].innerText, numSharesOfEachStock[i].innerText, i)
    // evaluateStockPrices(stocksInPortfolio[i].innerText, numSharesOfEachStock[i].innerText, i)
}




function firstIexCall(stockSymbol, quantity ) {
    console.log("Hey")
    $.ajax({
        url: `https://api.iextrading.com/1.0/stock/${stockSymbol}/price`,
        // dataType: 'jsonp',
        success: function (data) {
            console.log(data)
            console.log(data * quantity)
            fullPrice = data * quantity
            if(fullPrice < hiddenAccountBalance) { 
            fullPrice = fullPrice.toFixed(2)
             

            document.getElementById("stockQuote").innerText = `${convertToUsCurrency.format(fullPrice)} is the cost for ${quantity} shares of ${stockSymbol.toUpperCase()}`
            // transactionStockSymbol.value = stockSymbol
            // transactionShares.value = quantity
            // transactionPricePerShare.value = data
            // holdingStockSymbol.value = stockSymbol
            // holdingShares.value = quantity
            // secondIexCall()
            
            
            // document.getElementById("buyStock").style.display = "none";
            // document.getElementById("priceQuoteContainer").style.display = "flex";
            } else {
                document.getElementById("stockQuote").innerText = ""
                // same as function returnToGetPrice, but without .prevent default (will refactor the function with if statement if time)
                getPriceForm.style.display = "block";
                confirmTradeContainer.style.display = "none"
                alert("Sorry, insufficient funds")
                
            }
        }, error: function (data) {
            alert("Please check that you submitted a valid ticker symbol")
        }

    });
}
function secondIexCall() {
    $.ajax({
        url: `https://api.iextrading.com/1.0/stock/${stockSymbol}/price`,
        // dataType: 'jsonp',
        success: function (data) {
            console.log(data)

            // fullPrice = data * quantity
            if(fullPrice < hiddenAccountBalance) { 
                transactionStockSymbol.value = stockSymbol
                transactionShares.value = quantity
                transactionPricePerShare.value = data
                holdingStockSymbol.value = stockSymbol
                holdingShares.value = quantity
                
            // clickHiddenForm()
            console.log("Transaction about to be made")
            submitHiddenForms()
            } else {
                alert("Sorry, insufficient funds")
            }
        }, error: function (data) {
            alert("Please check that you submitted a valid ticker symbol")
        }
    });

}

    $("#getPriceForm").submit(function (event) {
        event.preventDefault();
        stockSymbol = document.getElementById("stock_symbol").value
        stockSymbol = stockSymbol.toUpperCase()
        quantity = document.getElementById("numberOfShares").value
        // quantity = quantity.toUpperCase()
        quantity = parseFloat(quantity)
        //   var data = $(this).serializeArray();
        let fullPrice
        // console.log(quantity);
        console.log(parseInt(quantity))
        console.log("fniffj")
        console.log(Number.isInteger(quantity))

        if ((parseInt(quantity)) && (parseInt(quantity) > 0)) {

            
            // getPriceButton.click()
            // cancelPurchaseBtn.click()
            // if (symbolsObj[`${stockSymbol.toUpperCase()}`] === 1) {

            
                firstIexCall(stockSymbol, quantity) 

            // } else {
            //     alert("Fake Stock!")
            // }
        } else {
            // same as function returnToGetPrice, but without .prevent default (will refactor the function with if statement if time)
            getPriceForm.style.display = "block";
            confirmTradeContainer.style.display = "none"
            document.getElementById("stockQuote").innerText = ""
            alert("Please enter a valid quantity")
            
   
            
        }

        



    });


function hideGetPrice(event) {
    event.preventDefault()
    getPriceForm.style.display = "none";
    confirmTradeContainer.style.display = "block"
    event.preventDefault();
        stockSymbol = document.getElementById("stock_symbol").value
        quantity = document.getElementById("numberOfShares").value
        //   var data = $(this).serializeArray();
        let fullPrice
        console.log(quantity);
        console.log(parseInt(quantity))
        quantity = parseFloat(quantity)
        console.log(Number.isInteger(quantity))

        if ((Number.isInteger(quantity)) && (parseInt(quantity) > 0)) {

            // if (symbolsObj[`${stockSymbol.toUpperCase()}`] === 1) {

            
                firstIexCall(stockSymbol, quantity) 

            // } else {
            //     alert("Fake Stock!")
            // }
        } else {
            alert("Please enter a valid quantity")
        }
}

function returnToGetPrice(event){
    event.preventDefault()
    getPriceForm.style.display = "block";
    confirmTradeContainer.style.display = "none"
}

function submitHiddenForms() {
    createTransactionBtn.click()
}
            getPriceButton.addEventListener("click", hideGetPrice )
            cancelPurchaseBtn.addEventListener("click", returnToGetPrice)
            // confirmPurchaseBtn.addEventListener("click", submitHiddenForms)
            confirmPurchaseBtn.addEventListener("click", secondIexCall)
            // secondIexCall()

});

