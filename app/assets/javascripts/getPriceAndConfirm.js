
$(function(){
let getPriceForm = document.getElementById("getPriceForm")
let confirmTradeContainer = document.getElementById("confirmTradeContainer")
let getPriceButton = document.getElementById("getPriceButton")
let cancelPurchaseBtn = document.getElementById("cancelPurchaseBtn")


function hideGetPrice(event) {
    event.preventDefault()
    getPriceForm.style.display = "none";
    confirmTradeContainer.style.display = "block"
}

function returnToGetPrice(event){
    event.preventDefault()
    getPriceForm.style.display = "block";
    confirmTradeContainer.style.display = "none"
}

getPriceButton.addEventListener("click", hideGetPrice )
cancelPurchaseBtn.addEventListener("click", returnToGetPrice)
});