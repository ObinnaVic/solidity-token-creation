//SPDX-License-Identifier: MIT
pragma solidity >= 0.8.18;

contract ERC20 {
    //definition of variables for the token
    uint public totalSupply;
    string public name;
    string public symbol;
    address public owner;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    event Transfer(address indexed sender, address indexed recipient, uint amount);
    event Approve(address indexed owner, address indexed spender, uint amount);

    constructor() {
        owner= msg.sender;
        name = "Nkire";
        symbol = "BUNN";

        _mint(msg.sender, 1009e18);
    }

    function decimal() public pure returns(uint8) {
        return 18;
    }

    function _mint(address _owner, uint amount) internal {
        require(_owner != address(0), "Can not mint to an address 0");
        balanceOf[_owner]+= amount;
        totalSupply += amount;

        emit Transfer(address(0), _owner, amount);
    }

    function _burn(uint amount) public {
        require(owner == msg.sender, "You are not authorized");
        totalSupply -= amount;
    }

    function transfer(address _to, uint amount) public returns(bool) {
        return _transfer(msg.sender, _to, amount);
    }

    function _transfer(address sender, address recipient, uint amount) private returns (bool) {
        require(recipient != address(0), "Cant send to an address 0");
        uint senderAmount = balanceOf[sender];
        require(senderAmount >= amount, "Insufficient balance to send");

        balanceOf[sender] = senderAmount - amount;
        balanceOf[recipient]+= amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }


    function approve(address sender, address spender, uint amount) external returns (bool) {
        require(spender != address(0));
        allowance[msg.sender][spender] = amount;

        emit Approve(sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
        uint allowedAmount = allowance[sender][msg.sender];
        require(allowedAmount >= amount);

        allowance[sender][msg.sender] = allowedAmount - amount;

        emit Approve(sender, recipient, amount);
        
        return _transfer(sender, recipient, amount);
    }

}