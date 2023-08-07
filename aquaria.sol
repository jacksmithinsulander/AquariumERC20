// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

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

    struct FishHierarchy {
        uint40 fish;
        uint24 shoaling;
    }

    struct SubToken {
        string symbol;
        uint56 totalSupply;
        mapping(address => uint40) allowance;
    }

    struct AquariaInfo {
        string name;
        uint8 decimals;
        mapping(address => FishHierarchy) balanceOf;
        SubToken fish;
        SubToken shoaling;
        //mapping(address => uint24) allowance;
    }

    AquariaInfo private aquaria;

    constructor() {
        aquaria.name = "Aquaria";
        aquaria.fish.symbol = "FISH";
        aquaria.decimals = 7;
        aquaria.fish.totalSupply = convertToDecimal(1);
        FishHierarchy memory fish = FishHierarchy(
            uint40(convertToDecimal(1)),
            0
        );
        aquaria.balanceOf[msg.sender] = fish;
        aquaria.fish.allowance[msg.sender] = 0;
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
        return aquaria.balanceOf[_owner].fish;
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
            _value <= aquaria.balanceOf[_from].fish,
            "Go fish dude, you are out of fish"
        );
        require(_to != address(0), "Invalid recipient");
        uint16 feeAmount = (_value * 1) / 100;
        uint16 transferAmount = _value - feeAmount;

        aquaria.balanceOf[_from].fish -= _value;
        aquaria.balanceOf[zeroAddress].fish += feeAmount;
        aquaria.balanceOf[_to].fish += transferAmount;

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
        public
        returns (bool success)
    {
        return true;
    }
}
