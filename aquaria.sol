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

    struct FishHierarchy {
        uint16 fish;
        uint8 shoaling;
    }

    struct AquariaInfo {
        string name;
        string symbol;
        uint8 decimals;
        uint24 totalSupply;
        mapping(address => FishHierarchy) balanceOf;
        mapping(address => uint24) allowance;
    }

    AquariaInfo aquaria;

    constructor() {
        aquaria.name = "Aquaria";
        aquaria.symbol = "FISH";
        aquaria.decimals = 7;
        aquaria.totalSupply = 1;
        FishHierarchy memory fish = FishHierarchy(1, 0);
        aquaria.balanceOf[msg.sender] = fish;
        aquaria.allowance[msg.sender] = 0;
    }

    function name() public view returns (string memory) {
        return aquaria.name;
    }

    function symbol() public view returns (string memory) {
        return aquaria.symbol;
    }

    function decimals() public view returns (uint8) {
        return aquaria.decimals;
    }

    function totalSupply() public view returns (uint24) {
        return aquaria.totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint16) {
        return aquaria.balanceOf[_owner].fish;
    }

    function allowance(address _owner) public view returns (uint24 remaining) {
        return aquaria.allowance[_owner];
    }

    function transferFrom(address _from, address _to, uint16 _value) public returns (bool success) {
        require(_from == msg.sender);
        require(_value <= aquaria.balanceOf[_from].fish, "Go fish dude, you are out of fish");
        require(_to != address(0), "Invalid recipient");
        uint16 feeAmount = (_value * 1) / 100;
        uint16 transferAmount = _value - feeAmount;

        aquaria.balanceOf[_from].fish -= _value;
        aquaria.balanceOf[zeroAddress].fish += feeAmount;
        aquaria.balanceOf[_to].fish += transferAmount;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transfer(address _to, uint16 _value) public returns (bool success) {
        bool isSent = transferFrom(msg.sender, _to, _value);
        return isSent;
    }
}