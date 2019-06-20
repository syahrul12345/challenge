
# Start your own Ethereum node and deploy them in under 10 minutes

Deploying a smart contract these days is easier than you think. By combining a popular framework called Embark with Chainstack’s capability  to quickly deploy Ethereum nodes on the Mainnet, smart contract deployment turns out to be a  breeze.

## Dependencies

Before starting this tutorial, you should install these dependencies:

[NodeJS & NPM] (https://nodejs.org/en/download/)

[Geth](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum)

Once we've installed these dependencies, we can isntall embark

```
npm install -g embark
```

Also you should install metamask to simplify the interaction process later on.


## Smart Contracts

Fractional ownership of an extremely expensive piece of asset can be made possible via smart contracts.

The Lisa Mona, a piece of outwork that costs approximately $100,000,000 is up for auction to small retail investors. Since retail investors do not have the funds to purchase the Lisa Mona in it's entirety, the Lisa Mona can be representated by 1000 tokens on the Ethereum Virtual machine. Hence, owning 1 token is equivalent to owning 1/1000 of the Lisa Mona, worth exactly $100,000 per token. Asset tokenization also makes it easy for investors to trade tokens as they deem fit.

I've designed a simple smart contract to tokenize the Lisa Mona, called Art.sol.

### Art.sol

```
pragma solidity = 0.5.0;

contract Art{
  uint public supply;
  uint public pricePerEth;
  mapping( address => uint ) public balance;

  constructor() public {
    supply = 1000;                    // There are a total of 1000 'mini' Lisa Monas
    pricePerEth = 100000000000000000; // One 'mini' Lisa Monas costs 0.1 Ethers
  }
  
  function check() public view returns(uint) {
    return balance[msg.sender];
  }
  function () external payable {
    balance[msg.sender] += msg.value/pricePerEth; // adds 'mini' Lisa Monas to how much Eth is sent by the investor
    supply -= msg.value/pricePerEth;              //subtracts the remaining 'mini' Lisa Monas from the total supply
  }
}
```

We've set the price of one Lisa Mona tokens to be 0.1 Ether. This means that to own 1/1000 of a Lisa Mona, an investor simply has to send 0.1 Ether to the smart contract.

Save the code above as Art.sol. We will be using Embark to deploy the Smart Contract to the Ethereum Testnet(Ropsten) so you can deploy & interact with it without spending real Ethers.

## Spinning up your Ethereum node

When a developer wants to deploy a smart contract, the transaction is broadcast to a node. The developer has to trust that the remote node is perfectly honest, in technical parlance, non-byzantine. A better option would be to run your own full Ethereum node, which comes with several benefits such as:

1. No throttling for high usage
2. Ensuring that all transactions made to the blockchain are correct
3. Lower latency if the node is located in the same geographical location

Let's start by signing up for a free 14-day trial [here](https://console.chainstack.com)


Chainstack makes it easy to create a Ropsten testnet node. Normally this can take up to 12 hours, but Chainstack's bolt does all of this in only 10 Minutes. Since we don't want to spend real ether, let's deploy our smart contracts to a Ropsen node. 

![alt-text](https://syahrul12345.github.io/challenge/assets/images/1.PNG)

We’ll call our project Embark, choosing the ‘Public Chain’ as our project type (naturally, because we are dealing with Ethereum, which is a public chain). Click ‘Create’, and you have your project ready. Now click the Embark project listing to get the ‘Join network’ modal. This is where you will specify various parameters to join the Ethereum network.

Follow the steps below to configure your own ropsen node


Nodes participating in a blockchain hold a local copy of the blockchain in storage. In the case of Ethereum, close to 200GB of data synchronization will take place in the background so that you can become part of the Ethereum network with your own fully synced node. This might take a few minutes, but not hours or days as is common if you were to do it manually. When the node status changes to Running, you know you have arrived on Ethereum Mainnet without breaking a sweat.


## Smart Contract Deployment

On our local machine, let's create a new embark project

```
embark new Art
cd Art
```

Now, lets copy the Smart Contract that we created earlier into the ```contracts``` folder.

```
cp \path\to\art.sol .\contracts
```

We're ready to deploy our contract. Buit how do we get Embark to connect to our chainstack that we just created? To do so, let's create a wallet that will deploy the contract to the network. 


```
get account new
```

Follow the instructions to create your new account. For this tutorial, we will be using a keystore file. You can get the path to the keystore file by typing:

```
geth account list
```

This generates the addresses you have created along with the path to the respective keystore files. Let’s assume that the keystore file is at ```/PATH/TO/KEYSTORE/UTC-123.123``` for the rest of the tutorial.

Let's also copy the keystore file to the project directory so we can easily import it into Metamask later on.

```
/PATH/TO/KEYSTORE/UTC-123.123 .
```

Now let's import the keystore file into Metamask:

![alt-text](https://imgur.com/tyfsl1f)

Copy the address of the wallet and claim some ropsten ethers here : https://faucet.ropsten.be/


### Connecting to the chainstack node

Now go to the node details page in Chainstack, and get its RPC endpoint. If you forgot how to do that, simply log in to Chainstack and then navigate to your projects page. Click on your project Embark. Following that, click on your network name, and in the next page choose the node that you want to connect to. It should bring you to this page: 

Take note of the RPC and WS endpoints at the end.

The file located ```/config/contracts.js``` contains the environment configurations. This file tells embark the node to connect to. Let's create one for this tutorial called ```chainstack```. Copy the code below and append it to the end of ```contracts.js``` before the last curly brackets. Be sure to change the variables for ```privateKeyfile```,```password``` and ```host``` accordingly.

```
chainstack: {
    deployment:{
      accounts: [
        {
          privateKeyFile:"/PATH/TO/KEYSTORE/UTC-123.123",
          password:"PASSWORD"
        }
      ],
      host:"RPC_ENDPOINT",
      port:false,
      protocol:"https",
      type:"rpc"
    
    },
    dappConnection: [
      "$WEB3",  // uses pre existing web3 object if available (e.g in Mist)
      "ws://localhost:8546",
      "http://localhost:8545"
    ],
    gas: "auto",

  }
...
```

We're all set. To deploy the contract run the code below in the root of the directory.

```
embark run chainstack
```

The ```chainstack``` argument after ```run``` tells embark to use the ```chainstack``` config in contract.js.

Your terminal should display something like this:

![alt-text](https://imgur.com/Z8CndmQ)

Congratulations, you've successfully deployed your own contract.

## Interacting with the Smart Contract

Embark conveniently creates for us a front end application (called Cockpit)for us to play with our contract.

Enter this into the browser of your choice:

```
http://localhost:55555/explorer/contracts/Art
```

You'll be prompted for the login token. Simply go to your terminal an type ```token```. This immediately generates and copies the token to your clipboard. Go back to your browser and you can now log in.

You'll now be at the contract page of the Smart Contract which you just deployed. Feel free to click on any of the functions and experiment. 

![alt-text](https://imgur.com/qMDiarT)

### Sending some Ethers to the smart contract

Let's use the same Ethereum account which deployed Art.sol to send some Ethers and get 'mini' Lisa Monas in return. 

First let's check how many 'mini' Lisa Monas that we own. Just execute the check() function in Embark's cockpit. Not suprisingly, it returns the value of 0.
```
check() //returns 0
balance() //returns 1000
```

Now copy the address of the Smart Contract and send some Ethers to this address. Let's start by sending 0.1 Ether. 

![alt-text]()

Going back to Embark's cockpit, let's try calling the functions check() and supply().

```
check() //returns 1
balance() //returns 999
```

Voila! You've just purchased 1 'mini' Lisa Monas, and officially own exactly 1/1000 Lisa Mona. Congratulations, you've just deployed and interacted with your own smart contract!

## Conclusion

By using popular frameworks such as embark combined with Chainstack's super fast node deployment process 
