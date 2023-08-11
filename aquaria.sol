// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

contract DexRouter {
    function getAmountOut(
        uint256,
        uint256,
        uint256
    ) public returns (uint256) {}
}

interface ERC20Token {
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool);
}

contract Aquaria {
    event FryFish(address indexed fryer);
    event FryShoaling(address indexed fryer);
    event Transfer(address indexed _from, address indexed _to, uint40 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    address constant zeroAddress = 0x000000000000000000000000000000000000dEaD;

    DexRouter dex;

    function Existing(address _dex) public {
        dex = DexRouter(_dex);
    }

    function getAmountOut(
        uint256 _amountOut,
        uint256 _reserveIn,
        uint256 _reserveOut
    ) public returns (uint256 result) {
        return
            dex.getAmountOut(
                uint256(_amountOut),
                uint256(_reserveIn),
                uint256(_reserveOut)
            );
    }

    address constant dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    function convertToDecimal(uint56 amount) internal view returns (uint56) {
        return uint56(amount * 10**uint56(aquaria.decimals));
    }

    struct SubToken {
        string symbol;
        uint56 totalSupply;
        uint56 circulatingSupply;
        mapping(address => uint40) allowance;
        mapping(address => uint40) balanceOf;
    }

    struct AquariaInfo {
        string name;
        uint8 decimals;
        uint56 burnedFish;
        SubToken fish;
        SubToken shoaling;
    }

    AquariaInfo private aquaria;

    constructor() {
        aquaria.name = "Aquaria";
        aquaria.decimals = 7;
        aquaria.fish.symbol = "FISH";
        aquaria.fish.totalSupply = convertToDecimal(1);
        aquaria.fish.circulatingSupply = convertToDecimal(1);
        aquaria.fish.balanceOf[msg.sender] = uint40(convertToDecimal(1));
        aquaria.fish.allowance[msg.sender] = 0;
        aquaria.shoaling.symbol = "SHOALING";
        Existing(dexRouter);
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

    function circulatingSupply() public view returns (uint56) {
        return aquaria.fish.circulatingSupply;
    }

    function burnedFish() public view returns (uint56) {
        return aquaria.burnedFish;
    }

    function universalBalanceOf(address _owner, string memory _token)
        public
        view
        returns (uint40)
    {
        if (
            keccak256(abi.encodePacked(_token)) ==
            keccak256(abi.encodePacked(aquaria.fish.symbol))
        ) {
            return aquaria.fish.balanceOf[_owner];
        } else if (
            keccak256(abi.encodePacked(_token)) ==
            keccak256(abi.encodePacked(aquaria.shoaling.symbol))
        ) {
            return aquaria.shoaling.balanceOf[_owner];
        } else {
            revert(
                "Invalid fish input. We only work with fish or shoaling here, pal"
            );
        }
    }

    function balanceOf(address _owner) public view returns (uint40) {
        return universalBalanceOf(_owner, aquaria.fish.symbol);
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
        aquaria.fish.circulatingSupply -= feeAmount;
        aquaria.burnedFish += feeAmount;
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

    function approve(address _spender, uint40 _value)
        public
        returns (bool success)
    {
        require(_spender == msg.sender, "Wrong wallet, fat finger.");
        aquaria.fish.allowance[_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function mintFish(address _minter, uint40 _value)
        public
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
        aquaria.fish.circulatingSupply += mintedAmount;
        return true;
    }

    function mergeFish(uint40 _value) public returns (bool success) {
        require(
            _value % convertToDecimal(100) == 0,
            "Wrong fish to shoaling ratio, noob"
        );
        require(
            _value <= aquaria.fish.allowance[msg.sender],
            "Illigal fish transaction, overrides allowance"
        );
        aquaria.fish.balanceOf[msg.sender] -= _value;
        aquaria.fish.circulatingSupply -= _value;
        aquaria.burnedFish += _value;
        aquaria.shoaling.balanceOf[msg.sender] += _value / 100;
        aquaria.shoaling.totalSupply += _value / 100;
        aquaria.shoaling.circulatingSupply += _value / 100;
        return true;
    }

    function flushToilet(address _shitcoin, uint256 _amount)
        public
        returns (bool success)
    {
        require(
            _shitcoin != address(0),
            "Cant fish with non existant shitcoins, dude"
        );
        ERC20Token shitcoin = ERC20Token(_shitcoin);
        require(
            shitcoin.transferFrom(msg.sender, address(this), _amount),
            "transaction failed"
        );
        uint40 mintableFish = uint40(
            getAmountOut(_amount, uint160(_shitcoin), uint160(address(this)))
        );
        mintFish(msg.sender, mintableFish);
        return true;
    }
}
