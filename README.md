# Stake based Booking for food shop (i.e. restaurants)

***
## 【Introduction of Stake based Booking】
- Stake based Booking is a dApp which is one of solution for reducing the problem of `"food loss" and "food waste"`.
  - That is related to SDG#2 (End Hunger) and SDG#12 (Ensure sustainable consumption and production patterns)  

&nbsp;

## 【Work flow】
1. Restaurants register with their wallet address and local organization (and local organization's wallet address) which they want to support

<br>

2. Customers books date and stake amount which is equal to amount of course meal they will eat at the booked day.
   (Customers also register their wallet address when they book)

<br>

3. At the booked day, 
  - In case of customers who didn't come to restaurants even though they booked, staked amount is not refund.
  - There are three type recipents below who can get amount which divide total staked amount by total number of booked customers plus restaurants plus local organization.
    - Customers who came to restaurants as they booked 
    - Restaurants which was booked
    - Local Organization which was specified by restaurants (i.e. NGO/NPO which based on local area)

&nbsp;


## 【Deep dive into Stake based Booking】
### 1) Project Title
- Stake based Booking

&nbsp;

### 2) Problem/Opportunity
- Problem
  - It has happened 

<br>

- Opportunity


&nbsp;

### 3) Value Proposition
- Aspect of local food shop
- Aspect of customer
- Aspect of local society
- Aspect of SDGs

&nbsp;

### 4) Underlying Magic

&nbsp;

***

## 【Setup】
### Setup wallet by using Metamask
1. Add MetaMask to browser (Chrome or FireFox or Opera or Brave)    
https://metamask.io/  


2. Adjust appropriate newwork below 
```
Ropsten Test Network
```

&nbsp;


### Setup backend
1. Deploy contracts to Ropsten Test Network
```
(root directory)

$ npm run migrate:Ropsten
```

&nbsp;


### Setup frontend
1. Execute command below in root directory.
```
$ npm run client
```

2. Access to browser by using link 
```
http://127.0.0.1:3000/stake-based-booking
```

&nbsp;

***

## 【References】
- Reference article of food loss and food waste
  - https://www.wri.org/blog/2015/09/what-s-food-loss-and-waste-got-do-sustainable-development-lot-actually
  - https://www.sdgfund.org/how-reduce-food-waste
  - http://www.fao.org/food-loss-and-food-waste/en/

<br>

- ETH🇮🇹Turin
  - Workshop, etc...：https://www.youtube.com/watch?v=gpvx5Gi6Ktc

