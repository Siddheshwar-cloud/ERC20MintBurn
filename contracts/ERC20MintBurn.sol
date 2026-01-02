// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ERC20MintBurn {
    string public name;
    string public symbol;
    uint8 public decimals = 18;

    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;

        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // ---------------- ERC20 CORE ----------------

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        require(_spender != address(0), "Invalid spender");

        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");

        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // ---------------- MINT & BURN ----------------

    function mint(address _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "Invalid address");

        uint256 amountWithDecimals = _amount * (10 ** uint256(decimals));

        totalSupply += amountWithDecimals;
        balanceOf[_to] += amountWithDecimals;

        emit Transfer(address(0), _to, amountWithDecimals);
    }

    function burn(uint256 _amount) external {
        uint256 amountWithDecimals = _amount * (10 ** uint256(decimals));
        require(balanceOf[msg.sender] >= amountWithDecimals, "Insufficient balance");

        balanceOf[msg.sender] -= amountWithDecimals;
        totalSupply -= amountWithDecimals;

        emit Transfer(msg.sender, address(0), amountWithDecimals);
    }

    // ---------------- OWNERSHIP ----------------

    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid owner");

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}
