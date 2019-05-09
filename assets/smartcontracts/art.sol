pragma solidity = 0.5.0;

contract Art {
	uint public supply;
	uint public pricePerEth;

	mapping (address  => uint) public balance;

	constructor() public{
		supply = 1; // since we only have one Lisa Mona :)
		pricePerEth = 3; // price determines the number of
		                                      //total price in ETH for the 1 complete lisa mona
                                          //this is in wei, so 1 Lisa Mona = 3 Ethers
	}

	function buy() external payable {
		balance[msg.sender] += msg.value/100000000000000000;
	}

	function price() external view returns(uint) {
	    return pricePerEth;
	}

	function check() public view returns (uint) {
		return balance[msg.sender];
	}

	function transfer(address _to,uint _value) public {
		//check if sender has enough
		require(balance[msg.sender] >= _value );
		//protect against over flows
		require(balance[_to] + _value > balance[_to]);
		balance[msg.sender] -= _value;
		balance[_to] = _value;
	}

}
