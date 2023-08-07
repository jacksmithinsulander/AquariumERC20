// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

interface ERC20Token {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
}

contract Aquaria {
    event FryFish(address indexed fryer);
    event FryShoaling(address indexed fryer);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    address constant zeroAddress = 0x000000000000000000000000000000000000dEaD;

    function convertToDecimal(uint56 amount) internal view returns (uint56) {
        return uint56(amount * 10**uint56(aquaria.decimals));
    }

    struct SubToken {
        string symbol;
        uint56 totalSupply;
        mapping(address => uint40) allowance;
        mapping(address => uint40) balanceOf;
    }

    struct AquariaInfo {
        string name;
        uint8 decimals;
        SubToken fish;
        SubToken shoaling;
    }

    AquariaInfo private aquaria;

    constructor() {
        aquaria.name = "Aquaria";
        aquaria.decimals = 7;
        aquaria.fish.symbol = "FISH";
        aquaria.fish.totalSupply = convertToDecimal(1);
        aquaria.fish.balanceOf[msg.sender] = uint40(convertToDecimal(1));
        aquaria.fish.allowance[msg.sender] = 0;
        aquaria.shoaling.symbol = "SHOALING";
    }

    function name() public view returns (string memory) {
        return aquaria.name;
    }

    function symbol() public view returns (string memory) {
        return aquaria.fish.symbol;
    }

    function decimals() public view returns (uint8) {
        return aquaria.decimals;
    }

    function totalSupply() public view returns (uint56) {
        return aquaria.fish.totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint40) {
        return aquaria.fish.balanceOf[_owner];
    }

    function allowance(address _owner) public view returns (uint40 remaining) {
        return aquaria.fish.allowance[_owner];
    }

    function transferFrom(
        address _from,
        address _to,
        uint16 _value
    ) public returns (bool success) {
        require(_from == msg.sender, "You don't control these fish, my guy");
        require(
            _value <= aquaria.fish.allowance[_from],
            "Illigal fish transaction, overrides allowance"
        );
        require(
            _value <= aquaria.fish.balanceOf[_from],
            "Go fish dude, you are out of fish"
        );
        require(_to != address(0), "Invalid recipient");
        uint16 feeAmount = (_value * 1) / 100;
        uint16 transferAmount = _value - feeAmount;

        aquaria.fish.balanceOf[_from] -= _value;
        aquaria.fish.balanceOf[zeroAddress] += feeAmount;
        aquaria.fish.balanceOf[_to] += transferAmount;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transfer(address _to, uint16 _value)
        public
        returns (bool success)
    {
        bool isSent = transferFrom(msg.sender, _to, _value);
        return isSent;
    }

    function approve(address _spender, uint16 _value)
        public
        returns (bool success)
    {
        require(_spender == msg.sender, "Wrong wallet, fat finger.");
        aquaria.fish.allowance[_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function mintTokens(address _minter, uint16 _value)
        internal
        returns (bool success)
    {
        require(
            _minter == msg.sender,
            "You're trying to breed fish into someone elses wallet, don't do that"
        );
        require(
            _value <= aquaria.fish.allowance[_minter],
            "Illigal fish transaction, overrides allowance"
        );
        uint40 mintedAmount = _value * 2;
        aquaria.fish.balanceOf[_minter] += mintedAmount;
        aquaria.fish.totalSupply += mintedAmount;
        return true;
    }

    function flushToilet(address _shitcoin, uint256 _amount) external {
        
    }
}
