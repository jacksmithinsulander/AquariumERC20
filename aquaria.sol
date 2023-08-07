// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

contract Aquaria {
    event FryFish(address indexed fryer);
    event FryShoaling(address indexed fryer);
    event Transer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    struct AquariaInfo {
        string name;
        string symbol;
        uint8 decimals;
        uint24 totalSupply;
        mapping(address => uint16) balanceOf;
        mapping(address => uint24) allowance;
    }

    AquariaInfo aquaria;

    constructor() {
        aquaria.name = "Aquaria";
        aquaria.symbol = "FISH";
        aquaria.decimals = 7;
        aquaria.totalSupply = 1;
        aquaria.balanceOf[msg.sender] = 1;
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
        return aquaria.balanceOf[_owner];
    }

    function allowance(address _owner) public view returns (uint24 remaining) {
        return aquaria.allowance[_owner];
    }

    function transfer(address _to, uint16 _value) public returns (bool success) {
        require(_value <= aquaria.balanceOf[msg.sender], "Go fish dude, you are out of fish");
        require(_to != address(0), "Invalid recipient");
        aquaria.balanceOf[msg.sender] -= _value;
        
        return true;
    }
}
